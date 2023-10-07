# Compilers
VERILATOR=verilator
RISC=riscv32-unknown-elf-gcc
SV2V=bin/sv2v

# SRC RTL
SRC=$(wildcard src/*.sv)
ODIR = obj_dir
TEST=sw/tests/I/add/add_0.S
DEBUG?=

# Implementation
SYNTH=yosys
SRC_V=synth/
YO_SCRIPT=$(SRC_V)scripts/synth.ys

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
LD_SCRIPT= -T $(SW_DIR)/kernel.ld
RISC_FLAGS= -nostdlib -march=rv32izicsr $(LD_SCRIPT)

all: core_tb

run:core_tb
	obj_dir/Vcore $(TEST) $(DEBUG)

core_tb: $(ODIR)/exception.o $(ODIR)/reset.o
	export SYSTEMC_INCLUDE=/usr/local/systemc-2.3.3/include/
	export SYSTEMC_LIBDIR=/usr/local/systemc-2.3.3/lib-linux64/
	$(VERILATOR) $(PKG) -CFLAGS "$(C_ARGS)" $(VERILATOR_FLAGS) $(SRC) --top-module $(TOP)  --exe $(TB)
	$(MAKE) -j -C obj_dir -f Vcore.mk

$(ODIR)/%.o:$(SW_DIR)/%.s
	mkdir -p $(ODIR)
	$(RISC) $(RISC_FLAGS) $< -c -o $@

riscof_build: core_tb
	cd riscof && ./lanch-riscof.sh build && cd ..
riscof_run: core_tb
	cd riscof && ./lanch-riscof.sh build run && cd ..
sv2v:
	$(SV2V) --verbose -I --incidr=$(SRC) $(PKG) --write=adjacent --write=$(SRC_V)

synth: sv2v
	$(SYNTH) -qv3 -l synth.log $(YO_SCRIPT)

clean:
	rm -rf obj_dir/ *.vcd *.out.txt.s \
	*.out kernel *.txt *.o *.log \
	$(ODIR)
	rm -f synth/*.v
