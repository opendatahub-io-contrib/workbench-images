#!/bin/bash

set -a

source helper-functions

BASE_FOLDER=${1:-$(pwd)}

# Build all images in the recipes folder
for subfolder in "$BASE_FOLDER/recipes"/*; do
    if [[ -d "$subfolder" ]]; then
        image_name=$(basename "$subfolder")
        cd $subfolder && podman build -t workbench-images:${image_name} .
    fi
done

