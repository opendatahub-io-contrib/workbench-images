#!/bin/bash

set -a

source helper-functions

BASE_FOLDER=${1:-$(pwd)}

# Upload all images in the recipes folder
for subfolder in "$BASE_FOLDER/recipes"/*; do
    if [[ -d "$subfolder" ]]; then
        image_name=$(basename "$subfolder")
        # Check is image is present
        podman images --format "{{.Repository}}:{{.Tag}}" | grep $image_name > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            podman push localhost/workbench-images:$image_name quay.io/opendatahub-contrib/workbench-images:$image_name
            podman push localhost/workbench-images:$image_name quay.io/opendatahub-contrib/workbench-images:${image_name::-8}latest
        fi      
    fi
done

