/**
 * @file system.h
 * @brief System constants for the computer system
 * 
 * SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
 */

#ifndef __SYSTEM_H
#define __SYSTEM_H

/* System clock frequency (Hz) */
#ifndef SYSTEMCLOCK
#define SYSTEMCLOCK  50000000
#endif

/* Maximum SD card clock (Hz) */
#ifndef MAXSDCCLOCK
#define MAXSDCCLOCK  5000000
#endif

/* External memory configuration */
#ifndef EXT_MEM_BASE
#define EXT_MEM_BASE 0x80000000
#endif

#ifndef EXT_MEM_RANGE
#define EXT_MEM_RANGE  0x10000000
#endif

#define EXT_MEM_END (EXT_MEM_BASE + EXT_MEM_RANGE)

/* Memory map addresses */
#define GPIO_BASE       0x00015000
#define UART_BASE       0x00016000
#define HEX_BASE        0x13000000
#define SRAM_BASE       0x20000000
#define SDRAM_BASE      0x38000000

#endif /* __SYSTEM_H */
