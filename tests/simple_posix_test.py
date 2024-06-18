#!/usr/bin/env python3

import sys
import subprocess

# Executable name for testing.
name_executable = sys.argv[1]

# Run program and get stdout, stderr.
program = subprocess.Popen([name_executable], stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, universal_newlines = True)
output, error = program.communicate()

# Test.

## Compare exitcode.
if program.returncode != 0:
	print("[ERROR] Program should not be failed.")
	exit(-1)

## Empty error.
if error:
	print("[ERROR] On success, program should not write anything to stderr.")
	exit(-1)

## Compare output.
if output != "Hello!\nHello!\nHello!\n":
	print("[ERROR] Assertion.")
	exit(-1)
