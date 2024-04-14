#=======================================================================
# Makefile
# --------
# Simple Makefile for building the snow_vi reference model and
# test program.
#
#
# Author: Joachim Strömbergon
# Copyright 2024 Assured AB
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#=======================================================================

C_FILES = snow_vi_test.c snow_vi.c
H_FILES = snow_vi.h

CC = clang
CC_FLAGS = -std=c11 -O2 -Wall -Wpedantic

all: snow_vi_test

snow_vi_test: $(C_FILES) $(H_FILES)
	$(CC) $(CC_FLAGS) -o snow_vi_test $(C_FILES)

flaws: $(C_FILES)
	flawfinder .

lint:  $(C_FILES)
	splint *.c

clean:
	rm snow_vi_test

help:
	@echo ""
	@echo "Supported targets:"
	@echo "------------------"
	@echo "all:          Build all targets."
	@echo "snow_vi_test: Build snow_reference."
	@echo "flaws:        Run flawfinder on the source files."
	@echo "lint:         Run splint on the source files."
	@echo "clean:        Remove all build artifacts."
	@echo ""
