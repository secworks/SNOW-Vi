//
//  debug.h
//  RefImp
//
//  Created by Patrik Ekdahl on 2024-03-04.
//

#ifndef debug_h
#define debug_h

#include <stdio.h>
#include "typeconst.h"


void print_lfsr(char *name, LFSR r);
void print_128(char *name, u128 r);
void print_128_16(char *name, u128 r);
void print_u8(char *name, const u8 *b, int len);

#endif /* debug_h */
