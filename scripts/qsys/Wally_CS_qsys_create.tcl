# qsys scripting (.tcl) file for Wally_CS
package require -exact qsys 16.0

# === Глобальные параметры системы ===
set XLEN 32
set PA_BITS 34

create_system {Wally_CS}

set_project_property DEVICE_FAMILY {Cyclone IV E}
set_project_property DEVICE {EP4CE115F29C7}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance HEX3_HEX0 altera_avalon_pio 23.1
set_instance_parameter_value HEX3_HEX0 {bitClearingEdgeCapReg} {0}
set_instance_parameter_value HEX3_HEX0 {bitModifyingOutReg} {0}
set_instance_parameter_value HEX3_HEX0 {captureEdge} {0}
set_instance_parameter_value HEX3_HEX0 {direction} {Output}
set_instance_parameter_value HEX3_HEX0 {edgeType} {RISING}
set_instance_parameter_value HEX3_HEX0 {generateIRQ} {0}
set_instance_parameter_value HEX3_HEX0 {irqType} {LEVEL}
set_instance_parameter_value HEX3_HEX0 {resetValue} {0.0}
set_instance_parameter_value HEX3_HEX0 {simDoTestBenchWiring} {0}
set_instance_parameter_value HEX3_HEX0 {simDrivenValue} {0.0}
set_instance_parameter_value HEX3_HEX0 {width} $XLEN

add_instance JTAG_to_FPGA_Bridge altera_jtag_avalon_master 23.1
set_instance_parameter_value JTAG_to_FPGA_Bridge {FAST_VER} {0}
set_instance_parameter_value JTAG_to_FPGA_Bridge {FIFO_DEPTHS} {2}
set_instance_parameter_value JTAG_to_FPGA_Bridge {PLI_PORT} {50000}
set_instance_parameter_value JTAG_to_FPGA_Bridge {USE_PLI} {0}

add_instance SRAM altera_up_avalon_sram 18.0
set_instance_parameter_value SRAM {board} {DE2-115}
set_instance_parameter_value SRAM {pixel_buffer} {0}

add_instance System_PLL altera_up_avalon_sys_sdram_pll 18.0
set_instance_parameter_value System_PLL {CIII_boards} {DE0}
set_instance_parameter_value System_PLL {CIV_boards} {DE2-115}
set_instance_parameter_value System_PLL {CV_boards} {DE10-Standard}
set_instance_parameter_value System_PLL {MAX10_boards} {DE10-Lite}
set_instance_parameter_value System_PLL {gui_outclk} {50.0}
set_instance_parameter_value System_PLL {gui_refclk} {50.0}
set_instance_parameter_value System_PLL {other_boards} {None}

add_instance ahb_to_ext_bridge_0 ahb_to_ext_bridge 1.0
set_instance_parameter_value ahb_to_ext_bridge_0 {AHB_ADDR_W} $PA_BITS
set_instance_parameter_value ahb_to_ext_bridge_0 {AHB_DATA_W} $XLEN
set_instance_parameter_value ahb_to_ext_bridge_0 {EXT_ADDR_W} {30}
set_instance_parameter_value ahb_to_ext_bridge_0 {EXT_DATA_W} $XLEN

add_instance bridge_0 altera_up_external_bus_to_avalon_bridge 18.0
set_instance_parameter_value bridge_0 {addr_size} {1024}
set_instance_parameter_value bridge_0 {addr_size_multiplier} {Mbytes}
set_instance_parameter_value bridge_0 {data_size} {32}

