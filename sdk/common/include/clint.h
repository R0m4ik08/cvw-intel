/**
 * @file clint.h
 * @brief CLINT (Core-Local Interruptor) constants - extends system configuration
 *
 * Defines base address and register offsets for the CLINT timer and
 * software interrupt, matching config.vh and clint_apb.sv. Include after system.h.
 *
 * SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
 */

#ifndef __CLINT_H
#define __CLINT_H

#include "system.h"

/* CLINT base address (must match config.vh CLINT_BASE) */
#ifndef CLINT_BASE
#define CLINT_BASE  0x01000000
#endif

/* Register offsets (match clint_apb.sv for RV32) */
#define CLINT_MSIP          0x0000
#define CLINT_MTIMECMP_LO   0x4000
#define CLINT_MTIMECMP_HI   0x4004
#define CLINT_MTIME_LO      0xBFF8
#define CLINT_MTIME_HI      0xBFFC

/* Full addresses for memory-mapped access */
#define CLINT_MSIP_ADDR         (CLINT_BASE + CLINT_MSIP)
#define CLINT_MTIMECMP_LO_ADDR  (CLINT_BASE + CLINT_MTIMECMP_LO)
#define CLINT_MTIMECMP_HI_ADDR  (CLINT_BASE + CLINT_MTIMECMP_HI)
#define CLINT_MTIME_LO_ADDR     (CLINT_BASE + CLINT_MTIME_LO)
#define CLINT_MTIME_HI_ADDR     (CLINT_BASE + CLINT_MTIME_HI)

#endif /* __CLINT_H */
