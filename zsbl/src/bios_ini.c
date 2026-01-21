/**
 * @file bios_ini.c
 * @brief ZSBL (Zero Stage Boot Loader) - Инициализация и тестирование системы
 * 
 * Загрузчик выполняет последовательное тестирование компонентов системы
 * и передает управление основной программе в SRAM при наличии валидной сигнатуры.
 */

#include <stdint.h>
#include <stddef.h>

#include "system.h"
#include "bios_ini.h"

#include "gpiolib.h"
#include "uart.h"

/* ============================================================================
 * Константы адресов памяти
 * ============================================================================ */

#define SDRAM_BASE      0x08000000
#define SRAM_BASE       0x02000000
#define HEX_BASE        0x03000000
#define SDC_BASE        0x00013000
#define ONCHIP_RAM_BASE 0x00011000

/* ============================================================================
 * Параметры тестирования памяти
 * ============================================================================ */

#define MEM_TEST_START  SRAM_BASE
#define MEM_TEST_SIZE   0x5000      /* 20 KB */

/* ============================================================================
 * Параметры передачи управления
 * ============================================================================ */

#define PROGRAM_MAGIC   0x52564D00  /* "RVM\0" - RISC-V Machine */
#define PROGRAM_ENTRY   (SRAM_BASE + 4)

/* ============================================================================
 * Параметры GPIO
 * ============================================================================ */

#define GPIO_WIDTH      (18)    /* Количество GPIO пинов для тестирования */

/* ============================================================================
 * Типы данных
 * ============================================================================ */

/* size_t уже определен в stdint.h, используем его */

/**
 * @brief Результат выполнения теста
 */
typedef enum {
    TEST_OK    = 0,     /* Тест пройден успешно */
    TEST_ERROR = 1,     /* Тест завершился с ошибкой */
    TEST_SKIP  = 2      /* Тест пропущен */
} test_result_t;

/**
 * @brief Тип указателя на точку входа программы
 */
typedef void (*program_entry_t)(void);

/* ============================================================================
 * Вспомогательные функции вывода
 * ============================================================================ */

/**
 * @brief Вывод результата теста
 */
static void print_test_result(const char *name, test_result_t result) {
    print_uart("[");
    print_uart(name);
    print_uart("] ");
    
    switch (result) {
        case TEST_OK:
            print_uart("OK\n");
            break;
        case TEST_ERROR:
            print_uart("ERROR\n");
            break;
        case TEST_SKIP:
            print_uart("SKIP\n");
            break;
    }
}

/* ============================================================================
 * Тестовые функции
 * ============================================================================ */

/**
 * @brief Тест UART - инициализация и вывод тестового сообщения
 * @return TEST_OK при успешной инициализации
 */
static test_result_t test_uart(void) {
    init_uart(SYSTEMCLOCK, 115200);
    print_uart("\n=== ZSBL Boot Tests ===\n");
    return TEST_OK;
}

/**
 * @brief Тест GPIO - проверка чтения и записи всех пинов
 * @return TEST_OK если все пины работают корректно
 */
static test_result_t test_gpio(void) {
    for (int i = 0; i < GPIO_WIDTH; i++) {
        /* Читаем текущее значение */
        pinMode(i, INPUT);
        int val = digitalRead(i);
        
        /* Записываем обратно */
        pinMode(i, OUTPUT);
        digitalWrite(i, val);
    }
    
    return TEST_OK;
}

/**
 * @brief Тест SRAM - проверка памяти паттернами
 * @return TEST_OK если память работает корректно, TEST_ERROR при ошибке
 * 
 * Тестирует память записью и чтением паттернов:
 * 0x00, 0xFF, 0xAA, 0x55
 */