add_instance reset_controller_0 altera_reset_controller 23.1
set_instance_parameter_value reset_controller_0 {MIN_RST_ASSERTION_TIME} {3}
set_instance_parameter_value reset_controller_0 {NUM_RESET_INPUTS} {2}
set_instance_parameter_value reset_controller_0 {OUTPUT_RESET_SYNC_EDGES} {deassert}
set_instance_parameter_value reset_controller_0 {RESET_REQUEST_PRESENT} {0}
set_instance_parameter_value reset_controller_0 {RESET_REQ_EARLY_DSRT_TIME} {1}
set_instance_parameter_value reset_controller_0 {RESET_REQ_WAIT_TIME} {1}
set_instance_parameter_value reset_controller_0 {SYNC_DEPTH} {2}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN0} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN1} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN10} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN11} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN12} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN13} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN14} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN15} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN2} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN3} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN4} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN5} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN6} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN7} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN8} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_IN9} {0}
set_instance_parameter_value reset_controller_0 {USE_RESET_REQUEST_INPUT} {0}

add_instance sdram_128mb_0 sdram_128mb 1.0

add_instance wallypipelinedsocwrapper_0 wallypipelinedsocwrapper 1.0
set_instance_parameter_value wallypipelinedsocwrapper_0 {AHBW} $XLEN
set_instance_parameter_value wallypipelinedsocwrapper_0 {PA_BITS} $PA_BITS
set_instance_parameter_value wallypipelinedsocwrapper_0 {XLEN} $XLEN

# exported interfaces
add_interface hex3_hex0 conduit end
set_interface_property hex3_hex0 EXPORT_OF HEX3_HEX0.external_connection
add_interface reset_export reset sink
set_interface_property reset_export EXPORT_OF reset_controller_0.reset_in1
add_interface sdram conduit end
set_interface_property sdram EXPORT_OF sdram_128mb_0.wire
add_interface sdram_clk clock source
set_interface_property sdram_clk EXPORT_OF System_PLL.sdram_clk
add_interface sram_external_interface conduit end
set_interface_property sram_external_interface EXPORT_OF SRAM.external_interface
add_interface system_pll_ref_clk clock sink
set_interface_property system_pll_ref_clk EXPORT_OF System_PLL.ref_clk
add_interface system_pll_ref_reset reset sink
set_interface_property system_pll_ref_reset EXPORT_OF System_PLL.ref_reset
add_interface wally_control conduit end
set_interface_property wally_control EXPORT_OF wallypipelinedsocwrapper_0.control
add_interface wally_gpio conduit end
set_interface_property wally_gpio EXPORT_OF wallypipelinedsocwrapper_0.GPIO
add_interface wally_sdc conduit end
set_interface_property wally_sdc EXPORT_OF wallypipelinedsocwrapper_0.SDC
add_interface wally_spi conduit end
set_interface_property wally_spi EXPORT_OF wallypipelinedsocwrapper_0.SPI
add_interface wally_uart conduit end
set_interface_property wally_uart EXPORT_OF wallypipelinedsocwrapper_0.UART

# connections and connection parameters
add_connection JTAG_to_FPGA_Bridge.master HEX3_HEX0.s1
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/HEX3_HEX0.s1 arbitrationPriority {1}
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/HEX3_HEX0.s1 baseAddress {0x03000000}
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/HEX3_HEX0.s1 defaultConnection {0}

add_connection JTAG_to_FPGA_Bridge.master SRAM.avalon_sram_slave
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/SRAM.avalon_sram_slave arbitrationPriority {1}
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/SRAM.avalon_sram_slave baseAddress {0x02000000}
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/SRAM.avalon_sram_slave defaultConnection {0}

add_connection JTAG_to_FPGA_Bridge.master sdram_128mb_0.s1
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/sdram_128mb_0.s1 arbitrationPriority {1}
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/sdram_128mb_0.s1 baseAddress {0x08000000}
set_connection_parameter_value JTAG_to_FPGA_Bridge.master/sdram_128mb_0.s1 defaultConnection {0}

add_connection System_PLL.reset_source reset_controller_0.reset_in0

add_connection System_PLL.sys_clk HEX3_HEX0.clk

add_connection System_PLL.sys_clk JTAG_to_FPGA_Bridge.clk

add_connection System_PLL.sys_clk SRAM.clk

