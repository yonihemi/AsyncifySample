#!/bin/bash

set -e

echo "**** Building ..."
swift build -c release --product AsyncifySample --triple wasm32-unknown-wasi

echo "**** Asyncifying ..."
wasm-opt .build/wasm32-unknown-wasi/release/AsyncifySample.wasm --asyncify -O -o dist/main.wasm
