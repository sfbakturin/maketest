# maketest

A small "project" that combines a simple and understandable Makefile and the use of the main features of GitHub Actions.

Idealogy: in the directory `src` the source files of ideologically different programs are stored, in the directory `tests` the simplest tests for testing programs using the "black box" method are stored.

Available build variables:

* **CC** - compiler used.
* **BUILDTYPE** (release/debug) - build type configuration.
* **SANITIZER** (none/thread/undefined/address/leak) - the sanitizer used (if it is a debug program).
* **DIRTESTS** - directory for tests.

Example:

```bash
CC=clang BUILDTYPE=release DIRTESTS=tests make build
```
