In progress
# What holds this git

This git will hold the description of an RV32I core designed using system verilog

# Setup

To setup all the dependencies you will need a couple of bash script. And of course you will need a linux distribution. The code have been runned under :
* Ubuntu 22.04
* WSL (Windows Subsytem for Linux)

To setup your environment please run :
```bash
./setup.sh
./riscof-setup.sh
```

After that you're suppose to be good to go. If not please raise an issue.

# How to launch the simulation

Makefile commands :
```make
make run          # run a default test
make core_tb      # compile the design
make riscof_build # build riscof framework and needed tests
make sv2v         # Translate all system verilog file into verilog
make synth        # Synthetise the RTL using yosys
```

To run the test you want :
```bash
make core_tb
obj_dir/Vcore test_name
```
By default the waves will be generated in ``logs/`` directory