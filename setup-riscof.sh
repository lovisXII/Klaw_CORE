#! /bin/bash
# This script allow you to setup the riscof test frimework
# You will need it if you really want to test our design, otherwise it will be
# useless for you to run this script

export TEMPORARY_PATH=$PWD/riscof/
################### PYTHON SETUP ###################

echo "[info] Installing python"

# Neeed to install python 3.6 for 22.04 otherwise it doesn't work
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
        echo "#######################################"
        echo "#######################################"
        echo "#######################################"
        echo "[info]  PLEASE BE PATIENT THIS OPERATION IS QUITE LONG"
        echo "#######################################"
        echo "#######################################"
        echo "#######################################"
        echo "#######################################"
        sudo apt-get install device-tree-compiler
        cd /tmp/ && git clone https://github.com/riscv-software-src/riscv-isa-sim.git
        cd riscv-isa-sim
        mkdir build
        cd build
        sudo ../configure --prefix=/opt/
        sudo make -j4
        sudo make install #sudo is required depending on the path chosen in the previous setup
        echo "export PATH=/opt/bin:\$PATH" >> ~/.bashrc
        source ~/.bashrc
else
    echo "#######################################"
    echo "#######################################"
    echo "#######################################"
    echo "#######################################"
    echo "[info] LUCKY YOU ! SPIKE IS ALREADY INSTALLED"
    echo "#######################################"
    echo "#######################################"
    echo "#######################################"
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