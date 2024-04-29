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

#include <stdio.h>
#include "snow_vi.h"

static const uint8_t sigma[16] = {0, 4, 8, 12, 1, 5, 9, 13,
				  2, 6, 10, 14, 3, 7, 11, 15};


uint16_t gmul(uint16_t a, uint16_t b) {
  if (a & 0x8000) {
    return (a << 1) ^ b;
  }
  else {
    return (a  << 1);
  }
}


// Convert bytes to 16-bit unsigned words, little-endian first.
uint16_t u8_u16(uint8_t lsb, uint8_t msb) {
  return (uint16_t) (msb << 8) | lsb;
}


void update_t1_t2(struct snow_vi_ctx *ctx) {
  for (int i = 0 ; i < 8 ; i++) {
    ctx->t1[i] = ctx->lfsr_b[i + 8];
    ctx->t2[i] = ctx->lfsr_a[i + 8];
  }
}


void update_lfsr(struct snow_vi_ctx *ctx) {
  uint16_t u;
  uint16_t v;

  u = gmul(ctx->lfsr_a[0], 0x4a6d) ^ ctx->lfsr_a[7] ^ ctx->lfsr_b[0];
  v = gmul(ctx->lfsr_b[0], 0xcc87) ^ ctx->lfsr_b[8] ^ ctx->lfsr_a[0];

  for (int i = 0 ; i < 15 ; i++) {
    ctx->lfsr_a[i] = ctx->lfsr_a[i + 1];
    ctx->lfsr_b[i] = ctx->lfsr_b[i + 1];
  }

  ctx->lfsr_a[15] = u;
  ctx->lfsr_b[15] = v;
}


void update_fsm(struct snow_vi_ctx *ctx) {
//  uint8_t next_r1[16];;
//  uint8_t aes_in[16];
//  uint8_t aes_out[16];
//
//    for (int i = 0; i < 16; i++) {
//        next_r1[i] = ((ctx->t2[i] ^ ctx->r3[idx]) + r2.w[idx]);
//    }
//
//    AESRound(r2.b, aes_out.b); //The second AES round
//    for (int idx = 0; idx < 16; idx++) {
//        r3.b[idx] = aes_out.b[idx];
//    }
//
//    AESRound(r1.b,aes_out.b);  //The first AES round
//    for (int idx = 0; idx < 16; idx++) {
//        r2.b[idx] = aes_out.b[idx];
//    }
//
//    for (int idx = 0; idx < 16; idx++) {
//        r1.b[idx] = next_r1.b[sigma[idx]];
//    }
}


void gen_z(struct snow_vi_ctx *ctx) {
  for (int i = 0 ; i < 8 ; i++) {
    ctx->z[i] = (ctx->t1[i] + ctx->r1[i]) ^ ctx->r2[i];
  }
}


void snow_vi_init(struct snow_vi_ctx *ctx, const uint8_t *key, const uint8_t *iv) {
  ctx->initialized = 0;

  // Load lfsr_a and lfsr_b with key and iv bytes, little endian order.
  for (int i = 0 ; i < 8 ; i++) {
    ctx->lfsr_a[i] = u8_u16(iv[(2 * i)], iv[(2 * i) + 1]);
    ctx->lfsr_a[i + 8] = u8_u16(key[(2 * i)], key[(2 * i) + 1]);

    ctx->lfsr_b[i] = 0x00;
    ctx->lfsr_b[i + 8] = u8_u16(key[(2 * i) + 16], key[(2 * i) + 17]);
  }

  update_t1_t2(ctx);

  for (int i = 0 ; i < 8 ; i++) {
    ctx->r1[i] = 0;
    ctx->r2[i] = 0;
    ctx->r3[i] = 0;
  }

  gen_z(ctx);

  //  snow_vi_next(ctx);

  ctx->initialized = 1;
}


// Update to the next state.
void snow_vi_next(struct snow_vi_ctx *ctx) {
  for (int i = 0 ; i < 8 ; i++) {
    update_lfsr(ctx);
  }

  if (ctx->initialized == 0) {
    for (int i = 0 ; i < 8 ; i++) {
      ctx->lfsr_a[i] = ctx->lfsr_a[i] ^ ctx->z[i];
      update_lfsr(ctx);
    }
  }
}


// Display the current state.
void snow_vi_display_state(struct snow_vi_ctx *ctx) {
  printf("Current state:\n");
  printf("--------------\n");
  printf("initalized: %1d\n", ctx->initialized);
  printf("lfsr_a: ");

  for (int i = 0 ; i < 16 ; i++) {
    printf("0x%04x ", ctx->lfsr_a[i]);
  }
  printf("\n");

  printf("lfsr_b: ");
  for (int i = 0 ; i < 16 ; i++) {
    printf("0x%04x ", ctx->lfsr_b[i]);
  }
  printf("\n");

  printf("r1:     0x%08x 0x%08x 0x%08x 0x%08x\n",
	 ctx->r1[0], ctx->r1[1], ctx->r1[2], ctx->r1[3]);
  printf("r2:     0x%08x 0x%08x 0x%08x 0x%08x\n",
	 ctx->r2[0], ctx->r2[1], ctx->r2[2], ctx->r2[3]);
  printf("r3:     0x%08x 0x%08x 0x%08x 0x%08x\n",
	 ctx->r3[0], ctx->r3[1], ctx->r3[2], ctx->r3[3]);
  printf("\n");

  printf("t1:     0x%04x 0x%04x 0x%04x 0x%04x\n",
	 ctx->t1[0], ctx->t1[1], ctx->t1[2], ctx->t1[3]);
  printf("t2:     0x%04x 0x%04x 0x%04x 0x%04x\n",
	 ctx->t2[0], ctx->t2[1], ctx->t2[2], ctx->t2[3]);
  printf("\n");

  printf("z:      0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x 0x%04x\n",
	 ctx->z[0], ctx->z[1], ctx->z[2], ctx->z[3],
	 ctx->z[4], ctx->z[5], ctx->z[6], ctx->z[7]);
  printf("\n");
}

//=======================================================================
// EOF snow_vi.c
//=======================================================================
