# Compilers

VERILATOR=verilator
RISC=riscv32-unknown-elf-gcc 

# SV GENERATOR

FILES=$(wildcard src/*.sv)
SV_GENERATOR=sv_generator
DIR=build

# VERILATOR 

VERILATOR_FLAGS=-sc -Wno-fatal --trace
TB=core_tb.cpp
PKG=riscv_pkg.sv
SRC=$(shell find . -type f -name '*.sv' | grep -v 'riscv_pkg.sv')
TOP=core


# G++

INCLUDE_PATH= -I../../ELFIO
LIBS=-lsystemc -lm
C_ARGS=$(INCLUDE_PATH) -Wl, $(LIBS) -g 

# RISCV

SW_DIR=../sw/
LD_SCRIPT= -T $(SW_DIR)/kernel.ld
RISC_FLAGS= -nostdlib $(LD_SCRIPT)

all: core_tb

verilog:
	$(SV_GENERATOR)/sv_gen.py --dir $(DIR) $(FILES)
core_tb: kernel
	export SYSTEMC_INCLUDE=/usr/local/systemc-2.3.3/include/
	export SYSTEMC_LIBDIR=/usr/local/systemc-2.3.3/lib-linux64/
	$(VERILATOR) -CFLAGS "$(C_ARGS)" $(VERILATOR_FLAGS) $(SRC) --top-module $(TOP)  --exe $(TB)
	$(MAKE) -j -C obj_dir -f Vcore.mk
syntax:
	$(VERILATOR) $(PKG) $(VERILATOR_FLAGS) $(SRC)
kernel:$(SW_DIR)/exception.s $(SW_DIR)/reset.s
	$(RISC) $(RISC_FLAGS) $^ -o $@

clean:
	rm -rf obj_dir/ *.vcd *.out.txt.s *.out kernel *.txt build/