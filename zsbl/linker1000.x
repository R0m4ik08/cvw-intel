OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
  ROM (rx) : ORIGIN = 0x00001000, LENGTH = 4K
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

}
