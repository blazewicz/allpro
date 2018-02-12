#ifndef _DRIVER_DEFS_H_
#define _DRIVERS_DEFS_H "LPC15xx"

#include <LPC15xx.h>

static inline void wfi() {
    __WFI();
}

#elif _DRIVERS_DEFS_H_ != "LPC15xx"
#error "DriverDefs redefinition"
#endif