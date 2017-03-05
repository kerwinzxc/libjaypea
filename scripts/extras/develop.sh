#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")/../../

echo "--------------------------------------------------"

wl="scripts/python/watcher.py cpp-source/,scripts/build-library.sh,scripts/build-prefix.sh scripts/build-library.sh $1"

echo $wl

xterm -geometry 100x5 \
-T "watcher building libjaypea.so" \
-e $wl &

echo "--------------------------------------------------"

wl="scripts/python/watcher.py cpp-source/examples/,artifacts/libjaypea.so,scripts/build-example.sh scripts/build-example.sh $1"

echo $wl

xterm -geometry 100x25 \
-T "watcher building examples" \
-e $wl &

echo "--------------------------------------------------"
