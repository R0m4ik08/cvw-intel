#include "system.h"

.section .init
.global _start
.type _start, @function

_start:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L2
.L3:
        lui     a5,%hi(gpio_base)
        lw      a4,%lo(gpio_base)(a5)
        lw      a5,-20(s0)
        add     a5,a4,a5
        sw      a5,-24(s0)
        lw      a5,-24(s0)
        li      a4,0x55
        sb      a4,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L2:
        lw      a4,-20(s0)
        li      a5,255
        ble     a4,a5,.L3
.L4:
        j       .L4

gpio_base:
        .word   0x10060000

