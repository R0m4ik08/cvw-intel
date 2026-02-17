#############################################################################
# Trap handler for CLINT machine timer interrupt (mcause = 0x80000007).
# Increments seconds and sets MTIMECMP = MTIME + ticks_per_sec.
# Uses: extern seconds (uint32_t), extern ticks_per_sec (uint32_t).
# Addresses match clint.h: CLINT_BASE 0x01000000, MTIME 0xBFF8/BFFC,
# MTIMECMP 0x4000/4004.
#############################################################################

.section .text
.globl trap_entry
.type trap_entry, @function

trap_entry:
    addi    sp, sp, -32
    sw      t0, 0(sp)
    sw      t1, 4(sp)
    sw      t2, 8(sp)
    sw      t3, 12(sp)
    sw      t4, 16(sp)
    sw      t5, 20(sp)
    sw      a0, 24(sp)
    sw      a1, 28(sp)

    csrr    a0, 0x342          # mcause
    bltz    a0, .L_is_interrupt
    j       .L_trap_done
.L_is_interrupt:
    li      t0, 7
    andi    t1, a0, 0xFF
    bne     t1, t0, .L_trap_done   # not machine timer (7)

    # Increment seconds
    la      t0, seconds
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    # Load ticks_per_sec
    la      t2, ticks_per_sec
    lw      t2, 0(t2)

    # Read MTIME (64-bit)
    li      t0, 0x0100BFF8
    lw      t3, 0(t0)          # MTIME lo
    li      t0, 0x0100BFFC
    lw      t4, 0(t0)          # MTIME hi

    # MTIMECMP = MTIME + ticks_per_sec
    add     t5, t3, t2         # new_lo
    sltu    t0, t5, t3         # carry
    add     t4, t4, t0         # new_hi

    li      t0, 0x01004000
    sw      t5, 0(t0)
    li      t0, 0x01004004
    sw      t4, 0(t0)

.L_trap_done:
    lw      t0, 0(sp)
    lw      t1, 4(sp)
    lw      t2, 8(sp)
    lw      t3, 12(sp)
    lw      t4, 16(sp)
    lw      t5, 20(sp)
    lw      a0, 24(sp)
    lw      a1, 28(sp)
    addi    sp, sp, 32
    mret
