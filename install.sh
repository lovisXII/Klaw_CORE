#!/bin/bash

project_root=$PWD
riscv_sha1="261255c19c0092ae94500ac237660cadb1e615b9"
systemc_sha1="f861e02ba3a89cc000b62a21cecabaae910b7ef9"
modelsim_sha1="c50f51479de963f4e79a8115dc9200e744b3ab3d"

function display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help         Display this help message"
    echo "  -i, --install      Install specified components (enter numbers separated by commas)"
    echo "                     1. RISC-V Compiler"
    echo "                     2. SystemC"
    echo "                     3. ModelSim"
    echo "                     4. Riscof"
    echo "                     5. OpenLane"
    echo "  -q, --quit         Quit the installation script"
    exit 0
}

function install_dependencies(){
    sudo apt update
    sudo apt install build-essential make wget git gcc g++ automake gtkwave verilator
    pip install pyyaml python3-sphinx
}

# Installing riscv cross-compiler
function install_riscv_compiler() {
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
        rm -f riscv32-unknown-elf.gcc-13.2.0.tar.gz
    else
        echo "riscv32-unknown-elf-gcc already installed"
    fi
}

# Installing systemC
function install_systemc() {
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
}

# Installing ModelSim
function install_modelsim() {
    cd $HOME
    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32ncurses6 libxft2 libxft2:i386 libxext6 libxext6:i386
    if [ -f ModelSimSetup-20.1.1.720-linux.run ] && [ "$(sha1sum ModelSimSetup-20.1.1.720-linux.run | cut -d ' ' -f 1)" != "$modelsim_sha1" ]; then
        rm -rf ModelSimSetup-20.1.1.720-linux.run
        wget https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/ModelSimSetup-20.1.1.720-linux.run
    elif ! [ -f ModelSimSetup-20.1.1.720-linux.run ]; then
        wget https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/ModelSimSetup-20.1.1.720-linux.run
    fi
    chmod +x ModelSimSetup-20.1.1.720-linux.run
    ./ModelSimSetup-20.1.1.720-linux.run --installdir $HOME --mode text
    echo "export PATH=\$PATH:$HOME/modelsim_ase/bin" >> ~/.bashrc
    rm ModelSimSetup-20.1.1.720-linux.run
}

function install_riscof() {
    # Neeed to install python 3.6 for 22.04 otherwise it doesn't work
    cd $project_root
    export TEMPORARY_PATH=$project_root/riscof/
    ################### PYTHON SETUP ###################
    echo "[info] Installing python"
    if ! command -v riscof &> /dev/null; then
        if [ "$(lsb_release -d | awk '{print $2}')" == "22.04" ]; then
            sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
            libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
            libgdbm-dev libnss3-dev libedit-dev libc6-dev
            wget https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz
            tar -xzf Python-3.6.15.tgz
            rm Python-3.6.15.tgz
            cd Python-3.6.15
            ./configure --enable-optimizations  -with-lto  --with-pydebug
            sudo make -j altinstall
            sudo python3.6 -m pip install git+https://github.com/riscv/riscof.git
            sudo rm -rf Python-3.6.15
        fi
    fi
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt-get update
    sudo apt-get install python3.6 -y
    sudo apt install python3-pip
    sudo pip3 install --upgrade pip
    ################### RISCOF SETUP ###################
    if ! command -v riscof &> /dev/null; then
        echo "[info] Installing riscof"
        sudo pip3 install git+https://github.com/riscv/riscof.git
    fi
    ################### SPIKE SETUP ###################
    if ! command -v spike &> /dev/null; then
            echo "[info] Unlucky you, spike isn't installed : Installing spike"
            echo "#######################################"
            echo "[info]  PLEASE BE PATIENT THIS OPERATION IS QUITE LONG"
            echo "#######################################"
            sudo apt-get install device-tree-compiler
            cd /tmp/ && git clone https://github.com/riscv-software-src/riscv-isa-sim.git
            cd riscv-isa-sim
            mkdir build
            cd build
            sudo ../configure --prefix=/opt/
            sudo make -j4
            sudo make install #sudo is required depending on the path chosen in the previous setup
            echo "export PATH=\$PATH:/opt/bin" >> ~/.bashrc
    else
        echo "#######################################"
        echo "[info] LUCKY YOU ! SPIKE IS ALREADY INSTALLED"
        echo "#######################################"
    fi
    ################### CONFIG SETUP ###################
    cd $TEMPORARY_PATH
    riscof setup --dutname=spike
    rm -f config.ini
    echo "
    [RISCOF]
    ReferencePlugin=spike
    ReferencePluginPath=$PWD/spike
    DUTPlugin=projet
    DUTPluginPath=$PWD/projet
    jobs=$(nproc)
    [spike]
    pluginpath=$PWD/spike
    ispec=$PWD/spike/spike_isa.yaml
    pspec=$PWD/spike/spike_platform.yaml
    target_run=1
    jobs=$(nproc)
    [sail_cSim]
    pluginpath=$PWD/sail_cSim
    jobs=$(nproc)
    [projet]
    pluginpath=$PWD/projet
    ispec=$PWD/projet/projet_isa.yaml
    pspec=$PWD/projet/projet_platform.yaml
    PATH=$PWD/../obj_dir/Vcore
    jobs=$(nproc)">>config.ini
    cd $TEMPORARY_PATH
    riscof --verbose info arch-test --clone
}

function install_openlane(){
    cd $project_root
    cd implementation/
    sudo rm -rf OpenLane
    git clone https://github.com/The-OpenROAD-Project/OpenLane
    cd OpenLane
    sudo make
}

function install_openlane2(){
    cd $project_root
    cd implementation/
    sudo rm -rf OpenLane2
    git clone https://github.com/efabless/openlane2 OpenLane2
    cd OpenLane
    sudo make
}
# Menu
# If no options are provided, display the help and exit
if [[ $# -eq 0 ]]; then
    echo "No options provided"
    display_help
    exit 1
fi
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            display_help
            ;;
        -i|--install)
            shift
            choices=$1
            IFS=',' read -ra choice_array <<< "$choices"
            install_dependencies
            for choice in "${choice_array[@]}"; do
                case $choice in
                    1)
                        install_riscv_compiler
                        ;;
                    2)
                        install_systemc
                        ;;
                    3)
                        install_modelsim
                        ;;
                    4)
                        install_riscof
                        ;;
                    5)
                        install_openlane
                        ;;
                    *)
                        echo "Invalid choice: $choice. Ignoring invalid choice."
                        ;;
                esac
            done
            ;;
        *)
            echo "Invalid option: $1"
            display_help
            exit 1
            ;;
    esac
    shift
done

cd $project_root







