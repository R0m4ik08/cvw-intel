#
# Sturtup скрипт настройки tcl окружения для работы в Intel FPGA System Consol
#

#
#  Определение переменных
#
set ADR_HEX 0x03000000
set ADR_SRAM 0x02000000
set ADR_SDRAM 0x08000000

#
#  Настройка подключения к интерфейсу для возможности сразу писать и считывать данные
#
set service_paths [get_service_paths master]
# Создаем алиас для адреса FPGA
set my_master [lindex $service_paths 0]
set c_path [claim_service master $my_master ""]

# Открываем канал для выполнения операций с внутренним интерфейсом
open_service master $c_path
puts "Connection established on path in variable 'c_path' "

#
# Функция для записи прошивки из hex файла в память по адресу
#
proc write_firmware {hex_file_path base_address} {
    # Получаем пути к мастер-сервисам FPGA
    set service_paths [get_service_paths master]
    
    if {[llength $service_paths] == 0} {
        puts "Error: No master service paths found"
        return -1
    }
    
    # Создаем алиас для адреса FPGA
    set my_master [lindex $service_paths 0]
    set c_path [claim_service master $my_master ""]
    
    # Открываем канал для выполнения операций с внутренним интерфейсом
    open_service master $c_path
    
    puts "Master service opened successfully"
    puts "Reading firmware from: $hex_file_path"
    puts "Writing to base address: [format "0x%08X" $base_address]"
    
    # Открываем hex файл для чтения
    if {![file exists $hex_file_path]} {
        puts "Error: File $hex_file_path does not exist"
        close_service master $c_path
        return -1
    }
    
    set hex_file [open $hex_file_path r]
    set current_address $base_address
    set word_count 0
    set line_number 0
    
    # Читаем и записываем каждую строку
    while {[gets $hex_file line] >= 0} {
        incr line_number
        
        # Пропускаем пустые строки
        if {[string trim $line] == ""} {
            continue
        }
        
        # Конвертируем hex строку в целое число
        # Каждая строка содержит 8 hex символов (32-битное слово)
        set hex_value [string trim $line]
        
        # Проверяем валидность hex строки (должно быть 8 hex цифр)
        if {[string length $hex_value] != 8} {
            puts "Warning: Line $line_number has invalid length: $hex_value"
            continue
        }
        
        # Конвертируем hex строку в десятичное целое число
        set decimal_value [expr 0x$hex_value]
        
        # Записываем 32-битное слово в память
        master_write_32 $c_path $current_address $decimal_value
        
        # Увеличиваем адрес на 4 байта (32 бита)
        set current_address [expr $current_address + 0x4]
        incr word_count
        
        # Индикатор прогресса каждые 256 слов
        if {[expr $word_count % 256] == 0} {
            puts "Written $word_count words to address [format "0x%08X" [expr $current_address - 4]]"
        }
    }
    
    close $hex_file
    close_service master $c_path
    
    puts "Firmware write completed successfully"
    puts "Total words written: $word_count"
    puts "Last address written: [format "0x%08X" [expr $current_address - 4]]"
    
    return 0
}