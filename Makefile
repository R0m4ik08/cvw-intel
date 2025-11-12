PROJECT = Wally_CS
REVISION = Wally_CS
BUILD_DIR = build

QUARTUS_BIN := $(QUARTUS_ROOTDIR)\bin64
QSYS_BIN := $(QUARTUS_ROOTDIR)\sopc_builder\bin

PRJ_QSYS_DIR := ip_cores/qsys

FILE_NAME_QSYS_IPS_TCL := $(notdir $(wildcard $(PRJ_QSYS_DIR)/*.tcl ) )
FILE_NAME_QSYS_IPS_SRC := $(notdir $(wildcard $(PRJ_QSYS_DIR)/src/* ) )

PATH +=;$(QUARTUS_BIN);
PATH +=;$(QSYS_BIN);

.PHONY: all qsys_generate quartus_create quartus_build  clean 

all: qsys_generate quartus_create 

$(BUILD_DIR): 
	mkdir -p $@
	mkdir -p $@/qsys
	mkdir -p $@/qsys/src

$(BUILD_DIR)/qsys/%.tcl: $(PRJ_QSYS_DIR)/%.tcl | $(BUILD_DIR)
	cp $< $@

$(BUILD_DIR)/qsys/src/%: $(PRJ_QSYS_DIR)/src/% | $(BUILD_DIR)
	cp $< $@

qsys_prep: $(patsubst %, $(BUILD_DIR)/qsys/% ,$(FILE_NAME_QSYS_IPS_TCL)) $(patsubst %, $(BUILD_DIR)/qsys/src/% ,$(FILE_NAME_QSYS_IPS_SRC))
	@echo "Qsys files is prepared"

$(BUILD_DIR)/qsys/$(PROJECT).qsys : | qsys_prep
	cd $(BUILD_DIR)/qsys && qsys-script --script=../../scripts/qsys/Wally_CS_qsys_create.tcl

qsys_prj: $(BUILD_DIR)/qsys/$(PROJECT).qsys
	@echo "Qsys project is created"

$(BUILD_DIR)/$(PROJECT)/$(PROJECT)_generation.rpt : $(patsubst %, $(BUILD_DIR)/qsys/% ,$(FILE_NAME_QSYS_IPS_TCL)) $(patsubst %, $(BUILD_DIR)/qsys/src/% ,$(FILE_NAME_QSYS_IPS_SRC)) | qsys_prj
	cd $(BUILD_DIR)/qsys && qsys-generate Wally_CS.qsys --synthesis=VERILOG --output-directory=../Wally_CS
#	Удаляет повторное включение модуля wallypipelinedsocwrapper из сгенерированного Qsys проекта
	quartus_sh -t scripts/deleteStrOnPattern.tcl $(BUILD_DIR)/$(PROJECT)/synthesis/$(PROJECT).qip "submodules/wallypipelinedsocwrapper.sv"

qsys_generate: | $(BUILD_DIR)/$(PROJECT)/$(PROJECT)_generation.rpt
	@echo "Qsys project is generated"

$(BUILD_DIR)/$(PROJECT).qpf: | $(BUILD_DIR)
	cd $(BUILD_DIR) && quartus_sh -t ../scripts/quartus/Wally_CS_quartus.tcl
	cd $(BUILD_DIR) && quartus_sh -t ../scripts/quartus/Wally_CS_set_pin_assignment.tcl

quartus_create: $(BUILD_DIR)/$(PROJECT).qpf
	@echo "Quartus project is created"

quartus_open: $(BUILD_DIR)/$(PROJECT).qpf | qsys_generate
#	через cmd чтобы работала команда start, через start, чтобы терминал не ожидал закрытия приложения
	cmd.exe /c start quartus $<

# TODO: Нужно еще добавить зависимость от Verilog исходников
$(BUILD_DIR)/output_files/$(PROJECT).sof: | qsys_generate quartus_create
	cd $(BUILD_DIR) && quartus_map --read_settings_files=on --write_settings_files=off $(PROJECT) -c $(PROJECT)
	cd $(BUILD_DIR) && quartus_fit --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)
	cd $(BUILD_DIR) && quartus_asm --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)
	cd $(BUILD_DIR) && quartus_eda --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)
#	Собрать проект полностью можно одной командой:
#	cd $(BUILD_DIR) && quartus_sh --flow compile $(PROJECT)

quartus_build: | $(BUILD_DIR)/output_files/$(PROJECT).sof
	@echo "Quartus project is builded"

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