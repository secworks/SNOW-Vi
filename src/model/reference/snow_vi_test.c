//=======================================================================
// snow_vi_test.c
// --------------
// Test program for snow_vi. It use a set of keys and IVs to test
// the functionality of the reference model.
//
//
// Author: Joachim Strömbergon
// Copyright 2024 Assured AB
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
//
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
//
//=======================================================================

#include <stdio.h>
#include "snow_vi.h"

// Test keys and IVs
const uint8_t key[32] = {0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57,
			 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f,
			 0x0a, 0x1a, 0x2a, 0x3a, 0x4a, 0x5a, 0x6a, 0x7a,
			 0x8a, 0x9a, 0xaa, 0xba, 0xca, 0xda, 0xea, 0xfa};

const uint8_t iv[16] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
			0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10};

int main(void) {
  printf("snow_vi test started.\n");

  struct snow_vi_ctx my_ctx;
  snow_vi_init(&my_ctx, &key[0], &iv[0]);

  printf("key: ");
  for (int i = 0 ; i < 32 ; i++) {
    printf("%02x ", key[i]);
  }
  printf("\n");

  printf("iv:  ");
  for (int i = 0 ; i < 16 ; i++) {
    printf("%02x ", iv[i]);
  }
  printf("\n\n");

  printf("State after init.\n");
  snow_vi_display_state(&my_ctx);

  printf("snow_vi test completed.\n");

  return 0;
}

//=======================================================================
// EOF snow_vi_test.c
//=======================================================================
