#!/usr/bin/env bash

scriptDir=$(dirname "$0")

if [ ! -d ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill" ]; then
    echo "Configuration does not exist"
    exit 1
fi

case $1 in
    "prod" | "PROD")
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/Pokeys57CNC_XYZ_mill.hal" "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_PROD"
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/Pokeys57CNC_XYZ_mill.ini" "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_PROD"
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/shutdown.hal" "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_PROD"
        ;;

    "test" | "TEST")
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/Pokeys57CNC_XYZ_mill.hal" "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_TEST"
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/Pokeys57CNC_XYZ_mill.ini" "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_TEST"
        cp -v ~/"linuxcnc/configs/PoKeys57CNC.XYZ_mill/shutdown.hal" "$scriptDir/../configuration/PoKeys57CNC.XYZ_mill_TEST"
        ;;

    *)
        echo "Invalid argument $1, please pass PROD or TEST"
        ;;
esac




