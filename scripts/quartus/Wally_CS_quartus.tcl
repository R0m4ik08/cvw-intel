# Copyright (C) 2023  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: Wally_CS.tcl
# Generated on: Tue Oct 28 22:03:07 2025

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "Wally_CS"]} {
		puts "Project Wally_CS is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists Wally_CS]} {
		project_open -revision Wally_CS Wally_CS
	} else {
		project_new -revision Wally_CS Wally_CS
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE115F29C7
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 21.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "20:42:31  AUGUST 28, 2025"
	set_global_assignment -name LAST_QUARTUS_VERSION "23.1std.0 Lite Edition"

	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
	set_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP
	set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL Custom
	set_global_assignment -name VERILOG_INPUT_VERSION SYSTEMVERILOG_2005
	set_global_assignment -name VERILOG_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name IGNORE_VERILOG_INITIAL_CONSTRUCTS ON
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name EDA_SIMULATION_TOOL "<None>"
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"

	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT NONE -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_INPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_design_synthesis

	set_global_assignment -name VERILOG_MACRO "QARTUS_PRJ=1"

	set_global_assignment -name TOP_LEVEL_ENTITY fpgaTop
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpgaTop.sv
	set_global_assignment -name QIP_FILE Wally_CS/synthesis/Wally_CS.qip
	set_global_assignment -name QIP_FILE ../qip/Wally_PS.qip
	
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -entity DE2_115_Computer -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -entity DE2_115_Computer -section_id Top
	set_global_assignment -name LL_ROOT_REGION ON -entity DE2_115_Computer -section_id "Root Region"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -entity DE2_115_Computer -section_id "Root Region"
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -entity DE2_115_Computer -section_id Top
	
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -entity DE2_115_Computer -section_id Top
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
