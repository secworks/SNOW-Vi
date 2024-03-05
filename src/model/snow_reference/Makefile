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

clean:
	rm snow_reference
