#!/bin/bash

set -a

source helper-functions

BASE_FOLDER=$(pwd)

# Update base
cd $BASE_FOLDER/base/c9s/3.9 && pipenv lock && pipenv requirements > requirements.txt
cd $BASE_FOLDER/base/c9s/3.11 && pipenv lock && pipenv requirements > requirements.txt

# Update all bundles
# Populate the 'items' array with subfolder names
for subfolder in "$BASE_FOLDER/snippets/bundles"/*; do
    if [[ -d "$subfolder" ]]; then
        # Only update the bundle if the matching python folder exists
        if [[ -d "$subfolder/py39" ]]; then
            cd "$subfolder/py39" && pipenv lock && pipenv requirements > requirements.txt && pipenv requirements --categories="jupyter" > requirements-jupyter.txt
        fi
        # Only update the bundle if the matching python folder exists
        if [[ -d "$subfolder/py311" ]]; then
            cd "$subfolder/py311" && pipenv lock && pipenv requirements > requirements.txt && pipenv requirements --categories="jupyter" > requirements-jupyter.txt
        fi
    fi
done

echo "All Python requirement files have been updated!"