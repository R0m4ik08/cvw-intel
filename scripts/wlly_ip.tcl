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
# Generated on: Sun Oct 19 20:29:36 2025

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
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/counter.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fma/fmasign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fma/fmalza.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fhazard.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtuslc4cmp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtuslc4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtuslc2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/roundsign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/resultsign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fregfile.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/unpackinput.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/unpack.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/packoutput.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fsgninj.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fround.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/specialcase.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/shiftcorrection.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fpu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fmtparams.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fli.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fcvt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fctrl.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fcmp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fclassify.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/round.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/postprocess.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/normshift.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/negateintres.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/fmashiftcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/flags.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/divshiftcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/postproc/cvtshiftcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fma/fmamult.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fma/fmaexpadd.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fma/fmaalign.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fma/fmaadd.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fma/fma.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtuotfc4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtuotfc2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtstage4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtstage2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtpreproc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtiter.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtfsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtfgen4.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtfgen2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtpostproc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtexpcalc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrtcycles.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/fpu/fdivsqrt/fdivsqrt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mdu/mul.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mdu/mdu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mdu/divstep.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mdu/div.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/trap.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/privpiperegs.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/privmode.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/privileged.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/privdec.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/csru.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/csrsr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/csrs.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/csrm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/csri.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/csrc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/privileged/csr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/hazard/hazard.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/swbytemask.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/subwordwrite.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/subwordread.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/lsu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/lrsc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/endianswap.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/dtim.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/atomic.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/amoalu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/lsu/align.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/rotate.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/rconlut32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/galoismultinverse8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/galoismultforward8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/bitreverse.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesshiftrows64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aessbox32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aessbox8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesmixcolumns32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesmixcolumns8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesinvshiftrows64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesinvsbox64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesinvsbox8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesinvmixcolumns32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aesinvmixcolumns8.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aes64ks2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aes64ks1i.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aes64e.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aes64d.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aes32e.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/aes/aes32d.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/zknh64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/zknh32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/zipper.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/zbkx.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/zbkb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/zbb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/sha/sha512_64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/sha/sha512_32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/sha/sha256.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/regfile.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/popcnt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/packer.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/ext.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/comparator.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/cnt.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/clmul.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/byteop.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/shifter.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/ieu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/extend.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/datapath.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/controller.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/zknde64.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/kmu/zknde32.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/zbc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/bmuctrl.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/bmu/bitmanipalu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ieu/alu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ebu/ebufsmarb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ebu/ebu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ebu/controllerinput.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ebu/busfsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ebu/buscachefsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ebu/ahbinterface.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ebu/ahbcacheinterface.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/cache/subcachelineread.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/cache/cacheway.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/cache/cacheLRU.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/cache/cachefsm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/cache/cache.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/or_rows.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlblru.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/pmpchecker.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/pmpadrdec.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/pmachecker.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/hptw.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/vm64check.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlbramline.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlbram.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlbmixer.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlbcontrol.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlbcamline.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/mmu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/tlb/tlbcam.sv
	set_global_assignment -name QIP_FILE "quartus ip/ram1p1rwbe/ram1p1rwbe.qip"
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/satCounter2.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/twoBitPredictor.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/localrepairbp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/localbpbasic.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/localaheadbp.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/icpred.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/gsharebasic.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/gshare.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/btb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/spill.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/irom.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/ifu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/RASPredictor.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/decompress.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/ifu/bpred/bpred.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/wally/wallypipelinedcore.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/mem/rom1p1r.sv
	set_global_assignment -name HEX_FILE zsbl/rom_init.hex
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/mux.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/flop/flopr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/flop/flopenrc.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/flop/flopenr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/flop/flopenl.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/flop/flopen.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/flop/flop.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/adrdec.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/mmu/adrdecs.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/uncore.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/uartPC16550D.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/uart_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/trickbox_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/spi_fifo.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/spi_controller.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/spi_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/rom_ahb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/ram_ahb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/plic_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/gpio_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/clint_apb.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/uncore/ahbapbbridge.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/config/config.vh
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/generic/flop/synchronizer.sv
	set_global_assignment -name SYSTEMVERILOG_FILE src/CopiedFiles_do_not_add_to_repo/wally/wallypipelinedsoc.sv
	set_global_assignment -name VERILOG_INCLUDE_FILE src/BranchPredictorType.vh
	set_global_assignment -name QIP_FILE "quartus ip/rom1p1r_/rom1p1r_.qip"
	set_global_assignment -name QIP_FILE "quartus ip/ram2p1r1wbe/ram2p1r1wbe.qip"
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
