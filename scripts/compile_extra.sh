#!/usr/bin/env bash

scriptDir=$(dirname "$0")

halcompile --preprocess $scriptDir/../source/template/PoKeysController.comp
