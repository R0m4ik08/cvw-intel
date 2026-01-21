PROJECT = Wally_CS
REVISION = Wally_CS
BUILD_DIR = build

QUARTUS_BIN := $(QUARTUS_ROOTDIR)\bin64
QSYS_BIN := $(QUARTUS_ROOTDIR)\sopc_builder\bin
QUESTA_BIN := $(QUARTUS_ROOTDIR)\..\..\questa_sim_2024.1\win64

SRC_QSYS_DIR := ip_cores/qsys

BLD_QSYS_PRJ := $(BUILD_DIR)/simulation/questa

FILE_NAME_QSYS_IPS_TCL := $(notdir $(wildcard $(SRC_QSYS_DIR)/*.tcl ) )
FILE_NAME_QSYS_IPS_SRC := $(notdir $(wildcard $(SRC_QSYS_DIR)/src/* ) )

PATH +=;$(QUARTUS_BIN);
PATH +=;$(QSYS_BIN);

.PHONY: all qsys_generate quartus_create quartus_build clean docker_setup docker_check docker_build docker_load

all: qsys_generate quartus_create

# ========================================
# Docker Environment Setup
# ========================================
DOCKER_IMAGE_NAME := riscv-gnu-toolchain
DOCKER_IMAGE_FILE := docker/riscv-gnu-toolchain
DOCKER_DIR := docker

# Загрузка образа из файла
docker_load:
	@echo "Loading Docker image from file: $(DOCKER_IMAGE_FILE)"
	docker load -i $(DOCKER_IMAGE_FILE)

# Сборка образа из Dockerfile
docker_build:
	@echo "Building Docker image from Dockerfile"
	docker build -t $(DOCKER_IMAGE_NAME):latest $(DOCKER_DIR)

# Проверка и настройка Docker окружения
# 1. Если образ уже есть в Docker - ничего не делаем
# 2. Если образа нет, но есть файл - загружаем из файла
# 3. Если нет ни образа, ни файла - собираем из Dockerfile
docker_check:
	@echo "Checking Docker environment..."
	@if docker image inspect $(DOCKER_IMAGE_NAME) >/dev/null 2>&1; then \
		echo "Docker image '$(DOCKER_IMAGE_NAME)' already exists."; \
	elif [ -f "$(DOCKER_IMAGE_FILE)" ]; then \
		echo "Docker image not found. Image file found at $(DOCKER_IMAGE_FILE)."; \
		echo "Loading image from file..."; \
		docker load -i $(DOCKER_IMAGE_FILE); \
	else \
		echo "Docker image not found. Image file not found."; \
		echo "Building image from Dockerfile..."; \
		docker build -t $(DOCKER_IMAGE_NAME):latest $(DOCKER_DIR); \
	fi

# Alias для удобства
docker_setup: docker_check
	@echo "Docker environment is ready." 

$(BUILD_DIR): 
	mkdir -p $@
	mkdir -p $@/qsys
	mkdir -p $@/qsys/src

$(BUILD_DIR)/qsys/%.tcl: $(SRC_QSYS_DIR)/%.tcl | $(BUILD_DIR)
	cp $< $@

$(BUILD_DIR)/qsys/src/%: $(SRC_QSYS_DIR)/src/% | $(BUILD_DIR)
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
$(BUILD_DIR)/output_files/$(PROJECT).sof: zsbl/bin/boot.mif | qsys_generate zsbl_build quartus_create 
	cd $(BUILD_DIR) && quartus_map --read_settings_files=on --write_settings_files=off $(PROJECT) -c $(PROJECT)
	cd $(BUILD_DIR) && quartus_fit --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)
	cd $(BUILD_DIR) && quartus_asm --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)
	cd $(BUILD_DIR) && quartus_eda --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)
#	Собрать проект полностью можно одной командой:
#	cd $(BUILD_DIR) && quartus_sh --flow compile $(PROJECT)

quartus_build: | $(BUILD_DIR)/output_files/$(PROJECT).sof
	@echo "Quartus project is builded"

quartus_rebuild: $(BUILD_DIR)/$(PROJECT).qpf
	rm -rf $(BUILD_DIR)/output_files/$(PROJECT).sof
	make quartus_build

$(BLD_QSYS_PRJ)/modelsim.ini: $(BUILD_DIR)/$(PROJECT).qpf
	cd $(BUILD_DIR) && quartus_map --read_settings_files=on --write_settings_files=off Wally_CS -c Wally_CS --analysis_and_elaboration
	cd $(BUILD_DIR) && quartus_sh -t "$(QUARTUS_ROOTDIR)/common/tcl/internal/nativelink/qnativesim.tcl" --rtl_sim --no_gui "$(PROJECT)" "$(PROJECT)"
# => Костыль, после добавления sram_model.sv в проект в qsim перестал автоматически добавлятся	testbench.sv
	cd $(BLD_QSYS_PRJ) && vlog -sv -work work ../../../fpga/src/testbench.sv
# ==
	cd $(BLD_QSYS_PRJ) && vopt work.testbench +acc -o _testbench -L $(PROJECT) -L altera_mf_ver

qsim_create: | qsys_generate quartus_create $(BLD_QSYS_PRJ)/modelsim.ini $(BLD_QSYS_PRJ)/rtl_work/@_testbench
	@echo "Questasim project is created"

qsim_open: | qsim_create
	@echo "Openning Questasim project in gui"
	cd $(BLD_QSYS_PRJ) && vsim work._testbench -do ../../../scripts/questa/set_def_waveforme.do &

qsim_clean:
	rm -rf $(BLD_QSYS_PRJ)

qsim_rebuild: qsim_clean qsim_create

quartus_program: quartus_build
	quartus_pgm -c USB-Blaster -m jtag -o "p;$(BUILD_DIR)/output_files/$(REVISION).sof"

sc_write_firmware:
	system-console --project_dir=./$(BUILD_DIR) --rc_script=scripts/system_console/sc_rc.tcl --script=scripts/system_console/write_firmware.tcl

sc_terminal:
	system-console --project_dir=./$(BUILD_DIR) --rc_script=scripts/system_console/sc_rc.tcl -cli

# ========================================
#	Zero Stage Boot Loader
# ========================================

zsbl/bin/boot.mif: zsbl/src/*
	@echo "Run docker and do make..."
	docker run --rm -v ./zsbl:/zsbl -w /zsbl -w /zsbl -it riscv-gnu-toolchain make

zsbl_build: | zsbl/bin/boot.mif
	@echo "boot.mif was generated"

# ========================================
#	Run docker riscv-gnu-toolchain enviroment
# ========================================
run_docker_gnu_toolchain:
	@if docker ps -q -f name=riscv-dev | grep -q .; then \
		echo "Stopping running container riscv-dev..."; \
		docker stop riscv-dev; \
	fi
	@if docker ps -aq -f name=riscv-dev | grep -q .; then \
		echo "Removing container riscv-dev..."; \
		docker rm riscv-dev; \
	fi
	docker run -v ./zsbl:/work/zsbl -v ./sdk:/work/sdk -w /work --name riscv-dev -it riscv-gnu-toolchain

# ========================================
#	Other
# ========================================
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