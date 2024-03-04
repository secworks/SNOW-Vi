//
//  snow_v.h
//  RefImp
//
//  Created by Patrik Ekdahl on 2024-03-04.
//

#ifndef snow_v_h
#define snow_v_h

#include <stdio.h>
#include "typeconst.h"

void SNOW_V_Init(const u8 * key, const u8 * iv);
u128 SNOW_V_Keystream(void);

#endif /* snow_v_h */
