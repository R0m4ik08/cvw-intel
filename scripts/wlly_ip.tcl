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
# File: wlly_ip.tcl
# Generated on: Mon Oct 20 00:06:00 2025

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "wlly_ip"]} {
		puts "Project wlly_ip is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists wlly_ip]} {
		project_open -revision wlly_ip wlly_ip
	} else {
		project_new -revision wlly_ip wlly_ip
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 24.1STD.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "20:44:41  SEPTEMBER 26, 2025"
	set_global_assignment -name LAST_QUARTUS_VERSION "23.1std.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/counter.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fma/fmasign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fma/fmalza.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fhazard.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtuslc4cmp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtuslc4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtuslc2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/roundsign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/resultsign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fregfile.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/unpackinput.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/unpack.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/packoutput.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fsgninj.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fround.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/specialcase.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/shiftcorrection.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fpu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fmtparams.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fli.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fcvt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fctrl.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fcmp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fclassify.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/round.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/postprocess.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/normshift.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/negateintres.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/fmashiftcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/flags.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/divshiftcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/postproc/cvtshiftcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fma/fmamult.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fma/fmaexpadd.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fma/fmaalign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fma/fmaadd.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fma/fma.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtuotfc4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtuotfc2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtstage4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtstage2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtpreproc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtiter.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtfsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtfgen4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtfgen2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtpostproc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtexpcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrtcycles.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/fpu/fdivsqrt/fdivsqrt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mdu/mul.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mdu/mdu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mdu/divstep.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mdu/div.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/trap.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/privpiperegs.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/privmode.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/privileged.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/privdec.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/csru.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/csrsr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/csrs.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/csrm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/csri.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/csrc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/privileged/csr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/hazard/hazard.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/swbytemask.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/subwordwrite.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/subwordread.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/lsu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/lrsc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/endianswap.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/dtim.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/atomic.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/amoalu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/lsu/align.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/rotate.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/rconlut32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/galoismultinverse8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/galoismultforward8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/bitreverse.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesshiftrows64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aessbox32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aessbox8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesmixcolumns32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesmixcolumns8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesinvshiftrows64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesinvsbox64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesinvsbox8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesinvmixcolumns32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aesinvmixcolumns8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aes64ks2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aes64ks1i.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aes64e.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aes64d.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aes32e.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/aes/aes32d.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/zknh64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/zknh32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/zipper.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/zbkx.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/zbkb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/zbb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/sha/sha512_64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/sha/sha512_32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/sha/sha256.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/regfile.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/popcnt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/packer.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/ext.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/comparator.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/cnt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/clmul.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/byteop.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/shifter.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/ieu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/extend.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/datapath.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/controller.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/zknde64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/kmu/zknde32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/zbc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/bmuctrl.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/bmu/bitmanipalu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ieu/alu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ebu/ebufsmarb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ebu/ebu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ebu/controllerinput.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ebu/busfsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ebu/buscachefsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ebu/ahbinterface.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ebu/ahbcacheinterface.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/cache/subcachelineread.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/cache/cacheway.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/cache/cacheLRU.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/cache/cachefsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/cache/cache.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/or_rows.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlblru.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/pmpchecker.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/pmpadrdec.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/pmachecker.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/hptw.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/vm64check.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlbramline.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlbram.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlbmixer.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlbcontrol.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlbcamline.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/mmu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/tlb/tlbcam.sv
	set_global_assignment -name QIP_FILE "quartus ip/ram1p1rwbe/ram1p1rwbe.qip"
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/satCounter2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/twoBitPredictor.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/localrepairbp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/localbpbasic.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/localaheadbp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/icpred.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/gsharebasic.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/gshare.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/btb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/spill.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/irom.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/ifu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/RASPredictor.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/decompress.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/ifu/bpred/bpred.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/wally/wallypipelinedcore.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/mem/rom1p1r.sv
	set_global_assignment -name HEX_FILE zsbl/rom_init.hex
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/mux.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/flop/flopr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/flop/flopenrc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/flop/flopenr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/flop/flopenl.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/flop/flopen.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/flop/flop.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/adrdec.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/mmu/adrdecs.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/uncore.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/uartPC16550D.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/uart_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/trickbox_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/spi_fifo.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/spi_controller.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/spi_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/rom_ahb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/ram_ahb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/plic_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/gpio_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/clint_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/uncore/ahbapbbridge.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/config/config.vh
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/generic/flop/synchronizer.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/wally/wallypipelinedsoc.sv
	set_global_assignment -name VERILOG_INCLUDE_FILE ../src/BranchPredictorType.vh
	set_global_assignment -name QIP_FILE "quartus ip/rom1p1r_/rom1p1r_.qip"
	set_global_assignment -name QIP_FILE "quartus ip/ram2p1r1wbe/ram2p1r1wbe.qip"
	set_global_assignment -name SYSTEMVERILOG_FILE ../src/wallypipelinedsocwrapper.sv
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name TOP_LEVEL_ENTITY wallypipelinedsocwrapper
	set_global_assignment -name DEVICE auto
	set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
