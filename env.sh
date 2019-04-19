#!/bin/bash
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/extras/CUPTI/lib64:$LD_LIBRARY_PATH
CUR_PATH=`pwd`
export PYTHONPATH="$PYTHONPATH:$CUR_PATH"
