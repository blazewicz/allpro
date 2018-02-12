/**
 * See the file LICENSE for redistribution information.
 *
 * Copyright (c) 2009-2016 ObdDiag.Net. All rights reserved.
 *
 */

#ifndef __MCU_DRIVER_H__
#define __MCU_DRIVER_H__


using namespace std;

class McuDriver {
public:
    static McuDriver* instance();
    static void configure();
private:
    McuDriver() {}
};

#endif //__MCU_DRIVER_H__
