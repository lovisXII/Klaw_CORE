# Compilers
SV2V?=../bin/sv2v
SRC_DIR=../src
SRC=$(wildcard ../src/*.sv)
IMPL_DIR=OpenLane/designs/core/
PKG=../riscv_pkg.sv



all: impl
#---------------------------------------
# Implementation
#---------------------------------------

impl: sv2v
	$(MAKE) -C OpenLane/ mount
sv2v:
	@mkdir -p $(IMPL_DIR)
	@cp -rf designs/core/* $(IMPL_DIR)
	$(SV2V) --verbose -I --incidr=$(SRC_DIR) $(SRC) $(PKG) --write=adjacent --write=$(IMPL_DIR)src/

#---------------------------------------
# Cleaning
#---------------------------------------

clean:
	rm -rf OpenLane/designs/core/src/*.v

clean_gdsii:
	rm -rf OpenLane/designs/core/runs