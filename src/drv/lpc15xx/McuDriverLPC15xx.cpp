#include <LPC15xx.h>

#include <McuDriver.h>


/**
 * McuDriver singleton
 * @return The McuDriver class instance
 */
McuDriver* McuDriver::instance()
{
    static McuDriver instance;
    return &instance;;
}


void McuDriver::configure()
{
    SystemCoreClockUpdate();

    // Enable MRT timer
    LPC_SYSCON->SYSAHBCLKCTRL1 |= (1 << 0);
    LPC_SYSCON->PRESETCTRL1 &= ~(1 << 0);

    // Enable RIT timer
    LPC_SYSCON->SYSAHBCLKCTRL1 |= (1 << 1);
    LPC_SYSCON->PRESETCTRL1 &= ~(1 << 1);

    LPC_SYSCON->SYSAHBCLKCTRL0 |= (1 << 11); // MUX
    LPC_SYSCON->SYSAHBCLKCTRL0 |= (1 << 12); // SVM
    LPC_SYSCON->SYSAHBCLKCTRL0 |= (1 << 13); // IOCON

    // LPC I/O pins
    LPC_SYSCON->SYSAHBCLKCTRL0 |= (1 << 14); // PIO0
}
