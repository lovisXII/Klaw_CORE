#! /bin/bash

# Define a usage function to display how to use the script
usage() {
  echo "Usage: $0 [build|run]"
  exit 1
}

# Check if there is at least one argument
if [ $# -lt 1 ]; then
  usage
fi

if [ -z $KLAW_ROOT ]; then
  echo "[ERROR] KLAW_ROOT not found, please source setup.sh first"
  exit
fi

cd $KLAW_ROOT
# Iterate through the arguments using a for loop
for arg in "$@"; do
  case "$arg" in
    "build")
      riscof validateyaml --config=$KLAW_ROOT/riscof/config.ini
      riscof testlist --config=$KLAW_ROOT/riscof/config.ini --suite=$KLAW_ROOT/riscof/riscv-arch-test/riscv-test-suite/ --env=$KLAW_ROOT/riscof/riscv-arch-test/riscv-test-suite/env
      ;;
    "run")
      riscof run --config=$KLAW_ROOT/riscof/config.ini --suite=$KLAW_ROOT/riscof/riscv-arch-test/riscv-test-suite/ --env=$KLAW_ROOT/riscof/riscv-arch-test/riscv-test-suite/env
      ;;
    *)
      echo "Invalid argument: $arg"
      usage
      ;;
  esac
done
