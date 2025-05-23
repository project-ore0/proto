#!/bin/bash
set -e

apt-get update && apt-get install -y protobuf-compiler cmake git python3-pip

# Install nanopb generator
if [ ! -d "/workspace/nanopb" ]; then
    git clone --depth 1 https://github.com/nanopb/nanopb.git /workspace/nanopb
    (cd /workspace/nanopb/generator && python3 setup.py install)
fi

# Install TypeScript generator
npm install -g protoc-gen-ts