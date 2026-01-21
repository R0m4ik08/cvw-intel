/**
 * Linker script for user programs in SRAM
 * 
 * Memory layout:
 *   0x02000000 - Magic number (4 bytes)
 *   0x02000004 - Program entry point (_start)
 *   ...        - Code, data, bss
 *   0x02100000 - Stack top (end of 1MB SRAM)
 */

OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    SRAM (rwx) : ORIGIN = 0x02000000, LENGTH = 1M
}

SECTIONS
{
    /* Magic number must be at the very beginning (0x02000000) */
    .magic : {
        KEEP(*(.magic))
    } > SRAM

    /* Startup code must be right after magic (0x02000004) */
    .init : {
        KEEP(*(.init))
    } > SRAM

    /* Main code section */
    .text : {
        *(.text .text.*)
        *(.rodata*)
    } > SRAM

    /* Initialized data */
    .data : {
        *(.data*)
    } > SRAM

    /* Uninitialized data */
    .bss : {
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > SRAM

    /* Stack at the end of SRAM */
    _stack_top = ORIGIN(SRAM) + LENGTH(SRAM);

    /* Discard unnecessary sections */
    /DISCARD/ : {
        *(.eh_frame)
        *(.eh_frame_hdr)
        *(.comment)
        *(.note*)
    }
}
