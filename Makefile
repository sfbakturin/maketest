# CC - compiler.
# BUILDTYPE (release/debug) - building program type.
# SANITIZER (none/thread/undefined/address/leak) - use sanitizer with building program.

# Standard usage.
STD := -ansi

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

# All builds.
build_${PROG_HELLO}: src/${PROG_HELLO}.c
	${CC} ${STD} ${WFLAGS} ${BFLAGS} ${SFLAGS} src/${PROG_HELLO}.c -o ${PROG_HELLO}.exe ${LDFLAGS}

# All tests.
test_${PROG_HELLO}: ${PROG_HELLO}.exe
	python3 tests/${PROG_HELLO}_test.py "${realpath ${PROG_HELLO}.exe}"

build: build_${PROG_HELLO}

test: test_${PROG_HELLO}

all: build test
