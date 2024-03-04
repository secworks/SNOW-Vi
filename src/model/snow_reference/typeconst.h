//
//  typeconst.h
//  RefImp
//
//  Created by Patrik Ekdahl on 2024-03-04.
//

#ifndef typeconst_h
#define typeconst_h

#include "stdint.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

typedef union FSMR
{
    u32 w[4];
    u16 s[8];
    u8 b[16];
    
} u128;


typedef union LFSR_U
{
    u128 h[2];
    u32 w[8];
    u16 s[16];
    u8 b[32];
    
} LFSR;



#endif /* typeconst_h */
