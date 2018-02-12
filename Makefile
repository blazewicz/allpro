CROSS = arm-none-eabi-
CC = $(CROSS)gcc -c
CXX = $(CROSS)g++ -c
LD = $(CROSS)g++
OBJCOPY = $(CROSS)objcopy
SIZE = $(CROSS)size

ifeq ($(DEBUG), 1)
BUILD = target/debug
OPT = -O0 -g
else
BUILD = target/release
OPT = -Os
endif

ARCHFLAGS += -mcpu=cortex-m3

CFLAGS += $(ARCHFLAGS)
CFLAGS += -std=gnu99 -Wall -Werror -MMD
CFLAGS += -fshort-enums -ffunction-sections -fdata-sections
CFLAGS += $(OPT)
CFLAGS += $(INC)

CXXFLAGS += $(ARCHFLAGS)
CXXFLAGS += -std=c++11 -Wall -MMD
CXXFLAGS += -fshort-enums -ffunction-sections -fdata-sections
CXXFLAGS += -fno-rtti -fno-exceptions -fno-threadsafe-statics
CXXFLAGS += $(OPT)
CXXFLAGS += $(INC)

LDFLAGS += $(ARCHFLAGS)
LDFLAGS += $(OPT)
LDFLAGS += --specs=nano.specs --specs=rdimon.specs
LDFLAGS += -Wl,--gc-sections

INCDIRS += \
	inc \
	inc/chip_15xx \
	inc/chip_common \
	src/adapter \
	src/adapter/obd \
	src/drv/lpc15xx \
	src/util \

INC = $(addprefix -I,$(INCDIRS))

SRC_C = \
	src/system_LPC15xx.c \

SRC_CXX = \
	src/adapter/adapterconfig.cpp \
	src/adapter/adapter.cpp \
	src/adapter/dispatcher.cpp \
	src/adapter/ecumsg.cpp \
	src/adapter/functions.cpp \
	src/adapter/obd/autoadapter.cpp \
	src/adapter/obd/canhistory.cpp \
	src/adapter/obd/isocan11.cpp \
	src/adapter/obd/isocan29.cpp \
	src/adapter/obd/isocan.cpp \
	src/adapter/obd/isoserial.cpp \
	src/adapter/obd/j1939connmgr.cpp \
	src/adapter/obd/j1939.cpp \
	src/adapter/obd/obdprofile.cpp \
	src/adapter/obd/padapter.cpp \
	src/adapter/obd/pwm.cpp \
	src/adapter/obd/vpw.cpp \
	src/adapter/timeoutmgr.cpp \
	src/cr_cpp_config.cpp \
	src/cr_startup_lpc15xx.cpp \
	src/drv/lpc15xx/AdcLPC15xx.cpp \
	src/drv/lpc15xx/CanDriverLPC15xx.cpp \
	src/drv/lpc15xx/CmdUartLPC15xx.cpp \
	src/drv/lpc15xx/EcuUartLPC15xx.cpp \
	src/drv/lpc15xx/GpioDrvLPC15xx.cpp \
	src/drv/lpc15xx/led.cpp \
	src/drv/lpc15xx/PwmDriverLPC15xx.cpp \
	src/drv/lpc15xx/SysutilityLPC15xx.cpp \
	src/drv/lpc15xx/TimerLPC15xx.cpp \
	src/util/algorithms.cpp \
	src/util/canmsgbuffer.cpp \
	src/util/lstring.cpp \

OBJ += $(addprefix $(BUILD)/,$(SRC_C:.c=.o))
OBJ += $(addprefix $(BUILD)/,$(SRC_CXX:.cpp=.o))
OBJDIRS = $(sort $(dir $(OBJ)))

DEP += $(OBJ:.o=.d)

all: .post-build

.pre-build: $(OBJDIRS)

.build: .pre-build $(BUILD)/firmware.elf $(BUILD)/firmware.hex

.post-build: .build

clean:
	rm -rf $(BUILD)

$(OBJ): |$(OBJDIRS)
$(OBJDIRS):
	mkdir -p $@

$(BUILD)/%.o: %.c
	@$(CC) $(CFLAGS) -o $@ $<
	@echo CC $<

$(BUILD)/%.o: %.cpp
	@$(CXX) $(CXXFLAGS) -o $@ $<
	@echo CXX $<

$(BUILD)/firmware.elf: $(OBJ)
	@$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)
	@echo LD $@
	@$(SIZE) $@

$(BUILD)/firmware.hex: $(BUILD)/firmware.elf
	@$(OBJCOPY) -O ihex $< $@
	@echo CP $@

-include $(DEP)

.PHONY: all clean .pre-build .build .post-build
