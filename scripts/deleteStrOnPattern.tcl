#!/usr/bin/env tclsh

# Проверяем количество аргументов
if {$argc != 2} {
    puts "Using: tclsh remove_line.tcl <file_name> <pattern>"
    exit 1
}

# Получаем аргументы
set filename [lindex $argv 0]
set pattern [lindex $argv 1]

# Проверяем, существует ли файл
if {![file exists $filename]} {
    puts "Error: file '$filename' not found."
    exit 1
}

# Создаём резервную копию
set backup "${filename}.bak"
file copy -force $filename $backup
puts "Reserve copy was created: $backup"

# Создаём временный файл
set tempname "${filename}.tmp"

# Открываем файлы
set in [open $filename r]
set out [open $tempname w]

# Построчная фильтрация
set count 0
while {[gets $in line] >= 0} {
    if {[string match "*$pattern*" $line]} {
        incr count
        continue
    }
    puts $out $line
}

close $in
close $out

# Перезаписываем оригинальный файл новым содержимым
file rename -force $tempname $filename

puts "Ready: deleted $count string(s), contain pattern '$pattern'."
puts "File '$filename' updated."
