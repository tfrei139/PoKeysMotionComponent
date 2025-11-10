#!/usr/bin/env bash

scriptDir=$(dirname "$0")

mkdir -p ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill"
cp -u -v "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill/"* ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill"
