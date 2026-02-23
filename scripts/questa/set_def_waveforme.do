onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /testbench/CLOCK_50
add wave -noupdate /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/HREADY
add wave -noupdate -label HADDR /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/HADDR
add wave -noupdate -label HRDATA /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/HRDATA
add wave -noupdate -group bootrom -label rom_adr_in /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/memory/addr
add wave -noupdate -group bootrom -label botrom_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HADDR
add wave -noupdate -group bootrom -label bootrom_ready /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADY
add wave -noupdate -group bootrom -label bootrom_read_out /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADRom
add wave -noupdate -group ram -expand -group IN -label HSELRam /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HSELRam
add wave -noupdate -group ram -expand -group IN -label HWDATA /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HWDATA
add wave -noupdate -group ram -expand -group IN -label HWRITE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HWRITE
add wave -noupdate -group ram -group OUT -label HREADYRam /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HREADYRam
add wave -noupdate -group ram -group OUT -label HREADRam /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HREADRam
add wave -noupdate -expand -group core -label core_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HADDR
add wave -noupdate -expand -group core -label core_rdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HRDATA
add wave -noupdate -expand -group core -label core_wdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HWDATA
add wave -noupdate -expand -group IFU -label IFU_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/IFUHADDR
add wave -noupdate -expand -group IFU -label IFU_trans /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/IFUHTRANS
add wave -noupdate -expand -group IFU -label IFU_PCE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/PCE
add wave -noupdate -group HSEL_dealay -label HSEL_bootromD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/HSELBootRomD
add wave -noupdate -group HSEL_dealay -label HSEL_brgD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/HSELBRIDGED
add wave -noupdate -group HSEL_dealay -label HSEL_EXTD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/HSELEXTD
add wave -noupdate -group HSEL_dealay -label HSEL_RamD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/HSELRamD
add wave -noupdate -group b_ahb_ext -group AHB -label hsel /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/hsel
add wave -noupdate -group b_ahb_ext -group AHB /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/hsize
add wave -noupdate -group b_ahb_ext -group AHB /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/hwrite
add wave -noupdate -group b_ahb_ext -group AHB -label haddr /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/haddr
add wave -noupdate -group b_ahb_ext -group AHB -label hwdata /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/hwdata
add wave -noupdate -group b_ahb_ext -group AHB /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/hrdata
add wave -noupdate -group b_ahb_ext -group EXT /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/ext_ack
add wave -noupdate -group b_ahb_ext -group EXT /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/ext_write
add wave -noupdate -group b_ahb_ext -group EXT /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/ext_read
add wave -noupdate -group b_ahb_ext -group EXT /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/ext_addr
add wave -noupdate -group b_ahb_ext -group EXT /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/ext_wdata
add wave -noupdate -group b_ahb_ext -group EXT /testbench/dut/Wally_CS_inst/ahb_to_ext_bridge_0/ext_rdata
add wave -noupdate -expand -group Avalon /testbench/dut/Wally_CS_inst/bridge_0/avalon_byteenable
add wave -noupdate -expand -group Avalon /testbench/dut/Wally_CS_inst/bridge_0/avalon_address
add wave -noupdate -expand -group Avalon /testbench/dut/Wally_CS_inst/bridge_0/avalon_readdata
add wave -noupdate -expand -group contr_sram /testbench/dut/Wally_CS_inst/sram/address
add wave -noupdate -expand -group contr_sram /testbench/dut/Wally_CS_inst/sram/read
add wave -noupdate -expand -group contr_sram /testbench/dut/Wally_CS_inst/sram/write
add wave -noupdate -expand -group contr_sram /testbench/dut/Wally_CS_inst/sram/writedata
add wave -noupdate -expand -group contr_sram /testbench/dut/Wally_CS_inst/sram/readdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {6189996227 fs} 1} {{Cursor 1} {4130000085 fs} 1} {{Cursor 7} {4133049636 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 162
configure wave -valuecolwidth 86
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {6087356252 fs} {6403117493 fs}
bookmark add wave bookmark0 {{100018427381 fs} {100304293296 fs}} 0