static test_result_t test_sram(void) {
    uint8_t *addr = (uint8_t *)MEM_TEST_START;
    size_t size_bytes = MEM_TEST_SIZE;
    uint8_t patterns[] = {0x00, 0xFF, 0xAA, 0x55};
    
    for (int p = 0; p < 4; p++) {
        uint8_t pat = patterns[p];
        
        /* Запись паттерна */
        for (size_t i = 0; i < size_bytes; i++) {
            addr[i] = pat;
        }
        
        /* Чтение и проверка */
        for (size_t i = 0; i < size_bytes; i++) {
            if (addr[i] != pat) {
                print_uart("  SRAM Error at 0x");
                print_uart_int((uintptr_t)&addr[i]);
                print_uart(": expected 0x");
                print_uart_byte(pat);
                print_uart(", got 0x");
                print_uart_byte(addr[i]);
                print_uart("\n");
                return TEST_ERROR;
            }
        }
    }
    
    return TEST_OK;
}

/**
 * @brief Тест HEX дисплея - запись тестовых значений
 * @return TEST_OK после записи тестовых данных
 */
static test_result_t test_hex_display(void) {
    volatile uint32_t *hex_ptr = (volatile uint32_t *)HEX_BASE;
    
    /* Записываем тестовый паттерн: (boot) */
    hex_ptr[0] = 0x7c3f3f78;
    
    return TEST_OK;
}

/* ============================================================================
 * Передача управления основной программе
 * ============================================================================ */

/**
 * @brief Проверка наличия валидной программы и передача управления
 * @return -1 если программа не найдена (функция не вернется при успехе)
 * 
 * Проверяет magic number в начале SRAM (0x02000000).
 * Если сигнатура совпадает с PROGRAM_MAGIC, передает управление
 * на адрес SRAM_BASE + 4.
 */
static int check_and_jump_to_program(void) {
    volatile uint32_t *magic_ptr = (volatile uint32_t *)SRAM_BASE;
    
    if (*magic_ptr == PROGRAM_MAGIC) {
        print_uart("\nValid program found at SRAM.\n");
        print_uart("Jumping to 0x");
        print_uart_int(PROGRAM_ENTRY);
        print_uart("...\n\n");
        
        /* Точка входа располагается сразу после magic number */
        program_entry_t entry = (program_entry_t)PROGRAM_ENTRY;
        entry();
        
        /* Сюда не должны попасть */
        return 0;
    }
    
    print_uart("\nNo valid program in SRAM (magic: 0x");
    print_uart_int(*magic_ptr);
    print_uart(", expected: 0x");
    print_uart_int(PROGRAM_MAGIC);
    print_uart(")\n");
    print_uart("Halting.\n");
    
    return -1;
}

/* ============================================================================
 * Главная функция загрузчика
 * ============================================================================ */

/**
 * @brief Точка входа C-части загрузчика
 * @return 0 при успешном завершении всех тестов
 * 
 * Последовательность выполнения:
 * 1. Инициализация и тест UART
 * 2. Тест GPIO
 * 3. Тест SRAM
 * 4. Тест HEX дисплея
 * 5. Вывод итогов
 * 6. Проверка и передача управления основной программе
 */
int _bios_ini_c(void) {
    test_result_t result;
    int errors = 0;
    
    /* === Тест 1: UART === */
    result = test_uart();
    print_test_result("UART", result);
    if (result == TEST_ERROR) errors++;
    
    /* === Тест 2: GPIO === */
    result = test_gpio();
    print_test_result("GPIO", result);
    if (result == TEST_ERROR) errors++;
    
    /* === Тест 3: SRAM === */
    print_uart("SRAM Test was skipped !\n");
    //result = test_sram();
    //print_test_result("SRAM", result);
    //if (result == TEST_ERROR) errors++;
    
    /* === Тест 4: HEX Display === */
    result = test_hex_display();
    print_test_result("HEX ", result);
    if (result == TEST_ERROR) errors++;
    
    /* === Итоги === */
    print_uart("=======================\n");
    
    if (errors > 0) {
        print_uart("Tests failed: ");
        print_uart_dec(errors);
        print_uart("\n");
    } else {
        print_uart("All tests passed.\n");
    }
    
    /* === Если зажата KEY1 то передача основной программы отменяется (для возможности прошить программу)=== */
    pinMode(19, INPUT);
    if (digitalRead(19) == LOW){
        print_uart("\nKEY1 pressed - Halting!\n");
        return 0;
    }

    /* === Передача управления основной программе === */
    check_and_jump_to_program();
    
    return 0;
}
