//
//  debug.c
//  RefImp
//
//  Created by Patrik Ekdahl on 2024-03-04.
//

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
