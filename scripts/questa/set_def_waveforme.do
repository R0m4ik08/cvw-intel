onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /testbench/CLOCK_50
add wave -noupdate -label KEY0_reset {/testbench/KEY[0]}
add wave -noupdate -label HADDR /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/HADDR
add wave -noupdate -group bootrom -label botrom_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HADDR
add wave -noupdate -group bootrom -label bootrom_ready /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADY
add wave -noupdate -group bootrom -label bootrom_read_out /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADRom
add wave -noupdate -group core -label core_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HADDR
add wave -noupdate -group core -label core_rdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HRDATA
add wave -noupdate -group core -label core_wdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HWDATA
add wave -noupdate -group IFU -label IFU_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/IFUHADDR
add wave -noupdate -group IFU -label IFU_trans /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/IFUHTRANS
add wave -noupdate -group IFU -label IFU_PCE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/PCE
add wave -noupdate -group HZU -group IN -label CSR /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/CSRWriteFenceM
add wave -noupdate -group HZU -group IN -label Structural /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StructuralStallD
add wave -noupdate -group HZU -group IN -label LSU_M /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/LSUStallM
add wave -noupdate -group HZU -group IN -label IFU_F /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/IFUStallF
add wave -noupdate -group HZU -group OUT -group HZU_STALL -label StallF /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallF
add wave -noupdate -group HZU -group OUT -group HZU_STALL -label StallD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallD
add wave -noupdate -group HZU -group OUT -group HZU_STALL -label StallE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallE
add wave -noupdate -group HZU -group OUT -group HZU_STALL -label StallM /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallM
add wave -noupdate -group HZU -group OUT -group HZU_STALL -label StallW /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallW
add wave -noupdate -group HZU -group OUT -group HZU_FLUSH -label FlushD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushD
add wave -noupdate -group HZU -group OUT -group HZU_FLUSH -label FlushE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushE
add wave -noupdate -group HZU -group OUT -group HZU_FLUSH -label FlushM /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushM
add wave -noupdate -group HZU -group OUT -group HZU_FLUSH -label FlushW /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushW
add wave -noupdate -group IFU_AHB_BUS_FSM -group IN -label HCLK /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HCLK
add wave -noupdate -group IFU_AHB_BUS_FSM -group IN -label HRESETn /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HRESETn
add wave -noupdate -group IFU_AHB_BUS_FSM -group IN -label Stall /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/Stall
add wave -noupdate -group IFU_AHB_BUS_FSM -group IN -label Flush /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/Flush
add wave -noupdate -group IFU_AHB_BUS_FSM -group IN -label BusRW /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusRW
add wave -noupdate -group IFU_AHB_BUS_FSM -group IN -label BusAtomic /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusAtomic
add wave -noupdate -group IFU_AHB_BUS_FSM -group IN -label HREADY /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HREADY
add wave -noupdate -group IFU_AHB_BUS_FSM -group OUT -label CaptureEn /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/CaptureEn
add wave -noupdate -group IFU_AHB_BUS_FSM -group OUT -label BusStall /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusStall
add wave -noupdate -group IFU_AHB_BUS_FSM -group OUT -label BusCommitted /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusCommitted
add wave -noupdate -group IFU_AHB_BUS_FSM -group OUT -label HTRANS /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HTRANS
add wave -noupdate -group IFU_AHB_BUS_FSM -group OUT -label HWRITE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HWRITE
add wave -noupdate -group IFU_AHB_BUS_FSM -label CurrState /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/CurrState
add wave -noupdate -group IFU_AHB_BUS_FSM -label NextState /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/NextState
add wave -noupdate -group GPIO -label GPIO_EN /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/GPIOEN
add wave -noupdate -group GPIO -label GPIO_IN /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/GPIOIN
add wave -noupdate -group GPIO -label GPIO_OUT /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/GPIOOUT
add wave -noupdate -group ram -expand -group IN -label HSELRam /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HSELRam
add wave -noupdate -group ram -expand -group IN -label HWDATA /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HWDATA
add wave -noupdate -group ram -expand -group IN -label HWRITE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HWRITE
add wave -noupdate -group ram -expand -group OUT -label HREADYRam /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HREADYRam
add wave -noupdate -group ram -expand -group OUT -label HREADRam /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/ram/ram/HREADRam
add wave -noupdate -label KEY /testbench/KEY
add wave -noupdate -label SW /testbench/SW
add wave -noupdate -label LEDR /testbench/LEDR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
configure wave -valuecolwidth 56
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
WaveRestoreZoom {0 fs} {81003374 fs}
bookmark add wave bookmark0 {{100018427381 fs} {100304293296 fs}} 0
