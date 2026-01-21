# SDK - Software Development Kit

SDK для разработки пользовательских программ под компьютерную систему на базе RISC-V (RV32I).

## Быстрый старт

```bash
# Сборка примера по умолчанию (hello)
cd sdk
make

# Результат: build/program.mif
```

## Использование

### Сборка проекта

```bash
# Сборка примера hello (по умолчанию)
make

# Сборка конкретного проекта
make PROJECT=examples/hello

# Сборка внешнего проекта
make PROJECT=/path/to/my_project

# Очистка
make clean

# Информация о конфигурации
make info
```

### Структура проекта пользователя

```
my_project/
└── src/
    ├── main.c      # Точка входа (функция main)
    └── ...         # Дополнительные файлы (.c, .S)
```

## Структура SDK

```
sdk/
├── Makefile              # Система сборки
├── README.md             # Документация (этот файл)
├── common/
│   ├── linker.x          # Linker script для SRAM
│   ├── startup.S         # Startup-код с magic number
│   └── include/
│       ├── system.h      # Системные константы
│       ├── uart.h        # UART API
│       ├── gpiolib.h     # GPIO API
│       └── riscv.h       # RISC-V утилиты
├── lib/
│   ├── uart.c            # Реализация UART
│   └── riscv.S           # RISC-V ассемблерные функции
├── examples/
│   └── hello/            # Пример программы
│       └── src/
│           └── main.c
└── build/                # Выходные файлы (создается при сборке)
```

## Выходные файлы

После сборки в директории `build/` создаются:

| Файл              | Описание                              |
|-------------------|---------------------------------------|
| `program.elf`     | ELF-файл программы                    |
| `program.hex`     | Intel HEX формат                      |
| `program.mif`     | MIF для загрузки в SRAM (Quartus)     |
| `program.objdump` | Дизассемблированный листинг           |

## Карта памяти программы

```
Адрес       │ Содержимое
────────────┼─────────────────────────
0x02000000  │ Magic: 0x52564D00
0x02000004  │ _start (точка входа)
...         │ .text (код)
...         │ .rodata (константы)
...         │ .data (данные)
...         │ .bss (неинициализированные)
0x02005000  │ Стек (растет вниз)
```

## API

### UART

```c
#include "uart.h"

// Инициализация (уже выполнена ZSBL)
init_uart(SYSTEMCLOCK, 115200);

// Вывод строки
print_uart("Hello!\n");

// Вывод чисел
print_uart_dec(123);      // Десятичное
print_uart_int(0xABCD);   // Hex (4 байта)
print_uart_byte(0xFF);    // Hex (1 байт)
print_uart_addr(0x12345678); // Hex (8 байт)
```

### GPIO

```c
#include "gpiolib.h"

// Настройка пина
pinMode(0, OUTPUT);  // Выход
pinMode(1, INPUT);   // Вход

// Запись
digitalWrite(0, HIGH);
digitalWrite(0, LOW);

// Чтение
int val = digitalRead(1);
```

### Системные константы

```c
#include "system.h"

SYSTEMCLOCK   // 50000000 Hz
SRAM_BASE     // 0x02000000
UART_BASE     // 0x10000000
GPIO_BASE     // 0x10060000
HEX_BASE      // 0x03000000
SDRAM_BASE    // 0x08000000
```

## Интеграция с ZSBL

1. Загрузчик ZSBL стартует с адреса `0x00001000`
2. Выполняет тесты периферии
3. Проверяет magic number в SRAM (`0x02000000`)
4. При совпадении (`0x52564D00`) передает управление на `0x02000004`

### Magic Number

- Значение: `0x52564D00` ("RVM\0" - RISC-V Machine)
- Автоматически добавляется startup-кодом
- Не требует действий от пользователя

## Создание нового проекта

1. Создайте директорию проекта:
   ```bash
   mkdir -p my_project/src
   ```

2. Создайте `my_project/src/main.c`:
   ```c
   #include "uart.h"
   #include "system.h"
   
   int main(void) {
       init_uart(SYSTEMCLOCK, 115200);
       print_uart("My Program!\n");
       
       while (1) {
           // Ваш код
       }
       return 0;
   }
   ```

3. Соберите проект:
   ```bash
   make PROJECT=my_project
   ```

4. Загрузите `build/program.mif` в SRAM через Quartus

## Требования

- RISC-V GCC Toolchain (`riscv64-unknown-elf-gcc`)
- Python 3 (для hex2mif.py)
- GNU Make

## Параметры сборки

Можно переопределить при вызове make:

```bash
make SYSTEMCLOCK=100000000  # Изменить частоту
make CFLAGS="-O3"           # Дополнительные флаги
```

Доступные параметры:

| Параметр      | По умолчанию | Описание              |
|---------------|--------------|------------------------|
| SYSTEMCLOCK   | 50000000     | Частота системы (Hz)   |
| MAXSDCCLOCK   | 5000000      | Макс. частота SD (Hz)  |
| EXT_MEM_BASE  | 0x80000000   | База внешней памяти    |
| EXT_MEM_RANGE | 0x10000000   | Размер внешней памяти  |
