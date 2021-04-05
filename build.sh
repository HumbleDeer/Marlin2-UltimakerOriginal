#!/bin/bash

set -e

# Run this to install pio cli
#
#   sudo python3 -m pip install -U platformio

python3 -m platformio project init
python3 -m platformio run

mkdir -p umo-binary
cp .pio/build/mega2560/firmware.hex umo-binary/Marlin2-UMO_`date -u +%Y%m%d`.hex
