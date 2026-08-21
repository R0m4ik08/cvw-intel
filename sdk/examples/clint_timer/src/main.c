/**
 * @file main.c
 * @brief CLINT timer example - seconds counter using machine timer interrupt
 *
 * Demonstrates the CLINT (Core-Local Interruptor) hardware timer:
 * sets up a 1-second periodic interrupt and prints the seconds counter over UART.
 *
 * Memory location: 0x02000000 (SRAM)
 * Entry point: 0x02000004 (after magic number)
 */

#include "uart.h"
#include "system.h"
#include "clint.h"
#include "riscv.h"

#include <stdint.h>

/** Seconds counter, incremented in trap handler */
volatile uint32_t seconds;

/** Ticks per second (SYSTEMCLOCK), set before enabling timer; used in trap handler */
uint32_t ticks_per_sec;

/** Trap handler entry (defined in trap_handler.S) */
extern void trap_entry(void);

/** CLINT register access (use *_ADDR from clint.h) */
#define REG_MTIME_LO      (*(volatile uint32_t *)CLINT_MTIME_LO_ADDR)
#define REG_MTIME_HI      (*(volatile uint32_t *)CLINT_MTIME_HI_ADDR)
#define REG_MTIMECMP_LO   (*(volatile uint32_t *)CLINT_MTIMECMP_LO_ADDR)
#define REG_MTIMECMP_HI   (*(volatile uint32_t *)CLINT_MTIMECMP_HI_ADDR)

static void clint_set_next_tick(void)
{
    uint32_t lo = REG_MTIME_LO;
    uint32_t hi = REG_MTIME_HI;
    uint32_t add = ticks_per_sec;
    uint32_t new_lo = lo + add;
    uint32_t new_hi = hi + (new_lo < lo ? 1u : 0u);
    REG_MTIMECMP_LO = new_lo;
    REG_MTIMECMP_HI = new_hi;
}

int main(void)
{
    seconds = 0;
    uint32_t last_seconds = 0;

    init_uart(SYSTEMCLOCK, 115200);

    print_uart("\n");
    print_uart("================================\n");
    print_uart("  CLINT Timer - Seconds counter\n");
    print_uart("================================\n");
    print_uart("\n");

    ticks_per_sec = SYSTEMCLOCK;

    /* Set trap vector to our handler */
    csr_write(CSR_MTVEC, (uint32_t)trap_entry);

    /* Enable machine timer interrupt (MTIE = bit 7) and global MIE (bit 3 of mstatus) */
    csr_write(CSR_MIE, csr_read(CSR_MIE) | (1u << 7));
    csr_write(CSR_MSTATUS, csr_read(CSR_MSTATUS) | (1u << 3));

    /* Schedule first timer interrupt in 1 second */
    clint_set_next_tick();

    print_uart("Timer started. Counting seconds...\n");
    print_uart("\n");

    for (;;) {
        if (seconds != last_seconds) {
            last_seconds = seconds;
            print_uart("Seconds: ");
            print_uart_dec(seconds);
            print_uart("\n");
        }
    }

    return 0;
}