add_connection System_PLL.sys_clk ahb_to_ext_bridge_0.clock

add_connection System_PLL.sys_clk bridge_0.clk

add_connection System_PLL.sys_clk reset_controller_0.clk

add_connection System_PLL.sys_clk sdram_128mb_0.clk

add_connection System_PLL.sys_clk wallypipelinedsocwrapper_0.clock

add_connection ahb_to_ext_bridge_0.ExtBus_m bridge_0.external_interface
set_connection_parameter_value ahb_to_ext_bridge_0.ExtBus_m/bridge_0.external_interface endPort {}
set_connection_parameter_value ahb_to_ext_bridge_0.ExtBus_m/bridge_0.external_interface endPortLSB {0}
set_connection_parameter_value ahb_to_ext_bridge_0.ExtBus_m/bridge_0.external_interface startPort {}
set_connection_parameter_value ahb_to_ext_bridge_0.ExtBus_m/bridge_0.external_interface startPortLSB {0}
set_connection_parameter_value ahb_to_ext_bridge_0.ExtBus_m/bridge_0.external_interface width {0}

add_connection bridge_0.avalon_master HEX3_HEX0.s1
set_connection_parameter_value bridge_0.avalon_master/HEX3_HEX0.s1 arbitrationPriority {1}
set_connection_parameter_value bridge_0.avalon_master/HEX3_HEX0.s1 baseAddress {0x03000000}
set_connection_parameter_value bridge_0.avalon_master/HEX3_HEX0.s1 defaultConnection {0}

add_connection bridge_0.avalon_master SRAM.avalon_sram_slave
set_connection_parameter_value bridge_0.avalon_master/SRAM.avalon_sram_slave arbitrationPriority {1}
set_connection_parameter_value bridge_0.avalon_master/SRAM.avalon_sram_slave baseAddress {0x02000000}
set_connection_parameter_value bridge_0.avalon_master/SRAM.avalon_sram_slave defaultConnection {0}

add_connection bridge_0.avalon_master sdram_128mb_0.s1
set_connection_parameter_value bridge_0.avalon_master/sdram_128mb_0.s1 arbitrationPriority {1}
set_connection_parameter_value bridge_0.avalon_master/sdram_128mb_0.s1 baseAddress {0x08000000}
set_connection_parameter_value bridge_0.avalon_master/sdram_128mb_0.s1 defaultConnection {0}

add_connection reset_controller_0.reset_out wallypipelinedsocwrapper_0.reset_inp

add_connection wallypipelinedsocwrapper_0.AHB_m ahb_to_ext_bridge_0.AHB_s
set_connection_parameter_value wallypipelinedsocwrapper_0.AHB_m/ahb_to_ext_bridge_0.AHB_s endPort {}
set_connection_parameter_value wallypipelinedsocwrapper_0.AHB_m/ahb_to_ext_bridge_0.AHB_s endPortLSB {0}
set_connection_parameter_value wallypipelinedsocwrapper_0.AHB_m/ahb_to_ext_bridge_0.AHB_s startPort {}
set_connection_parameter_value wallypipelinedsocwrapper_0.AHB_m/ahb_to_ext_bridge_0.AHB_s startPortLSB {0}
set_connection_parameter_value wallypipelinedsocwrapper_0.AHB_m/ahb_to_ext_bridge_0.AHB_s width {0}

add_connection wallypipelinedsocwrapper_0.reset_out HEX3_HEX0.reset

add_connection wallypipelinedsocwrapper_0.reset_out JTAG_to_FPGA_Bridge.clk_reset

add_connection wallypipelinedsocwrapper_0.reset_out SRAM.reset

add_connection wallypipelinedsocwrapper_0.reset_out ahb_to_ext_bridge_0.reset_sink

add_connection wallypipelinedsocwrapper_0.reset_out bridge_0.reset

add_connection wallypipelinedsocwrapper_0.reset_out sdram_128mb_0.reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.enableInstrumentation} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {Wally_CS.qsys}
