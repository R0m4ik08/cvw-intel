///////////////////////////////////////////////////////////////////////
// riscv.h
//
// Written: Jaocb Pease jacob.pease@okstate.edu 7/22/2024
//
// Purpose: Function prototypes for riscv utility functions
//
// A component of the Wally configurable RISC-V project.
// 
// Copyright (C) 2021-23 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
///////////////////////////////////////////////////////////////////////

#pragma once
#include <stdint.h>

uint64_t read_mcycle();
uint64_t get_ra();
void set_status_fs();
void clear_status_fs();

/* CSR access (mstatus=0x300, mie=0x304, mtvec=0x305) */
#define CSR_MSTATUS  0x300
#define CSR_MIE      0x304
#define CSR_MTVEC    0x305

uint32_t csr_read(uint32_t csr_num);
void csr_write(uint32_t csr_num, uint32_t value);
