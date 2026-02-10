# ZSBL project config for SDK build
# Included by sdk/Makefile when PROJECT=../zsbl (build from zsbl dir) or PROJECT=zsbl (build from repo root)

LINKER_SCRIPT := $(SDK_ROOT)/$(PROJECT)/src/linker1000.x
COMMON_SRCS   :=
TARGET_NAME   := boot
