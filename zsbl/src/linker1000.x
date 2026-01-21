OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv",
	      "elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
  ROM (rw) : ORIGIN = 0x00001000, LENGTH = 64K
  RAM (rwx) : ORIGIN = 0x00011000, LENGTH = 4K
}

SECTIONS
{
  .init : {
    KEEP(*(.init))
    _start_end = .;
    . = 0x100;
  } > ROM
  
  .text : {
    *(.text*)
    *(.rodata*)
  } > ROM

  .bss : {
    __bss_start__ = .;
    *(.bss*)
    *(COMMON)
    __bss_end__ = .;
  } > RAM

  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}