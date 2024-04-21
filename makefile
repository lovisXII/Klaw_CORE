# Compilers
VERILATOR?=verilator
RISCV?=/opt/riscv/bin/riscv32-unknown-elf-gcc
SV2V?=bin/sv2v

# SRC RTL
SRC_DIR=src
SRC=$(wildcard src/*.sv)
ODIR= obj_dir
TEST?=sw/tests/I/add/add_0.S
TEST_R=riscof/riscof_work/rv32i_m/privilege/src/ebreak.S/dut/my.elf
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
LD_DIR=sw/ldscript/
RISC_FLAGS= -nostdlib -march=rv32izicsr

all: core_tb


#---------------------------------------
# Building & running simulation
#---------------------------------------
view:
	vsim -view logs/vlt_dump.wlf

run:core_tb
	spike -p1 -l --log=spike.log --priv=m --isa=rv32izicsr --log-commits a.out
	obj_dir/Vcore $(TEST) $(DEBUG)


run_risc:core_tb
	spike -p1 -l --log=spike.log --priv=m --isa=rv32izicsr --log-commits $(TEST_R)
	obj_dir/Vcore $(TEST_R) --riscof signature.txt

check: core_tb
	obj_dir/Vcore $(TEST) $(DEBUG)
	spike -p1 -l --log=spike.log --priv=m --isa=rv32izicsr --log-commits a.out
	python3 ./checker.py

core_tb: build_sw
	export SYSTEMC_INCLUDE=/usr/local/systemc-2.3.3/include/
	export SYSTEMC_LIBDIR=/usr/local/systemc-2.3.3/lib-linux64/
	$(VERILATOR) $(PKG) -CFLAGS "$(C_ARGS)" $(VERILATOR_FLAGS) $(SRC) --top-module $(TOP)  --exe $(TB)
	$(MAKE) -j -C obj_dir -f Vcore.mk

#---------------------------------------
# Building programm
#---------------------------------------

build_sw: build_dir kernel_obj user_obj
	$(RISCV) -nostdlib -march=rv32im -T $(LD_DIR)ldscript.ld obj_dir/reset.o obj_dir/exception.o obj_dir/exit.o $(TEST)
	rm -f a.out.txt.s
	/opt/riscv/bin/riscv32-unknown-elf-objdump -D a.out >> a.out.txt.s


kernel_obj: build_dir $(patsubst $(SW_DIR)/kernel/%.s,$(ODIR)/%.o,$(wildcard $(SW_DIR)/kernel/*.s))

user_obj  : build_dir $(patsubst $(SW_DIR)/user/%.s,$(ODIR)/%.o,$(wildcard $(SW_DIR)/user/*.s))

build_dir :
	mkdir -p $(ODIR)

# build kernel
$(ODIR)/%.o: $(SW_DIR)/kernel/%.s $(LD_DIR)/ldscript.ld
	$(RISCV) $(RISC_FLAGS) -T $(LD_DIR)/ldscript.ld $< -c -o $@

# build user
$(ODIR)/%.o: $(SW_DIR)/user/%.s $(LD_DIR)/ldscript.ld
	$(RISCV) $(RISC_FLAGS) -T $(LD_DIR)/ldscript.ld $< -c -o $@


#---------------------------------------
# Riscof
#---------------------------------------

riscof_build: core_tb
	cd riscof && ./lanch-riscof.sh build && cd ..
riscof_run: core_tb
	cd riscof && ./lanch-riscof.sh build run && cd ..

#---------------------------------------
# Implementation
#---------------------------------------

impl: sv2v
	$(MAKE) -C implementation/OpenLane/ mount
sv2v:
	mkdir -p $(IMPL_DIR)
	cp -rf implementation/designs/core/* $(IMPL_DIR)
	$(SV2V) --verbose -I --incidr=$(SRC_DIR) $(SRC) $(PKG) --write=adjacent --write=$(IMPL_DIR)src/

#---------------------------------------
# Cleaning
#---------------------------------------

clean:
	rm -rf obj_dir/ *.vcd *.out.txt.s \
	*.out kernel *.txt *.o *.log \
	$(ODIR)
	rm -rf implementation/OpenLane/designs/core/src/*.v

clean_gdsii:
	rm -rf implementation/OpenLane/designs/core/runs