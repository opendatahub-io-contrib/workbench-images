#!/bin/bash

./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py311 -n langchain -i jupyter -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py311 -n pytorch -i jupyter -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py311 -n tensorflow -i jupyter -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py39 -n tensorflow -i jupyter -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py39 -n langflow -i langflow -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py311 -n datascience -i runtime -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py311 -n pytorch -i runtime -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py311 -n tensorflow -i runtime -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b cuda -p py311 -n pytorch -i vscode -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b standard -p py311 -n r -i rstudio -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b standard -p py311 -n datascience -i jupyter -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b standard -p py311 -n datascience -i vscode -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b standard -p py311 -n datascience -i runtime -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b standard -p py311 -n r -i runtime -e recipes
./automated-image-builder.sh -r 2023c -d 20230922 -b standard -p py311 -n spark -i runtime -e recipes
