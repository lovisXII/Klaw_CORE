#!/bin/bash
cd implementation/
rm -rf OpenLane
git clone https://github.com/The-OpenROAD-Project/OpenLane
cd OpenLane
make
