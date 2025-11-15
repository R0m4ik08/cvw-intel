onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /testbench/CLOCK_50
add wave -noupdate -label KEY0_reset {/testbench/KEY[0]}
add wave -noupdate -height 17 -group bootrom -label botrom_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HADDR
add wave -noupdate -height 17 -group bootrom -label bootrom_ready /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADY
add wave -noupdate -height 17 -group bootrom -label bootrom_read_out /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/uncoregen/uncore/bootrom/bootrom/HREADRom
add wave -noupdate -height 17 -group core -label core_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HADDR
add wave -noupdate -height 17 -group core -label core_rdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HRDATA
add wave -noupdate -height 17 -group core -label core_wdata /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/HWDATA
add wave -noupdate -height 17 -group IFU -label IFU_addr /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/IFUHADDR
add wave -noupdate -height 17 -group IFU -label IFU_trans /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/IFUHTRANS
add wave -noupdate -height 17 -group IFU -label IFU_PCE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/PCE
add wave -noupdate -height 17 -expand -group HZU -height 17 -group IN -label CSR /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/CSRWriteFenceM
add wave -noupdate -height 17 -expand -group HZU -height 17 -group IN -label Structural /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StructuralStallD
add wave -noupdate -height 17 -expand -group HZU -height 17 -group IN -label LSU_M /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/LSUStallM
add wave -noupdate -height 17 -expand -group HZU -height 17 -group IN -label IFU_F /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/IFUStallF
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_STALL -label StallF /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallF
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_STALL -label StallD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallD
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_STALL -label StallE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallE
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_STALL -label StallM /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallM
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_STALL -label StallW /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/StallW
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_FLUSH -label FlushD /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushD
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_FLUSH -label FlushE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushE
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_FLUSH -label FlushM /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushM
add wave -noupdate -height 17 -expand -group HZU -group OUT -group HZU_FLUSH -label FlushW /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/hzu/FlushW
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -height 17 -group IN -label HCLK /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HCLK
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -height 17 -group IN -label HRESETn /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HRESETn
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -height 17 -group IN -label Stall /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/Stall
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -height 17 -group IN -label Flush /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/Flush
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -height 17 -group IN -label BusRW /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusRW
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -height 17 -group IN -label BusAtomic /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusAtomic
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -height 17 -group IN -label HREADY /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HREADY
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -group OUT -label CaptureEn /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/CaptureEn
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -group OUT -label BusStall /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusStall
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -group OUT -label BusCommitted /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/BusCommitted
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -group OUT -label HTRANS /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HTRANS
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -group OUT -label HWRITE /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/HWRITE
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -label CurrState /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/CurrState
add wave -noupdate -height 17 -expand -group IFU_AHB_BUS_FSM -label NextState /testbench/dut/Wally_CS_inst/wallypipelinedsocwrapper_0/wallypipelinedsoc/core/ifu/bus/passthrough/ahbinterface/busfsm/NextState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
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
WaveRestoreZoom {0 fs} {209744478 fs}
bookmark add wave bookmark0 {{100018427381 fs} {100304293296 fs}} 0
