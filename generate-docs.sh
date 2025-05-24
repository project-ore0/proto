#!/bin/bash
# Script to generate PNG images from PlantUML diagrams

# Exit on error
set -e

# Check if PlantUML is installed
if ! command -v plantuml &> /dev/null; then
    echo "Error: PlantUML is not installed or not in PATH"
    echo "Please install PlantUML: https://plantuml.com/starting"
    exit 1
fi

echo "Generating documentation images from PlantUML diagrams..."

# Create output directory
mkdir -p doc/images

# Generate PNG images from all PlantUML files
for puml_file in doc/*.puml; do
    if [ -f "$puml_file" ]; then
        base_name=$(basename "$puml_file" .puml)
        echo "Converting $puml_file to PNG..."
        plantuml -tpng -o images "$puml_file"
    fi
done

echo "Documentation generation complete!"
echo "Images are available in doc/images/"
