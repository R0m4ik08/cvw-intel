puts "Start write_firmware!!!"

set firmware_hex_file sdk/build/program.hex
set start_address $ADR_SRAM

write_firmware $firmware_hex_file $start_address

puts "Check firmware!!!"
 
puts [master_read_32 $c_path $start_address 0x10]
