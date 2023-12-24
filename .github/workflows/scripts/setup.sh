#!/bin/bash

setup_path=$PWD
riscv_sha1="261255c19c0092ae94500ac237660cadb1e615b9"
systemc_sha1="f861e02ba3a89cc000b62a21cecabaae910b7ef9"

sudo apt install build-essential make wget git gcc g++ automake verilator

echo "Installing riscv32 compiler"
# If the file is corrupted or not present we download it
rm -rf riscv32-unknown-elf.gcc-10.2.0.rv32i.ilp32.newlib.tar.gz
wget https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-131023/riscv32-unknown-elf.gcc-13.2.0.tar.gz
sudo mkdir -p /opt/riscv
sudo tar -xzf riscv32-unknown-elf.gcc-13.2.0.tar.gz -C /opt/riscv/
echo "[DEBUG] Checking /opt/riscv path"
ls -l /opt/riscv/bin
echo "[DEBUG] Removing riscv tar file"
rm -f riscv32-unknown-elf.gcc-13.2.0.tar.gz

# Installing systemC

if [ -f systemc-2.3.3.gz ] && [ "$(sha1sum systemc-2.3.3.gz | cut -d ' ' -f 1)" != "$systemc_sha1" ]; then
  rm -rf systemc-2.3.3.gz
  wget http://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.gz
elif ! [ -f systemc-2.3.3.gz ]; then
  wget http://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.gz
fi
sudo mv systemc-2.3.3.gz /usr/local/
cd /usr/local/
echo "Uncompressing the tar archive into current directory"
sudo tar -xzf systemc-2.3.3.gz
rm -rf systemc-2.3.3.gz
if [ ! -d /usr/local/systemc-2.3.3/ ]; then
    sudo mkdir -p /usr/local/systemc-2.3.3/
fi
cd systemc-2.3.3
sudo mkdir -p objdir && cd objdir
sudo  ../configure --prefix=/usr/local/systemc-2.3.3/
sudo make -j$(nproc)
sudo make install
