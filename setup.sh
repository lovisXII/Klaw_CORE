#!/bin/bash

setup_path=$PWD
riscv_sha1="261255c19c0092ae94500ac237660cadb1e615b9"
systemc_sha1="f861e02ba3a89cc000b62a21cecabaae910b7ef9"

sudo apt install build-essential make wget git gcc g++ automake gtkwave

# Installing riscv cross-compiler
if ! command -v riscv32-unknown-elf-gcc &> /dev/null; then
    echo "riscv32-unknown-elf-gcc not installed"
    echo "Installing now....."
    # If the file is corrupted or not present we download it
    if [ -f "riscv32-unknown-elf.gcc-13.2.0.tar.gz" ] && [ "$(sha1sum riscv32-unknown-elf.gcc-13.2.0.tar.gz | cut -d ' ' -f 1)" != "$riscv_sha1" ]; then
        rm -rf riscv32-unknown-elf.gcc-10.2.0.rv32i.ilp32.newlib.tar.gz
        wget https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-131023/riscv32-unknown-elf.gcc-13.2.0.tar.gz
    elif ! [ -f "riscv32-unknown-elf.gcc-13.2.0.tar.gz" ]; then
        wget https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-131023/riscv32-unknown-elf.gcc-13.2.0.tar.gz
    fi
    sudo mkdir -p /opt/riscv
    sudo tar -xzf riscv32-unknown-elf.gcc-13.2.0.tar.gz -C /opt/riscv/
    echo "export PATH=\$PATH:/opt/riscv/bin" >> ~/.bashrc
    source ~/.bashrc
    rm -f riscv32-unknown-elf.gcc-13.2.0.tar.gz
else
    echo "riscv32-unknown-elf-gcc already installed"
fi

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
