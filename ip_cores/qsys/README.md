# Внешние IP ядра импортируемые в проект Platform Designer

## Модифицированное IP моста EXT -> Avalon из библиотеки Quartus 

В данном проекте используется локальная модифицированная версия стандартного IP-блока Altera/Intel FPGA University Program — **External Bus to Avalon Bridge** (`altera_up_external_bus_to_avalon_bridge`).

* Скрипт компонента: [mod_altera_up_external_bus_to_avalon_bridge_hw.tcl](mod_altera_up_external_bus_to_avalon_bridge_hw.tcl)
* Исходник: [altera_up_external_bus_to_avalon_bridge.v](src/altera_up_external_bus_to_avalon_bridge.v)

### Причина модификации

Оригинальный библиотечный блок использует одну общую роль `export` для всех сигналов интерфейса `external_interface`. Это вызывало ошибку в Platform Designer (Qsys) при попытке напрямую соединить его с мостом `ahb_to_ext_bridge_0` (интерфейс `ExtBus_m`), у которого сигналы обладают уникальными ролями (`export_address`, `export_read` и т.д.).

Для решения проблемы роли сигналов в локальном `_hw.tcl` файле были приведены к точному соответствию сигналам вашего кастомного моста.