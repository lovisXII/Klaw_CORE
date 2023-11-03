#!/bin/bash

sudo apt-get install build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev
sudo apt install python3
sudo apt install m4 tcsh tcl-dev tk-dev

git clone git@github.com:YosysHQ/yosys.git
cd yosys
make
sudo make install

git clone git@github.com:RTimothyEdwards/open_pdks.git
# Installing magic
git clone https://github.com/RTimothyEdwards/magic
cd magic
./configure
make
sudo make install
cd ..
# Configuring librairies
./configure --enable-sky130-pdk
make
sudo make install