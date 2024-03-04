// =====================================================================
//  debug.c
//  -------
//
// Copyright 2024 Patrik Ekdahl
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// 1. Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following
// disclaimer in the documentation and/or other materials provided
// with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
// CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
// USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
// AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// =====================================================================

#include "debug.h"

void print_128(char *name, u128 r) {

    if (name) {
        printf("%s : ", name);
    }
    for(int idx = 0; idx < 16; idx ++) {
        printf("%02X ", r.b[idx]);
    }
    printf("\n");

}

void print_128_16(char *name, u128 r) {
    if (name) {
        printf("%s : ", name);
    }
    for(int i = 0; i < 8; i++) {
        printf("%04X ", r.s[i]);
    }
    printf("\n");
}

void print_lfsr(char *name, LFSR r) {

    if (name) {
        printf("%s : ", name);
    }
    for(int idx = 0; idx < 32; idx ++) {
        printf("%02X ", r.b[idx]);
    }
    printf("\n");
}


void print_u8(char *name, const u8 *b, int len) {

    if (name) {
        printf("%s : ", name);
    }
    for(int idx = 0; idx < len; idx ++) {
        printf("%02X ", b[idx]);
    }
    printf("\n");
}
