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

cd $KLAW_ROOT
# Iterate through the arguments using a for loop
for arg in "$@"; do
  case "$arg" in
    "build")
      riscof validateyaml --config=config.ini
      riscof testlist --config=config.ini --suite=riscv-arch-test/riscv-test-suite/ --env=riscv-arch-test/riscv-test-suite/env
      ;;
    "run")
      riscof run --config=config.ini --suite=riscv-arch-test/riscv-test-suite/ --env=riscv-arch-test/riscv-test-suite/env
      ;;
    *)
      echo "Invalid argument: $arg"
      usage
      ;;
  esac
done
