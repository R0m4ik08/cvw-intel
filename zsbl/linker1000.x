OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
  ROM (rx) : ORIGIN = 0x00001000, LENGTH = 512
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 2048K
}

SECTIONS
{
  /* Read-only sections, merged into text segment: */
  /* init segment to ensure we get a consistent start routine*/
  . = 0x0000000000001000; 
  . = ALIGN(0x0); 
  .init : {  
    KEEP(*(.init))
  } 
  _start_end = .;
  
  .init :
  {
    KEEP(*(.init))
  } > ROM

  .data : {
    __data_start__ = .;
    *(.data*)
    __data_end__ = .;
  } > RAM AT > ROM

  .bss : {
    __bss_start__ = .;
    *(.bss*)
    *(COMMON)
    __bss_end__ = .;
  } > RAM

  _stack_top = ORIGIN(RAM) + LENGTH(RAM);

}
