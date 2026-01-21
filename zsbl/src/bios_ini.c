#include <stdint.h>

#include "system.h"
#include "bios_ini.h"

#include "gpiolib.h"
#include "uart.h"

#include<string.h>

#define SDRAM_BASE  0x08000000
#define SRAM_BASE   0x02000000
#define HEX_BASE    0x03000000
#define SDC_BASE    0x00013000

#define ONCHIP_RAM_BASE    0x11000

#define MEM_START   SRAM_BASE
#define MEM_SIZE    0x5000

#define TEST_OK     0
#define TEST_ERROR  1

typedef unsigned int size_t;

// Функция тестирования памяти
int mem_test(uint8_t *addr, size_t size_bytes) {
    uint8_t patterns[] = {0x00, 0xFF, 0xAA, 0x55};

    // --- Тест фиксированных паттернов ---
    for (int p = 0; p < 4; p++) {
        uint8_t pat = patterns[p];
        print_uart("Pattern test: ");
        print_uart_int(pat);
        print_uart("\n");

        // Запись
        for (size_t i = 0; i < size_bytes; i++) {
            addr[i] = pat;
        }

        // Чтение и проверка
        for (size_t i = 0; i < size_bytes; i++) {
            if (addr[i] != pat) {
                print_uart("ERROR: address ");
                print_uart_int((uint32_t)&addr[i]);
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

    init_uart(SYSTEMCLOCK, 115200);
    char* str = "\nHello_World_WW!\n";
    print_uart(str);

    int result = mem_test((uint8_t *)MEM_START, MEM_SIZE);

    if (result == TEST_OK) print_uart("TEST_OK!\n");
    else print_uart("TEST_ERROR!\n");

    uint8_t* hex_digit_ptr = (uint8_t*)(HEX_BASE);

    *(hex_digit_ptr + 0) =  0x55;
    *(hex_digit_ptr + 1) =  0xaa;

    return 0;
}

    // --------------------------------------------------

    // uint8_t* tmp_ptr = (uint8_t *)MEM_START;
    // uint8_t byte;

    // for (size_t i = 0; i < 12; i++)
    // {
    //     byte = *tmp_ptr;
    //     byte += 1;
    //     *tmp_ptr = byte;
    //     tmp_ptr++;
    // }

    // --------------------------------------------------

    // init_uart(SYSTEMCLOCK, 115200);
    
    // uint8_t buf[20];

    // uint8_t* tmp_ptr = (uint8_t *)MEM_START;
    
    // for (size_t i = 0; i < 20; i++)
    // {
    //     *tmp_ptr += 0x1;
    //     tmp_ptr++;
    // }
    
    // print_uart("\nDBG_1:\n");
    
    // memcpy(buf ,(uint8_t *)MEM_START, 20);

    // for (size_t i = 0; i < 20; i++)
    // {
    //     print_uart("0x");
    //     print_uart_int(buf[i]);
    //     print_uart("\n");
    // }
    
    // print_uart("DBG_2:\n");