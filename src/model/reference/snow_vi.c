//=======================================================================
// snow_vi.c
// ---------
// SNOW-Vi reference model that tries to follow the definition
// in the paper to the letter.
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
//=======================================================================

#include "snow_vi.h"
#include <stdio.h>

static const uint8_t sigma[16] = {0, 4, 8, 12, 1, 5, 9, 13,
				  2, 6, 10, 14, 3, 7, 11, 15};

// Convert bytes to 16-bit unsigned words, little-endian first.
uint16_t u8_u16(uint8_t lsb, uint8_t msb) {
  return (uint16_t) (msb << 8) | lsb;
}

// Initalize the given context based on the given key  and iv.
void snow_vi_init(struct snow_vi_ctx *ctx, const uint8_t *key, const uint8_t *iv) {
  // Load lfsr_a with key bytes, little endian order.
  int i;

  for (i = 0 ; i < 8 ; i++) {
    ctx->lfsr_a[i] = u8_u16(iv[(2 * i)], iv[(2 * i) + 1]);
    ctx->lfsr_a[i + 8] = u8_u16(key[(2 * i)], key[(2 * i) + 1]);

    ctx->lfsr_b[i] = 0x00;
    ctx->lfsr_b[i + 8] = u8_u16(key[(2 * i) + 16], key[(2 * i) + 17]);
  }
}

// Update to the next state.
void snow_vi_next(struct snow_vi_ctx *ctx) {
}

// Display the current state.
void snow_vi_display_state(struct snow_vi_ctx *ctx) {
  int i;

  printf("\n");
  printf("lfsr_a:\n");
  for (i = 0 ; i < 16 ; i++) {
    printf("0x%04x ", ctx->lfsr_a[i]);
  }
  printf("\n");

  printf("\n");
  printf("lfsr_b:\n");
  for (i = 0 ; i < 16 ; i++) {
    printf("0x%04x ", ctx->lfsr_b[i]);
  }
  printf("\n");
}

//=======================================================================
// EOF snow_vi.c
//=======================================================================
