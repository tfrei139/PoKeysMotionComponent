#!/usr/bin/env bash

scriptDir=$(dirname "$0")
mkdir -p ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill"

case $1 in
    "prod" | "PROD")
        cp -v "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_PROD/"* ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill"
        ;;

    "test" | "TEST")
        cp -v "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_TEST/"* ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill"
        ;;

    *)
        echo "Invalid argument $1, please pass PROD or TEST"
        ;;
esac




