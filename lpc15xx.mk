ARCHFLAGS += -mcpu=cortex-m3

INCDIRS += \
	lib/lpc15xx \
	lib/lpc15xx/chip_15xx \
	lib/lpc15xx/chip_common \
	src/drv/lpc15xx \

SRC_C += \
	src/system_LPC15xx.c \

SRC_CXX += 	\
	src/drv/lpc15xx/AdcLPC15xx.cpp \
	src/drv/lpc15xx/CanDriverLPC15xx.cpp \
	src/drv/lpc15xx/CmdUartLPC15xx.cpp \
	src/drv/lpc15xx/EcuUartLPC15xx.cpp \
	src/drv/lpc15xx/GpioDrvLPC15xx.cpp \
	src/drv/lpc15xx/AdptLEDLPC15xx.cpp \
	src/drv/lpc15xx/PwmDriverLPC15xx.cpp \
	src/drv/lpc15xx/SysutilityLPC15xx.cpp \
	src/drv/lpc15xx/TimerLPC15xx.cpp \
	src/drv/lpc15xx/McuDriverLPC15xx.cpp \
