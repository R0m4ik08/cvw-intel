package require -exact qsys 16.1

set aup_version 1.0

# +-----------------------------------
# | module mod_altera_up_external_bus_to_avalon_bridge
# |
set_module_property DESCRIPTION "Modificated External Bus to Avalon Bridge"
set_module_property NAME mod_altera_up_external_bus_to_avalon_bridge
set_module_property VERSION $aup_version
set_module_property INTERNAL false
set_module_property GROUP "University Program/Bridges"
set_module_property AUTHOR "Bugaev Roman"
set_module_property DISPLAY_NAME "Modificated External Bus to Avalon Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ELABORATION_CALLBACK elaborate
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false

# |
# +-----------------------------------
#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_up_external_bus_to_avalon_bridge
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_up_external_bus_to_avalon_bridge.v VERILOG PATH src/altera_up_external_bus_to_avalon_bridge.v \
	TOP_LEVEL_FILE

# +-----------------------------------
# | parameters
# |
add_parameter addr_size integer 4
set_parameter_property addr_size DISPLAY_NAME "Address Range"
#set_parameter_property addr_size GROUP "Address Range"
set_parameter_property addr_size UNITS None
set_parameter_property addr_size AFFECTS_ELABORATION true
set_parameter_property addr_size AFFECTS_GENERATION true
set_parameter_property addr_size ALLOWED_RANGES {1024 512 256 128 64 32 16 8 4 2 1}
set_parameter_property addr_size VISIBLE true
set_parameter_property addr_size ENABLED true

add_parameter addr_size_multiplier string Kbytes
set_parameter_property addr_size_multiplier DISPLAY_NAME "Address Range Units"
#set_parameter_property addr_size_multiplier GROUP "Address Range"
set_parameter_property addr_size_multiplier UNITS None
set_parameter_property addr_size_multiplier AFFECTS_ELABORATION true
set_parameter_property addr_size_multiplier AFFECTS_GENERATION true
set_parameter_property addr_size_multiplier ALLOWED_RANGES {Mbytes Kbytes bytes}
set_parameter_property addr_size_multiplier VISIBLE true
set_parameter_property addr_size_multiplier ENABLED true

add_parameter data_size integer 16
set_parameter_property data_size DISPLAY_NAME "Data Width"
#set_parameter_property data_size GROUP "Data Width"
set_parameter_property data_size UNITS Bits
set_parameter_property data_size AFFECTS_ELABORATION true
set_parameter_property data_size AFFECTS_GENERATION true
set_parameter_property data_size ALLOWED_RANGES {128 64 32 16 8}
set_parameter_property data_size VISIBLE true
set_parameter_property data_size ENABLED true

#
# HDL Parameters (Скрытые от пользователя, но передаваемые в Verilog как параметры)
#
add_parameter AW INTEGER 15
set_parameter_property AW DISPLAY_NAME AW
set_parameter_property AW TYPE INTEGER
set_parameter_property AW UNITS None
set_parameter_property AW VISIBLE false
set_parameter_property AW DERIVED true
set_parameter_property AW HDL_PARAMETER true

add_parameter DW INTEGER 15
set_parameter_property DW DISPLAY_NAME DW
set_parameter_property DW TYPE INTEGER
set_parameter_property DW UNITS None
set_parameter_property DW VISIBLE false
set_parameter_property DW DERIVED true
set_parameter_property DW HDL_PARAMETER true

add_parameter BW INTEGER 1
set_parameter_property BW DISPLAY_NAME BW
set_parameter_property BW TYPE INTEGER
set_parameter_property BW UNITS None
set_parameter_property BW VISIBLE false
set_parameter_property BW DERIVED true
set_parameter_property BW HDL_PARAMETER true


# |
# +-----------------------------------
# +-----------------------------------
# | connection point clk
# |
add_interface clk clock end
set_interface_property clk enabled true

add_interface_port clk clk clk Input 1

# |
# +-----------------------------------
# +-----------------------------------
# | connection point reset
# |
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset enabled true
set_interface_property reset synchronousEdges DEASSERT

add_interface_port reset reset reset Input 1

# |
# +-----------------------------------
# +-----------------------------------
# | connection point avalon_master
# |
add_interface avalon_master avalon start
set_interface_property avalon_master associatedClock clk
set_interface_property avalon_master associatedReset reset
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master linewrapBursts false

# |
# +-----------------------------------
# +-----------------------------------
# | Elaboration function
# |
proc elaborate {} {
	set addr_size [ get_parameter_value "addr_size" ]
	set addr_size_multiplier [ get_parameter_value "addr_size_multiplier" ]
	set data_size [ get_parameter_value "data_size" ]

	if { $addr_size_multiplier == "Mbytes" } {
		set addr_span [ expr $addr_size * 1048576 ]
	} elseif { $addr_size_multiplier == "Kbytes" } {
		set addr_span [ expr $addr_size * 1024 ]
	} else {
		set addr_span [ expr $addr_size * 1 ]
	}

	set addr_width [ expr int (ceil (log ($addr_span) / (log (2)))) ]
	set byte_en_bits [ expr $data_size / 8 ]

	# Вычисляем значения параметров для передачи в Verilog
	set aw_val [ expr $addr_width - 1 ]
	set dw_val [ expr $data_size - 1 ]
	set bw_val [ expr $byte_en_bits - 1 ]

	# Передаем вычисленные значения в HDL-параметры
	set_parameter_value AW $aw_val
	set_parameter_value DW $dw_val
	set_parameter_value BW $bw_val

	# +-----------------------------------
	# | connection point avalon_master
	# |
	add_interface_port avalon_master avalon_readdata readdata Input $data_size
	add_interface_port avalon_master avalon_waitrequest waitrequest Input 1
	add_interface_port avalon_master avalon_byteenable byteenable Output $byte_en_bits
	add_interface_port avalon_master avalon_read read Output 1
	add_interface_port avalon_master avalon_write write Output 1
	add_interface_port avalon_master avalon_writedata writedata Output $data_size
	add_interface_port avalon_master avalon_address address Output $addr_width

	# |
	# +-----------------------------------
	# +-----------------------------------
	# | connection point external_interface (С исправленными ролями сигналов!)
	# |
	add_interface external_interface conduit end

	add_interface_port external_interface address export_address Input $addr_width
	add_interface_port external_interface byte_enable export_byte_enable Input $byte_en_bits
	add_interface_port external_interface read export_read Input 1
	add_interface_port external_interface write export_write Input 1
	add_interface_port external_interface write_data export_write_data Input $data_size
	add_interface_port external_interface acknowledge export_acknowledge Output 1
	add_interface_port external_interface read_data export_read_data Output $data_size
	# |
	# +-----------------------------------
}
# |
# +-----------------------------------
