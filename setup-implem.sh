#!/bin/bash
project_root=$PWD
cd implementation/
rm -rf OpenLane
git clone https://github.com/The-OpenROAD-Project/OpenLane
cd OpenLane
make
cd $project_root
