#!/usr/bin/env bash

scriptDir=$(dirname "$0")

sudo halcompile --install --userspace --extra-link-args="-L/usr/lib -lPoKeys" $scriptDir/../source/PoKeysController.c
sudo halcompile --install $scriptDir/../source/PoKeysMotionBuffer.comp
