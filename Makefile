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

build_hello: hello.c
	${CC} ${STD} ${WFLAGS} ${BFLAGS} ${SFLAGS} hello.c -o hello.exe ${LDFLAGS}

test_hello: hello.exe
	python3 tests/hello_test.py $(realpath hello.exe)

build: build_hello

test: test_hello

all: build test
