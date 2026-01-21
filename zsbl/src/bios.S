

.global _bios_ini_c

.section .init
.global _start
.type _start, @function

_start:
        mv	x1, zero
        mv	x2, zero
        mv	x3, zero
        mv	x4, zero
        mv	x5, zero
        mv	x6, zero
        mv	x7, zero
        mv	x8, zero
        mv	x9, zero
        mv	x10, zero
        mv	x11, zero
        mv	x12, zero
        mv	x13, zero
        mv	x14, zero
        mv	x15, zero
        mv	x16, zero
        mv	x18, zero
        mv	x19, zero
        mv	x20, zero
        mv	x21, zero
        mv	x22, zero
        mv	x23, zero
        mv	x24, zero
        mv	x25, zero
        mv	x26, zero
        mv	x27, zero
        mv	x28, zero
        mv	x29, zero
        mv	x30, zero
        mv	x31, zero
        
        lui     sp, %hi(_stack_top)
        addi    sp, sp, %lo(_stack_top)
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        call    _bios_ini_c

        # Цикл ожидания с энергосбережением
        # Достигается только если программа в SRAM не найдена
.L2:
        wfi             # Wait For Interrupt - снижение энергопотребления
        j       .L2

