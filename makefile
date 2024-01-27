# Compilers
VERILATOR?=verilator
RISC?=/opt/riscv/bin/riscv32-unknown-elf-gcc
SV2V?=bin/sv2v

# SRC RTL
SRC_DIR=src
SRC=$(wildcard src/*.sv)
ODIR= obj_dir
TEST?=sw/tests/I/add/add_0.S
DEBUG?=

# Implementation
IMPL_DIR=implementation/OpenLane/designs/core/

# VERILATOR
VERILATOR_FLAGS=-sc -Wno-fatal -Wall --trace --pins-sc-uint
TB=core_tb.cpp
PKG=riscv_pkg.sv
TOP=core


# G++
INCLUDE_PATH= -I../include/ELFIO/
LIBS=-lsystemc -lm
C_ARGS=$(INCLUDE_PATH) -Wl, $(LIBS) -g

# RISCV
SW_DIR=sw
LD_DIR=sw/ldscript
RISC_FLAGS= -nostdlib -march=rv32izicsr

all: core_tb

# Simulation
run:core_tb
	obj_dir/Vcore $(TEST) $(DEBUG)

core_tb: build_sw
	export SYSTEMC_INCLUDE=/usr/local/systemc-2.3.3/include/
	export SYSTEMC_LIBDIR=/usr/local/systemc-2.3.3/lib-linux64/
	$(VERILATOR) $(PKG) -CFLAGS "$(C_ARGS)" $(VERILATOR_FLAGS) $(SRC) --top-module $(TOP)  --exe $(TB)
	$(MAKE) -j -C obj_dir -f Vcore.mk

# Building binary needed by simulation

build_sw : build_dir kernel_obj user_obj

build_dir :
	mkdir -p $(ODIR)

kernel_obj: build_dir $(patsubst $(SW_DIR)/kernel/%.s,$(ODIR)/%.o,$(wildcard $(SW_DIR)/kernel/*.s))

user_obj  : build_dir $(patsubst $(SW_DIR)/user/%.s,$(ODIR)/%.o,$(wildcard $(SW_DIR)/user/*.s))

# build kernel
$(ODIR)/%.o: $(SW_DIR)/kernel/%.s $(LD_DIR)/kernel.ld
	$(RISC) $(RISC_FLAGS) -T $(LD_DIR)/kernel.ld $< -c -o $@

# build user
$(ODIR)/%.o: $(SW_DIR)/user/%.s $(LD_DIR)/app.ld
	$(RISC) $(RISC_FLAGS) -T $(LD_DIR)/app.ld $< -c -o $@


riscof_build: core_tb
	cd riscof && ./lanch-riscof.sh build && cd ..
riscof_run: core_tb
	cd riscof && ./lanch-riscof.sh build run && cd ..
# Checker
spike:
	spike -p1 -g -l --log=spike.log --isa=rv32i --log-commits a.out
# Implementation
impl: sv2v
	$(MAKE) -C implementation/OpenLane/ mount
sv2v:
	mkdir -p $(IMPL_DIR)
	cp -rf implementation/designs/core/* $(IMPL_DIR)/
	$(SV2V) --verbose -I --incidr=$(SRC_DIR) $(SRC) $(PKG) --write=adjacent --write=$(IMPL_DIR)/src/

clean:
	rm -rf obj_dir/ *.vcd *.out.txt.s \
	*.out kernel *.txt *.o *.log \
	$(ODIR)
	rm -rf implementation/OpenLane/designs/core/src/*.v

clean_gdsii:
	rm -rf implementation/OpenLane/designs/core/runs