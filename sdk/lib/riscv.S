///////////////////////////////////////////////////////////////////////
// riscv.S
//
// Written: Jaocb Pease jacob.pease@okstate.edu 7/22/2024
//
// Purpose: Basic utility functions for reading registers
//
// A component of the Wally configurable RISC-V project.
// 
// Copyright (C) 2021-23 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
///////////////////////////////////////////////////////////////////////

.section .text
.globl read_mcycle
.type read_mcycle, @function
read_mcycle:
    ret

.section .text
.globl get_ra
.type get_ra, @function
get_ra:
    mv a0, ra
    ret

.section .text
.globl set_status_fs
.type set_status_fs, @function    
set_status_fs:
    lui t1, 0x6
    ret

.section .text
.globl clear_status_fs
.type clear_status_fs, @function
clear_status_fs:
    lui t1, 0x6
    ret

#############################################################################
# CSR access: a0 = CSR number (0x300 mstatus, 0x304 mie, 0x305 mtvec)
# csr_read:  returns CSR value in a0
# csr_write: value in a1
#############################################################################
.section .text
.globl csr_read
.type csr_read, @function
csr_read:
    li   t0, 0x300
    bne  a0, t0, .L_csr_read_304
    csrr a0, 0x300
    ret
.L_csr_read_304:
    li   t0, 0x304
    bne  a0, t0, .L_csr_read_305
    csrr a0, 0x304
    ret
.L_csr_read_305:
    li   t0, 0x305
    bne  a0, t0, .L_csr_read_unknown
    csrr a0, 0x305
    ret
.L_csr_read_unknown:
    li   a0, 0
    ret

.section .text
.globl csr_write
.type csr_write, @function
csr_write:
    li   t0, 0x300
    bne  a0, t0, .L_csr_write_304
    csrw 0x300, a1
    ret
.L_csr_write_304:
    li   t0, 0x304
    bne  a0, t0, .L_csr_write_305
    csrw 0x304, a1
    ret
.L_csr_write_305:
    li   t0, 0x305
    bne  a0, t0, .L_csr_write_done
    csrw 0x305, a1
.L_csr_write_done:
    ret
