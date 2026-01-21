#######################################################################
# Makefile for building user programs for the RISC-V Computer System
#
# Usage:
#   make                        - Build default example (examples/hello)
#   make PROJECT=examples/hello - Build specific project
#   make PROJECT=/path/to/proj  - Build external project
#   make clean                  - Clean build artifacts
#
# Output files:
#   build/program.elf     - ELF executable
#   build/program.hex     - Intel HEX format
#   build/program.mif     - Memory Initialization File for Quartus
#   build/program.objdump - Disassembly listing
#######################################################################

#######################################################################
# Project Configuration
#######################################################################

# Default project (can be overridden via command line)
PROJECT ?= examples/hello

# Directories
SDK_ROOT    := $(shell pwd)
COMMON_DIR  := $(SDK_ROOT)/common
LIB_DIR     := $(SDK_ROOT)/lib
BUILD_DIR   := $(SDK_ROOT)/build
HEX2MIF     := $(SDK_ROOT)/common/hex2mif/hex2mif.py

# Project source directory
PROJECT_SRC := $(PROJECT)/src

#######################################################################
# Toolchain Configuration
#######################################################################

CROSS_COMPILE := riscv64-unknown-elf-
CC      := $(CROSS_COMPILE)gcc
AS      := $(CROSS_COMPILE)as
LD      := $(CROSS_COMPILE)ld
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump
ELF2HEX := $(CROSS_COMPILE)elf2hex

#######################################################################
# Architecture Configuration
#######################################################################

MARCH := -march=rv32i
MABI  := -mabi=ilp32

#######################################################################
# FPGA System Parameters
#######################################################################

SYSTEMCLOCK   ?= 50000000
MAXSDCCLOCK   ?= 5000000
EXT_MEM_BASE  ?= 0x80000000
EXT_MEM_RANGE ?= 0x10000000

#######################################################################
# Compiler/Linker Flags
#######################################################################

INCLUDES := -I$(COMMON_DIR)/include

CFLAGS := $(MARCH) $(MABI) \
          -mcmodel=medany \
          -O2 -g \
          -Wall -Wextra \
          -ffreestanding \
          -nostdlib \
          -fno-asynchronous-unwind-tables \
          -fno-exceptions \
          $(INCLUDES) \
          -DSYSTEMCLOCK=$(SYSTEMCLOCK) \
          -DMAXSDCCLOCK=$(MAXSDCCLOCK) \
          -DEXT_MEM_BASE=$(EXT_MEM_BASE) \
          -DEXT_MEM_RANGE=$(EXT_MEM_RANGE)

ASFLAGS := $(MARCH) $(MABI) $(INCLUDES)

LDFLAGS := $(MARCH) $(MABI) \
           -nostartfiles \
           -T $(COMMON_DIR)/linker.x

#######################################################################
# Source Files
#######################################################################

# Common startup and library files
COMMON_SRCS := $(COMMON_DIR)/startup.S
LIB_SRCS    := $(wildcard $(LIB_DIR)/*.c) $(wildcard $(LIB_DIR)/*.S)

# Project source files
PROJECT_SRCS := $(wildcard $(PROJECT_SRC)/*.c) \
                $(wildcard $(PROJECT_SRC)/*.S) \
                $(wildcard $(PROJECT_SRC)/*.s)

# All source files
ALL_SRCS := $(COMMON_SRCS) $(LIB_SRCS) $(PROJECT_SRCS)

# Object files
OBJECTS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(notdir $(filter %.c,$(ALL_SRCS))))
OBJECTS += $(patsubst %.S,$(BUILD_DIR)/%.o,$(notdir $(filter %.S,$(ALL_SRCS))))
OBJECTS += $(patsubst %.s,$(BUILD_DIR)/%.o,$(notdir $(filter %.s,$(ALL_SRCS))))

#######################################################################
# Output Files
#######################################################################

TARGET     := $(BUILD_DIR)/program
ELF_FILE   := $(TARGET).elf
HEX_FILE   := $(TARGET).hex
MIF_FILE   := $(TARGET).mif
DUMP_FILE  := $(TARGET).objdump

#######################################################################
# Build Rules
#######################################################################

.PHONY: all clean info

all: $(MIF_FILE)
	@echo ""
	@echo "=== Build Complete ==="
	@echo "Project: $(PROJECT)"
	@echo "Output:  $(MIF_FILE)"
	@echo ""

# Create build directory
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Link ELF
$(ELF_FILE): $(OBJECTS) | $(BUILD_DIR)
	@echo "[LD] $@"
	@$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

# Generate disassembly
$(DUMP_FILE): $(ELF_FILE)
	@echo "[OBJDUMP] $@"
	@$(OBJDUMP) -DS $< > $@

# Generate HEX file
$(HEX_FILE): $(ELF_FILE) $(DUMP_FILE)
	@echo "[ELF2HEX] $@"
	@$(ELF2HEX) --bit-width 32 --input $< --output $@

# Generate MIF file
$(MIF_FILE): $(HEX_FILE)
	@echo "[HEX2MIF] $@"
	@python3 $(HEX2MIF) $< $@ --width 32

#######################################################################
# Compilation Rules
#######################################################################

# Compile C files from common
$(BUILD_DIR)/%.o: $(COMMON_DIR)/%.c | $(BUILD_DIR)
	@echo "[CC] $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

# Compile S files from common
$(BUILD_DIR)/%.o: $(COMMON_DIR)/%.S | $(BUILD_DIR)
	@echo "[AS] $<"
	@$(CC) $(ASFLAGS) -c -o $@ $<

# Compile C files from lib
$(BUILD_DIR)/%.o: $(LIB_DIR)/%.c | $(BUILD_DIR)
	@echo "[CC] $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

# Compile S files from lib
$(BUILD_DIR)/%.o: $(LIB_DIR)/%.S | $(BUILD_DIR)
	@echo "[AS] $<"
	@$(CC) $(ASFLAGS) -c -o $@ $<

# Compile C files from project
$(BUILD_DIR)/%.o: $(PROJECT_SRC)/%.c | $(BUILD_DIR)
	@echo "[CC] $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

# Compile S files from project
$(BUILD_DIR)/%.o: $(PROJECT_SRC)/%.S | $(BUILD_DIR)
	@echo "[AS] $<"
	@$(CC) $(ASFLAGS) -c -o $@ $<

# Compile s files from project
$(BUILD_DIR)/%.o: $(PROJECT_SRC)/%.s | $(BUILD_DIR)
	@echo "[AS] $<"
	@$(CC) $(ASFLAGS) -c -o $@ $<

#######################################################################
# Utility Rules
#######################################################################

clean:
	@echo "[CLEAN] Removing build directory"
	@rm -rf $(BUILD_DIR)

info:
	@echo "=== SDK Configuration ==="
	@echo "SDK_ROOT:    $(SDK_ROOT)"
	@echo "PROJECT:     $(PROJECT)"
	@echo "PROJECT_SRC: $(PROJECT_SRC)"
	@echo ""
	@echo "=== Source Files ==="
	@echo "COMMON_SRCS: $(COMMON_SRCS)"
	@echo "LIB_SRCS:    $(LIB_SRCS)"
	@echo "PROJECT_SRCS: $(PROJECT_SRCS)"
	@echo ""
	@echo "=== Objects ==="
	@echo "OBJECTS:     $(OBJECTS)"
	@echo ""
	@echo "=== System Parameters ==="
	@echo "SYSTEMCLOCK: $(SYSTEMCLOCK) Hz"
	@echo "MARCH:       $(MARCH)"
	@echo "MABI:        $(MABI)"
