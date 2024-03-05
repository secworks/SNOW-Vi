#=======================================================================
# Makefile
# --------
# Simple Makefile for building the reference model and test program
#
#
#=======================================================================


C_FILES = aes.c debug.c main.c snow_v.c snow_vi.c
H_FILES = aes.h debug.h snow_v.h snow_vi.h typeconst.h

CC = clang
CC_FLAGS = -std=c11 -O2 -Wall -Wpedantic

all: snow_reference

snow_reference: $(C_FILES) $(H_FILES)
	$(CC) $(CC_FLAGS) -o snow_reference $(C_FILES)

flaws: $(C_FILES)
	flawfinder .

lint:  $(C_FILES)
	splint *.c

clean:
	rm snow_reference

help:
	@echo ""
	@echo "Supported targets:"
	@echo "------------------"
	@echo "all:            Build all targets."
	@echo "snow_reference: Build snow_reference."
	@echo "flaws:          Run flawfinder on the source files."
	@echo "lint:           Run splint on the source files."
	@echo "clean:          Remove all build artifacts."
	@echo ""
