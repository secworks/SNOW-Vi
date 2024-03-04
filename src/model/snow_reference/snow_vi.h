//
//  snow_vi.h
//  RefImp
//
//  Created by Patrik Ekdahl on 2024-03-04.
//

#ifndef snow_vi_h
#define snow_vi_h

#include <stdio.h>
#include "typeconst.h"

void SNOW_Vi_Init(const u8 * key, const u8 * iv);
u128 SNOW_Vi_Keystream(void);

#endif /* snow_vi_h */
