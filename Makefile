PROJECT = Wally_CS
REVISION = Wally_CS
BUILD_DIR = build

QUARTUS_BIN := $(QUARTUS_ROOTDIR)\bin64
QSYS_BIN := $(QUARTUS_ROOTDIR)\sopc_builder\bin

PATH +=;$(QUARTUS_BIN);
PATH +=;$(QSYS_BIN);

.PHONY: all quartus_build qsys_generate clean quartus_create

all: qsys_generate quartus_create 

$(BUILD_DIR): 
	mkdir -p $@
	mkdir -p $@/qsys

qsys_prep: | $(BUILD_DIR)
	cp -r ip_cores/qsys/*  $(BUILD_DIR)/qsys

$(BUILD_DIR)/qsys/$(PROJECT).qsys : qsys_prep

qsys_prj: $(BUILD_DIR)/qsys/$(PROJECT).qsys
	cd $(BUILD_DIR)/qsys && qsys-script --script=../../scripts/qsys/Wally_CS_qsys_create.tcl

qsys_generate: qsys_prj
	cd $(BUILD_DIR)/qsys && qsys-generate Wally_CS.qsys --synthesis=VERILOG --output-directory=../Wally_CS
# 	Удаляет повторное включение модуля wallypipelinedsocwrapper из сгенерированного Qsys проекта
	quartus_sh -t scripts/deleteStrOnPattern.tcl $(BUILD_DIR)/$(PROJECT)/synthesis/$(PROJECT).qip "submodules/wallypipelinedsocwrapper.sv"

quartus_create: $(BUILD_DIR)/$(PROJECT).qpf

$(BUILD_DIR)/$(PROJECT).qpf: | $(BUILD_DIR)
	cd $(BUILD_DIR) && quartus_sh -t ../scripts/quartus/Wally_CS_quartus.tcl
	cd $(BUILD_DIR) && quartus_sh -t ../scripts/quartus/Wally_CS_set_pin_assignment.tcl

quartus_open: $(BUILD_DIR)/$(PROJECT).qpf
	quartus $<

quartus_build: qsys_generate quartus_create 
	cd $(BUILD_DIR) && quartus_sh --flow compile $(PROJECT)

quartus_program: quartus_build
	quartus_pgm -c USB-Blaster -m jtag -o "p;output_files/$(REVISION).sof"

clean:
	rm -rf $(BUILD_DIR)

dbg:
	@echo "MK_DBG: START!"

	@echo $(QUARTUS_ROOTDIR)
	@echo $(QUARTUS_BIN)

	@echo "MK_DBG: END!"

#	Вывод всех параметров
# 	$(foreach v,                                        \
#       $(filter-out $(VARS_OLD) VARS_OLD,$(.VARIABLES)), \
#       $(info $(v) = $($(v))))