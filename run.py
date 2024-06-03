#! /usr/bin/python3.10
import os
import sys
import argparse
from subprocess import run, CalledProcessError, PIPE
from termcolor import colored
import checker

def run_subprocess(cmd, message, env = None):
    print(colored("[INFO]", "green"), message, ":\n", cmd)
    try:
        result = run(cmd, capture_output=True, text=True, shell=True, env=env)
        if result.stdout.strip():
            print(result.stdout)
        if result.stderr.strip():
            if "warning" in result.stderr.lower():
                print(colored(result.stderr, "yellow"))
            else:
                print(colored(result.stderr, "red"))
        if result.returncode != 0:
            print(colored("Subprocess failed. Exiting...", "red"))
            sys.exit(1)
    except CalledProcessError as e:
        print(colored(f"Error: {e}", "red"))
        sys.exit(1)

class Config:
    def __init__(self):
        parser = argparse.ArgumentParser(description="Compile RTL core toolchain")
        parser.add_argument("--sim"       , action="store_true", help="Launch the simulation of the RTL")
        parser.add_argument("--build"     , action="store_true", help="Build the the RTL")
        parser.add_argument("--test"                           , help="File or directory that contains the test files to run")
        parser.add_argument("--riscof-reg", action="store_true", help="Launch the toolchain riscof")
        parser.add_argument("--riscof"    , action="store_true", help="Launch the riscof toolchain")
        parser.add_argument("--impl"      , action="store_true", help="Launch the implementation of using OpenLane")
        parser.add_argument("--clean"     , action="store_true", help="Clean all the generated files")

        args = parser.parse_args()

        if (args.sim or args.riscof) and not args.test:
            raise argparse.ArgumentTypeError("--test is required when --sim or --riscof is specified")

        if args.sim and args.riscof and not args.test and not args.run_reg:
            raise argparse.ArgumentTypeError("--sim, --riscof and --riscof-reg are exclusive")

        self.args = args
        self.arch = "rv32izicsr"

    def compile_verilator(self):
        verilator_path    = "verilator"
        pkg               = ["riscv_pkg.sv"]
        include_lib       = ["../include/ELFIO/"]
        cflags            = "-lsystemc -lm -g"
        verilog_flags     = "-sc -Wno-fatal -Wall --trace --pins-sc-uint"
        src_dir           = ["src"]
        top_module        = "core"
        tb                = "core_tb.cpp"
        src_files         = []
        for dir in src_dir:
            with os.scandir(dir) as entries:
                for entry in entries:
                    if entry.is_file() and entry.name.endswith("sv"):
                        src_files.append(os.path.join(dir, entry.name))

        verilator_cmd             = f'{verilator_path} {" ".join(pkg)} -CFLAGS "-I{" ".join(include_lib)} {cflags}" {verilog_flags} {" ".join(src_files)} --top-module {top_module} --exe {tb}'
        env                       = os.environ.copy()
        env["SYSTEMC_INCLUDE"]    = "/usr/local/systemc-2.3.3/include/"
        env["SYSTEMC_LIBDIR"]     = "/usr/local/systemc-2.3.3/lib-linux64/"
        run_subprocess(verilator_cmd, "Compile RTL using verilator", env)

    def compile_c(self):
        num_cores   = os.cpu_count()
        make_cmd    = f'make -j {str(num_cores)} -C obj_dir -f Vcore.mk'
        run_subprocess(make_cmd, "Compile c++")

    def compile_test(self):
        riscv_gcc   = "/opt/riscv/bin/riscv32-unknown-elf-gcc"
        arch        = f"-march={self.arch}"
        ld_dir      = "sw/ldscript"
        build_dir   = "obj_dir"
        # Build kernel
        kernel_dir    = ["sw/user", "sw/kernel"]
        kernel_files  = []
        # Extract files in source directories
        for dir in kernel_dir:
            with os.scandir(dir) as entries:
                for entry in entries:
                    if entry.is_file() and entry.name.endswith("s"):
                        kernel_files.append([dir, entry.name])
        # Compile kernel files
        for dir, file in kernel_files:
            filename    = os.path.splitext(file)[0]
            cmd         = f'{riscv_gcc} -nostdlib {arch} -T {ld_dir}/ldscript.ld {dir}/{filename}.s -c -o {build_dir}/{filename}.o'
            run_subprocess(cmd, "Compile {}".format(file))
        # Build test file
        bin_cmd = f'{riscv_gcc} -nostdlib {arch} -T {ld_dir}/ldscript.ld {build_dir}/reset.o {build_dir}/exception.o {build_dir}/exit.o {config.args.test}'
        run_subprocess(bin_cmd, "Build final binary")

    def run_simu(self):
        cmd = f'obj_dir/Vcore a.out'
        run_subprocess(cmd, "Run simulation")

    # Riscof
    def run_riscof(self):
        cmd = f'obj_dir/Vcore {config.args.test} --riscof signature.txt'
        run_subprocess(cmd, "Run simulation with --riscof enable")

    def run_checker(self):
        arch        = "--isa=rv32izicsr"
        if self.args.sim :
            testname =  "a.out"
        elif self.args.riscof :
             testname = config.args.test
        spike_cmd   = f"spike -p1 --log=spike.log --priv=m {arch} --log-commits {testname}"
        run_subprocess(spike_cmd, "Run spike")
        checker.run_checker()

    def gtkwave(self):
        cmd = f"gtkwave {config.waves_dir}/vlt_dump.vcd &"
        run_subprocess(cmd, "Running Gtkwave")

    def build_reg(self) :
        cmd = "./riscof/lanch-riscof.sh build"
        run_subprocess(cmd, "Building riscof")

    def run_reg(self) :
        cmd = "./riscof/lanch-riscof.sh run"
        run_subprocess(cmd, "Running riscof")

if __name__ == "__main__":

    config = Config()

    # Check build argument
    if config.args.build and config.args.sim :
        config.compile_verilator()
        config.compile_c()
        config.compile_test()
    elif config.args.build and config.args.riscof :
        config.compile_verilator()
        config.compile_c()
    elif config.args.build and config.args.riscof_reg :
        config.build_reg()

    # Run simulation
    if config.args.sim:
        config.run_simu()
        config.run_checker()
    elif config.args.riscof:
        config.run_riscof()
        config.run_checker()
    elif config.args.riscof_reg :
        config.run_reg()
    elif config.args.clean:
        cmd = "rm -rf obj_dir/ *.vcd *.out.txt.s *.out kernel *.txt *.o *.log obj_dir"
        run_subprocess(cmd, "Cleaning generated files...")
        cmd = "rm -rf implementation/OpenLane/designs/core/src/*.v"
        run_subprocess(cmd, "Cleaning implementation files...")
