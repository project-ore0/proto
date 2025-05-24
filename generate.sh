#!/bin/bash
# Simple wrapper script for make commands to generate Protocol Buffer files

# Exit on error
set -e

echo "Generating Protocol Buffer files..."
make clean && make all
echo "Generation complete!"
