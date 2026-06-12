#######################################################################
# ZSBL Makefile - wrapper: build via SDK
#
# Usage (from zsbl dir):  make [clean]
# From repo root:         make -C zsbl
#
# Output: build/boot.mif
#######################################################################

.PHONY: all clean

all: build/boot.mif


SRCS := $(wildcard src/*.c) \
        $(wildcard src/*.S) \
        $(wildcard src/*.s)

build/boot.mif: $(SRCS)
	@mkdir -p build
	$(MAKE) -C ../sdk PROJECT=../zsbl
	@echo ""
	@echo "=== ZSBL Build Complete ==="
	@echo "Output: build/boot.mif"
	@echo ""

clean:
	rm -rf build
