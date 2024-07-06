# Getting Started

## What holds this git
The purpose of this git is to allow you to use an open source and well documented RISCV core.
The core is a RV32IZicsr and has been designed using system verilog.
For the verification we used the [riscof framework](https://github.com/riscv-software-src/riscof/).
You can run any rv32i bare-metal programm written in assembly of C on the core.

## Installation

To setup all the dependencies you will need a couple of bash script. And of course you will need a linux distribution. The code have been runned under the following distribution :
* Ubuntu 22.04
* WSL2 (Windows Subsytem for Linux)
It should work on other Unix distributions but some modification may be needed on the scripts.\
To setup your environment please run :
```bash
./install.sh -i 1,2,3,4,5
source ~/.bashrc
```
The -i flag allow you to specify what you want to install. By default we recommand to install everything :
* Riscv cross compiler
* SystemC
* ModelSim
* Riscof
* OpenLane
After that you're suppose to be good to go. If not please raise an issue.

# How to launch the simulation

Before running the simulation you need to source **setup.sh**, it allow to export the correct variables for systemC and it create **KLAW_ROOT** which is needed to run riscof.\
A python wrapper is used to build and run the simulation, here's a quick explanation of the commands you can run :
* --sim : Allow to run the simulation, if **--build** is specified it will compile the RTL and generate **obj_dir/Vcore**
* --test TEST : specify the test to run, accept **.s**, **.c** and **.elf** files. If a .s or .c file is given it will be compiled by the wrapper
* --riscof : Allow to run a riscof file, it only accept **.elf** files
* --riscof-reg : Allow to run all the tests from riscof

## Single test

If you want to run the test bench by hand here are the needed steps :
```bash
source setup.sh
./run.py --sim --build --test path/test_name
```

Running the above command will run the simulation and generate a wave file ``logs/vlt_dump.vcd`` that can be visualise using gtkwave

## Multi tests using Riscof


[Riscof](https://github.com/riscv-software-src/riscof) is an open source framework that allow to test your design. It is splitted in one test per instruction that allow to detect most type of error.\
Our design has a ``100% pass`` rate on the **RV32I** tests.\
In the past we encountered error while running C programms even with a 100% pass rate on riscof so the framework is not perfect.\
This is why we also run some custom C programm that allow us to test more deeply the design.\
If you encounter any issue while executing a programm and that you triple check your programm should work properly please reach out.\
If you want to manually run a riscof test file you can run the following command :

```bash
   ./run.py --riscof --build --test path/test_name
```

This will run the riscof elf file and generate a signature file name `signature.txt`.
To verify the test ran successfully, riscof compared the generated file `signature.txt` with the one in `riscof/riscof_work/rv32i/I/src/test_name/ref/Reference-spike.signature`
