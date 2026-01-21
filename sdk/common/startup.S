///////////////////////////////////////////////////////////////////////
// startup.S
//
// Startup code for user programs running in SRAM (0x02000000)
// Called by ZSBL bootloader after magic number validation
//
// Memory layout:
//   0x02000000 - Magic number 0x52564D00 ("RVM\0")
//   0x02000004 - _start entry point
///////////////////////////////////////////////////////////////////////

.global main

///////////////////////////////////////////////////////////////////////
// Magic number section - must be at 0x02000000
///////////////////////////////////////////////////////////////////////

.section .magic, "a"
.word 0x52564D00        # Magic number "RVM\0" - RISC-V Machine

///////////////////////////////////////////////////////////////////////
// Startup code - entry point at 0x02000004
///////////////////////////////////////////////////////////////////////

.section .init, "ax"
.global _start
.type _start, @function

_start:
        # Initialize stack pointer
        lui     sp, %hi(_stack_top)
        addi    sp, sp, %lo(_stack_top)
        
        # Set up stack frame
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        addi    s0, sp, 16
        
        # Clear BSS section
        lui     a0, %hi(__bss_start__)
        addi    a0, a0, %lo(__bss_start__)
        lui     a1, %hi(__bss_end__)
        addi    a1, a1, %lo(__bss_end__)
        
.L_clear_bss:
        bge     a0, a1, .L_bss_done
        sw      zero, 0(a0)
        addi    a0, a0, 4
        j       .L_clear_bss
        
.L_bss_done:
        # Call main function
        call    main
        
        # If main returns, halt the processor
.L_halt:
        wfi                     # Wait For Interrupt - low power mode
        j       .L_halt
