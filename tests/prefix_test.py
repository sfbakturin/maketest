#!/usr/bin/env python3

import sys
import subprocess

name_executable = sys.argv[1]

def prefix(filename_input: str, filename_output: str):
	fin = open(filename_input, "r")
	fout = open(filename_output, "w")

	lines = fin.readlines()
	ns = [float(i) for i in lines[1].split(" ") if i.strip()]

	sum = 0.0
	for i in range(len(ns)):
		sum += ns[i]
		fout.write(str(sum) + " ")

def generate(n: int, fname: str):
	f = open(fname, "w")
	f.write(str(n) + "\n")
	for i in range(n):
		f.write(str(i + 1) + " ")
	f.write("\n")

def compare_files(filename1: str, filename2: str) -> bool:
	in1 = open(filename1, "r")
	in2 = open(filename2, "r")

	line1 = in1.readline()
	line2 = in2.readline()

	ns1 = [float(i) for i in line1.split(" ") if i.strip()]
	ns2 = [float(i) for i in line2.split(" ") if i.strip()]

	if len(ns1) != len(ns2):
		return False

	for x, y in zip(ns1, ns2):
		if x != y:
			return False

	return True

def test(n: int):
	filename_input = "input.txt"
	filename_output = "output.txt"
	filename_reference = "reference.txt"

	generate(n, filename_input)
	prefix(filename_input, filename_reference)

	program = subprocess.Popen([name_executable, filename_input, filename_output], stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, universal_newlines = True)
	output, error = program.communicate()

	if program.returncode != 0:
		print("[ERROR] Program should not be failed.")
		exit(-1)

	if error:
		print("[ERROR] On success, program should not write anything to stderr.")
		exit(-1)

	if not compare_files(filename_output, filename_reference):
		print("[ERROR] Assertion.")
		exit(-1)

test(5)
test(15)
test(1)
test(4096)
