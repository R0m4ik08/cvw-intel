PROJECT = de2_project
REVISION = top
BUILD_DIR = build

QUARTUS_BIN := $(QUARTUS_ROOTDIR)\bin64

PATH +=;$(QUARTUS_BIN);

.PHONY: all build program clean

all: build

create:
	mkdir -p $(BUILD_DIR)
	quartus_sh -t scripts/create_project.tcl

build:
	quartus_sh --flow compile $(PROJECT)

program:
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