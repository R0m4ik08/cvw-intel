#include <stdint.h>

#include "system.h"
#include "bios_ini.h"

#include "gpiolib.h"
#include "uart.h"

#include<string.h>

#define SDRAM_BASE  0x08000000
#define SRAM_BASE   0x02000000
#define SDC_BASE    0x00013000

#define ONCHIP_RAM_BASE    0x11000

#define MEM_START   SRAM_BASE
#define MEM_SIZE    0x200

#define TEST_OK     0
#define TEST_ERROR  1

typedef unsigned int size_t;

// Функция тестирования памяти
int mem_test(uint32_t *addr, size_t size_bytes) {
    size_t words = size_bytes / sizeof(uint32_t);
    uint32_t patterns[] = {0x00000000, 0xFFFFFFFF, 0xAAAAAAAA, 0x55555555};

    // --- Тест фиксированных паттернов ---
    for (int p = 0; p < 4; p++) {
        uint32_t pat = patterns[p];
        print_uart("Pattern test: ");
        print_uart_int(pat);
        print_uart("\n");

        // Запись
        for (size_t i = 0; i < words; i++) {
            addr[i] = pat;
        }

        // Чтение и проверка
        for (size_t i = 0; i < words; i++) {
            if (addr[i] != pat) {
                print_uart("ERROR: address ");
                print_uart_addr((uint64_t)&addr[i]);
                print_uart(" expected 0x");
                print_uart_int(pat);
                print_uart(", got 0x");
                print_uart_int(addr[i]);
                print_uart("\n");

                return TEST_ERROR;
            }
        }
    }
    return TEST_OK;
}

int _bios_ini_c(){

    uint8_t gpio_width = 4 + 18;

    for(int i =0; i < gpio_width; i++){
        pinMode(i, INPUT);
        int val = digitalRead(i);
        
        pinMode(i, OUTPUT);
        digitalWrite(i, val);
    }

    char* str = "\nHello_World_WW!\n";
    init_uart(SYSTEMCLOCK, 9600);
    print_uart(str);

    int result = mem_test((uint32_t *)MEM_START, MEM_SIZE);

    if (result == TEST_OK) print_uart("TEST_OK!\n");
    else print_uart("TEST_ERROR!\n");

    memcpy(str, str+1, 10);

    return 0;
}