onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/CLOCK_50
add wave -noupdate -label botrom_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HADDR
add wave -noupdate -label bootrom_ready /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADY
add wave -noupdate -label bootrom_read_out /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADRom
add wave -noupdate /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HADDR
add wave -noupdate -label core_rdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HRDATA
add wave -noupdate -label core_wdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HWDATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 61
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 fs} {162458232 fs}
