# What holds this git

The purpose of this git is to allow you to use an open source and well documented RISCV core.
The core is a RV32I and has been designed using system verilog. For the verification we used the [riscof framework](https://github.com/riscv-software-src/riscof).\
You can run any rv32i bare-metal programm written in assembly of C on the core.

# Setup

To setup all the dependencies you will need a couple of bash script. And of course you will need a linux distribution. The code have been runned under the following distribution :
* Ubuntu 22.04
* WSL (Windows Subsytem for Linux)

It should work on other Unix distribution but some modification may be needed on the scripts.\
To setup your environment please run :
```bash
./setup.sh
./setup-riscof.sh
```

After that you're suppose to be good to go. If not please raise an issue.

# How to launch the simulation
## Makefile commands
A makefile is used to build and run the simulation, here's a quick explanation of the commands you can run
```make
make run # run a default test
make run TEST=path/test_name # run the custom test given in argument
make core_tb      # compile the design
make riscof_build # build riscof framework and needed tests
make riscof_run   # run riscof framework
make sv2v         # Translate all system verilog file into verilog
make synth        # Synthetise the RTL using yosys
```
## Single test
If you want to run the test bench by hand here are the needed steps :
```make
make core_tb # this will build the obj_dir/ directory
obj_dir/Vcore path/test_name
```

Running the above command will run the simulation and generate a wave file ``logs/vlt_dump.vcd`` that can be visualise using gtkwave

## Riscof

Riscof is an open source framework that allow to test your design. It is splitted in one test per instruction that allow to detect most type of error.\
Our design has a ``100% pass`` rate on the rv32i tests.\
In the past we encountered error while running C files even with a 100% pass rate on riscof so the framework is not perfect. That is why we also run some custom C programm that allow us to test more deeply the design.\
Every test we run pass successfully so please reach out if you encounter any issue.
If you want to manually run a riscof test file you can run the following command :
```make
make core_tb
obj_dir/Vcore riscof/riscof_work/rv32i/I/src/test_name/dut/my.elf --riscof signature.txt
```
This will run the elf file in the test directory and generate a signature file name ``signature.txt``.\
 To verify the test ran successfully, riscof compared the generated file ``signature.txt`` with the one in ``riscof/riscof_work/rv32i/I/src/test_name/ref/Reference-spike.signature ``

# Design

![](doc/img/pipeline.png)

This core is a scalar in order pipeline containing 3 stages which are :

- **Ifetch** : Generates the PC (Program Counter) and fetch the next instruction from the I$.
- **Decod** : Decodes the instruction and will get if needed the source registers from register file and generate the control signals for the execute stage. And thus select the right unit which will execute the instruction.
- **Execute** : Contains multiple units to execute instructions and write if needed the destination register.
    * ALU : Arithmetic and logic computation (ADD, AND, OR, XOR, SLT).
    * Shifter : Logics and arihmetic shifts (shift logical right or left and shift arithmetic right)
    * BU : Branch Unit, which computes the branches and jumps instructions.
    * LSU : Load Store Unit, which handles all memory accesses by the D$.

# Verification

## Custom programms

Our test-bench is abled to run any type of rv32i assembly, c or elf files. But you need to ensure some things to be sure the programm with run successfully.\
Any files must start with the following lines of code :
```s
.section .text
.global _start

_start :
you code here
```
And and the end of the program you need to jump to ``_good`` if the programm ran successfully or jump to ``_bad`` if it didn't. Here's a quick example :
```s
.section .text
.global _start

_start :
       li x17, 1383
       li x1, 966
       add x29, x17, x1
       li x23, 2349
       bne x29, x23, _bad
       j _good
```
The previus program is performing an addition and if the result is correct it jumps to _good otherwise to _bad.
For C files it is quite the same things, you need to call the __asm__ macro :
```c
extern void _bad();
extern void _good();

__asm__(".section .text") ;
__asm__(".global _start") ;

__asm__("_start:");
__asm__("addi x1,x1, 4");
__asm__("sub x2, x2,x1 "); // Initialise the stack
__asm__("jal x5, main");
int main() {
    // Your code here
    (success) ? good() : bad(); //jump either to good or bad depending on the success
}
```
You may not call the ``_good`` or ``_bad`` label, but if you do not when you program will arrive to the end it will juste execute nothing and after a maximum numbers of cycle the program will be terminated by the test-bench.

# Implementation

In progress