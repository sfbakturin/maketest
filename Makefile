# CC - compiler.
# BUILDTYPE (release/debug) - building program type.
# SANITIZER (none/thread/undefined/address/leak) - use sanitizer with building program.
# DIRTESTS - directory with tests.

# Standard usage.
STD := -std=c99

# Warnings flags.
WFLAGS := -Wall -Wextra -Wpedantic

# Sanitizers flags.
SFLAGS :=

# Linkage.
LDFLAGS :=

# Buildtype flags.
BFLAGS :=

# Setup sanitizers and build flags.
ifeq (${BUILDTYPE},release)
	BFLAGS += -O2
else ifeq (${BUILDTYPE},debug)
	BFLAGS += -g -O0
	ifneq (${SANITIZER},none)
		SFLAGS += -fno-sanitize-recover=all
		ifeq (${SANITIZER},thread)
			SFLAGS += -fsanitize=thread
		else ifeq (${SANITIZER},undefined)
			SFLAGS += -fsanitize=undefined
		else ifeq (${SANITIZER},address)
			SFLAGS += -fsanitize=address
		else ifeq (${SANITIZER},leak)
			SFLAGS += -fsanitize=leak
		else ifeq (${SANITIZER},memory)
			SFLAGS += -fsanitize=memory
		else
			$(error Sanitizer type is not supported)
		endif
	endif
else
	$(error Building type is not supported)
endif

# All programs.
PROG_HELLO := hello
PROG_PREFIX := prefix
PROG_POSIX := simple_posix

# All builds.

## hello
build_${PROG_HELLO}: src/${PROG_HELLO}.c
	${CC} ${STD} ${WFLAGS} ${BFLAGS} ${SFLAGS} src/${PROG_HELLO}.c -o ${PROG_HELLO}.exe ${LDFLAGS}

## prefix
build_${PROG_PREFIX}: src/${PROG_PREFIX}.c
	${CC} ${STD} ${WFLAGS} ${BFLAGS} ${SFLAGS} src/${PROG_PREFIX}.c -o ${PROG_PREFIX}.exe ${LDFLAGS}

## simple_posix
build_${PROG_POSIX}: src/${PROG_POSIX}.c
	${CC} ${STD} ${WFLAGS} ${BFLAGS} ${SFLAGS} src/${PROG_POSIX}.c -o ${PROG_POSIX}.exe ${LDFLAGS}

# All tests.

## hello
test_${PROG_HELLO}: ${PROG_HELLO}.exe
	python3 ${DIRTESTS}/${PROG_HELLO}_test.py "${realpath ${PROG_HELLO}.exe}"

## prefix
test_${PROG_PREFIX}: ${PROG_PREFIX}.exe
	python3 ${DIRTESTS}/${PROG_PREFIX}_test.py "${realpath ${PROG_PREFIX}.exe}"

## prefix
test_${PROG_POSIX}: ${PROG_POSIX}.exe
	python3 ${DIRTESTS}/${PROG_POSIX}_test.py "${realpath ${PROG_POSIX}.exe}"

build: build_${PROG_HELLO} build_${PROG_PREFIX} build_${PROG_POSIX}

test: test_${PROG_HELLO} test_${PROG_PREFIX} test_${PROG_POSIX}

all: build test
