#! /usr/bin/python3.10
import os
import sys
import argparse
from subprocess import run, CalledProcessError, PIPE
from termcolor import colored

def run_subprocess(cmd, message):
    print(colored("[INFO]", "green"), message, ":\n", cmd)
    try:
        result = run(cmd, capture_output=True, text=True, shell=True)
        if result.stdout.strip():
            print(result.stdout)
        if result.stderr.strip():
            # Check if stderr contains warning messages
            if "warning" in result.stderr.lower():
                # Print warnings in yellow
                print(colored(result.stderr, "yellow"))
            else:
                # Print errors in red
                print(colored(result.stderr, "red"))
        # Check return code and exit if non-zero
        if result.returncode != 0:
            print(colored("Subprocess failed. Exiting...", "red"))
            sys.exit(1)  # Exit with a non-zero status to indicate failure
    except CalledProcessError as e:
        print(colored(f"Error: {e}", "red"))
        sys.exit(1)  # Exit with a non-zero status upon subprocess error

def compile_verilator() :
    verilator_path    = "verilator"
    pkg               = ["riscv_pkg.sv"]
    include_lib       = ["../include/ELFIO/"]
    cflags            = "-lsystemc -lm -g"
    verilog_flags     = "-sc -Wno-fatal -Wall --trace --pins-sc-uint"
    src_dir           = ["src"]
    top_module        = "core"
    tb                = "core_tb.cpp"
    src_files         = []
    # Extract files in source directories
    for dir in src_dir :
        with os.scandir(dir) as entries :
            for entry in entries :
                if entry.is_file() and entry.name.endswith("sv") :
                    src_files.append(os.path.join(dir, entry.name))

    verilator_cmd = f'{verilator_path} {" ".join(pkg)} -CFLAGS "-I{" ".join(include_lib)} {cflags}" {verilog_flags} {" ".join(src_files)} --top-module {top_module} --exe {tb}'
    env                       = os.environ.copy()
    env["SYSTEMC_INCLUDE"]    = "/usr/local/systemc-2.3.3/include/"
    env["SYSTEMC_LIBDIR"]     = "/usr/local/systemc-2.3.3/lib-linux64/"
    run_subprocess(verilator_cmd, "Compile RTL using verilator")


def compile_c():
    num_cores = os.cpu_count()
    os.chdir("obj_dir")
    make_cmd = f'make -j {str(num_cores)} -f Vcore.mk'
    run_subprocess(make_cmd, "Compile c++")
    os.chdir("..")

def compile_test(test) :
    riscv_gcc   = "/opt/riscv/bin/riscv32-unknown-elf-gcc"
    arch        = "-march=rv32izicsr"
    ld_dir      = "sw/ldscript"
    build_dir   = "obj_dir"
    # Build kernel
    kernel_dir      = ["sw/user", "sw/kernel"]
    kernel_files    = []
    # Extract files in source directories
    for dir in kernel_dir :
        with os.scandir(dir) as entries :
            for entry in entries :
                if entry.is_file() and entry.name.endswith("s") :
                    kernel_files.append([dir, entry.name])
    # Compile kernel files
    for dir, file in kernel_files :
        filename    = os.path.splitext(file)[0]
        cmd         = f'{riscv_gcc} -nostdlib {arch} -T {ld_dir}/ldscript.ld {dir}/{filename}.s -c -o {build_dir}/{filename}.o'
        run_subprocess(cmd, "Compile {}".format(file))
    # Build test file
    bin_cmd       = f'{riscv_gcc} -nostdlib {arch} -T {ld_dir}/ldscript.ld {build_dir}/reset.o {build_dir}/exception.o {build_dir}/exit.o {test}'
    run_subprocess(bin_cmd, "Build final binary")

def run_simu():
    cmd     = f'obj_dir/Vcore a.out'
    run_subprocess(cmd, "Run simulation")
# Riscof
def run_riscof(test):
    cmd     = f'obj_dir/Vcore test --riscof --signature signature.txt'
    run_subprocess(cmd, "Run simulation with --riscof enable")

def run_checker(test) :
    arch        = "-march=rv32izicsr"
    spike_cmd   = f"spike -p1 --log=spike.log --priv=m {arch} --log-commits {test}"
    checker_cmd = f"python3 ./checker.py"
    run_subprocess(spike_cmd, "Run spike")
    run_subprocess(checker_cmd, "Run checker")

def gtkwave() :
    cmd = "gtkwave logs/vlt_dump.vcd &"
    run_subprocess(cmd, "Running Gtkwave")

if __name__ == "__main__" :
    parser = argparse.ArgumentParser(description="Compile RTL core toolchain")
    parser.add_argument("--sim", action="store_true", help="Launch the simulation of the RTL")
    parser.add_argument("--test", help="File or directory that contains the test files to run")
    parser.add_argument("--riscof", action="store_true", help="Launch the riscof toolchain")
    parser.add_argument("--impl", action="store_true", help="Launch the implementation of using OpenLane")
    parser.add_argument("--clean", action="store_true", help="Clean all the generated files")
    args = parser.parse_args()
    if (args.sim or args.riscof) and not args.test:
        raise argparse.ArgumentTypeError("--test is required when --sim or --riscof is specified")

    if args.sim or args.riscof:
        compile_verilator()
        compile_c()
        compile_test(args.test)
        if args.sim :
            run_simu()
        if args.riscof :
            run_riscof(args.test)
    elif args.clean :
        cmd = "rm -rf obj_dir/ *.vcd *.out.txt.s *.out kernel *.txt *.o *.log obj_dir"
        run_subprocess(cmd, "Cleaning generated files...")
        cmd = "rm -rf implementation/OpenLane/designs/core/src/*.v"
        run_subprocess(cmd, "Cleaning implementation files...")

    # Compilers
    sv2v              = "bin/sv2v"
    # Src path
    src_dir           = "src"
    build_dir         = "obj_dir"
    impl_dir          = "implementation/OpenLane/designs/core/"
    test              = "sw/tests/I/add/add_0.S"
