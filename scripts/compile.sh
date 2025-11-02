#!/usr/bin/env bash

scriptDir=$(dirname "$0")

sudo halcompile --install $scriptDir/../source/PoKeysController.comp
sudo halcompile --install $scriptDir/../source/PoKeysMotionBuffer.comp