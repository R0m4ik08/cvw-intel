OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
  ROM (rx) : ORIGIN = 0x00001000, LENGTH = 4K
  RAM (rwx) : ORIGIN = 0x00002000, LENGTH = 4K
}

SECTIONS
{
  .init : {
    KEEP(*(.init))
    _start_end = .;
    . = 0x200;
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