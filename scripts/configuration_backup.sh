#!/usr/bin/env bash

scriptDir=$(dirname "$0")
mkdir -p ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill"

case $1 in
    "prod" | "PROD")
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/"* "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_PROD"
        ;;

    "test" | "TEST")
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/"* "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_TEST"
        ;;

    *)
        echo "Invalid argument $1, please pass PROD or TEST"
        ;;
esac




