/**
 * @file main.c
 * @brief Hello World - Minimal example program for SRAM
 * 
 * This program demonstrates basic UART output from user code
 * running in SRAM after being loaded by the ZSBL bootloader.
 * 
 * Memory location: 0x02000000 (SRAM)
 * Entry point: 0x02000004 (after magic number)
 */

#include "uart.h"
#include "gpiolib.h"
#include "system.h"

/**
 * @brief Delay function using busy loop
 * @param cycles Number of loop iterations
 */
static void delay(volatile int cycles) {
    while (cycles-- > 0) {
        __asm__ volatile("nop");
    }
}

/**
 * @brief Main function - entry point for user program
 * @return Exit code (never returns in embedded context)
 * 
 * Called by startup.S after magic number validation by ZSBL.
 */
int main(void) {
    int counter = 0;
    
    /* Initialize UART (already initialized by ZSBL, but safe to call again) */
    init_uart(SYSTEMCLOCK, 115200);
    
    /* Print welcome message */
    print_uart("\n");
    print_uart("================================\n");
    print_uart("  Hello from SRAM!\n");
    print_uart("  User program is running.\n");
    print_uart("================================\n");
    print_uart("\n");
    
    /* Print system information */
    print_uart("System Info:\n");
    print_uart("  SRAM Base:  0x");
    print_uart_int(SRAM_BASE);
    print_uart("\n");
    print_uart("  Clock:      ");
    print_uart_dec(SYSTEMCLOCK);
    print_uart(" Hz\n");
    print_uart("\n");
    
    /* Configure LED GPIO (pin 0) as output */
    pinMode(0, OUTPUT);
    
    /* Main loop - blink LED and print counter */
    print_uart("Starting main loop...\n");
    
    while (1) {
        /* Toggle LED */
        digitalWrite(0, counter & 1);
        
        /* Print counter every 10 iterations */
        if ((counter % 10) == 0) {
            print_uart("Counter: ");
            print_uart_dec(counter);
            print_uart("\n");
        }
        
        counter++;
        
        /* Delay */
        delay(500000);
    }
    
    return 0;
}
