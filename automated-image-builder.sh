#!/bin/bash

set -a

source helper-functions

# Requirements
# Check if skopeo is installed
if ! command -v skopeo &> /dev/null; then
    echo "Error: skopeo is not installed on your system."
    exit 1
fi
# Check if podman is installed
if ! command -v podman &> /dev/null; then
    echo "Error: podman is not installed on your system."
    exit 1
fi

# Initialize variables with default values
RELEASE=""
DATE=""
BASE_IMAGE=""
PYTHON_VERSION=""
BUNDLE=""
IDE=""
CUSTOM_IMAGE=""
EXPORT_FOLDER=""

# Define a usage function
usage() {
  echo "Usage: $0 -r RELEASE -d DATE -b BASE_IMAGE -p PYTHON_VERSION -n BUNDLE -i IDE -e EXPORT_FOLDER -c CUSTOM_IMAGE"
  echo "- All arguments are required, except CUSTOM_IMAGE"
  echo "- DATE in yyyymmdd format"
  echo "- BASE_IMAGE one of 'standard', 'cuda', 'cuda-devel' or 'custom'"
  echo "- PYTHON_VERISON one of 'py39' or 'py311'"
  echo
  echo "Example:"
  echo "automated-image-builder.sh -r 2023c -d 20230921 -b standard -p py311 -n langchain -i vscode"
  exit 1
}

# Function to check if a date is in the format yyyymmdd
is_valid_date_format() {
  local date_pattern="^[0-9]{8}$"
  [[ $1 =~ $date_pattern ]]
}

# Check if -h or --help was provided
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  usage
fi

# Parse the named arguments
while getopts "r:d:b:p:n:i:e:c:" opt; do
  case "$opt" in
    r) RELEASE="$OPTARG" ;;
    d) DATE="$OPTARG" ;;
    b) BASE_IMAGE="$OPTARG" ;;
    p) PYTHON_VERSION="$OPTARG" ;;
    n) BUNDLE="$OPTARG" ;;
    i) IDE="$OPTARG" ;;
    c) CUSTOM_IMAGE="$OPTARG" ;;
    e) EXPORT_FOLDER="$OPTARG" ;;
    h|\?) usage ;;
  esac
done

# Check if all required arguments are provided
if [ -z "$RELEASE" ] || [ -z "$DATE" ] || [ -z "$BASE_IMAGE" ] || [ -z "$PYTHON_VERSION" ] || [ -z "$BUNDLE" ] || [ -z "$IDE" ]; then
  echo "All arguments (except custom_image and export_folder) are required."
  usage
fi

# Verify that date is in the format yyyymmdd
if ! is_valid_date_format "$DATE"; then
  echo "Invalid date format. It must be in the format yyyymmdd."
  usage
fi


# Verify that BASE_IMAGE is one of "standard," "cuda," or "cuda-devel"
if [ "$BASE_IMAGE" != "standard" ] && [ "$BASE_IMAGE" != "cuda" ] && [ "$BASE_IMAGE" != "cuda-devel" ]; then
  echo "Invalid base_image. It must be one of 'standard', 'cuda', 'cuda-devel' or 'custom'."
  usage
fi

# Verify that python-version is "py39" or "py311"
if [ "$PYTHON_VERSION" != "py39" ] && [ "$PYTHON_VERSION" != "py311" ]; then
  echo "Invalid python-version. It must be either 'py39' or 'py311'."
  usage
fi

# Display the provided arguments
echo "Release: $RELEASE"
echo "Date: $DATE"
echo "Base Image: $BASE_IMAGE"
echo "Python Version: $PYTHON_VERSION"
echo "Bundle: $BUNDLE"
echo "IDE: $IDE"

# Build base image name
case $BASE_IMAGE in
  standard)
    BASE_IMAGE="workbench-images:base-c9s-${PYTHON_VERSION}_${RELEASE}_${DATE}"
    ;;
  cuda)
    BASE_IMAGE="workbench-images:cuda-c9s-${PYTHON_VERSION}-runtime-cudnn_${RELEASE}_${DATE}"
    ;;
  cuda-devel)
    BASE_IMAGE="workbench-images:cuda-c9s-${PYTHON_VERSION}-devel-cudnn_${RELEASE}_${DATE}"
    ;;
  custom)
    BASE_IMAGE="$CUSTOM_IMAGE"
    ;;
esac

# Base Image Check
podman images --format "{{.Repository}}:{{.Tag}}" | grep $BASE_IMAGE > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  echo "The base image that will be used is:"
  echo "  $BASE_IMAGE"
  echo "It is present on your system, all is good!"
else
  echo "The base image you want to use is:"
  echo "  $BASE_IMAGE" 1
  echo
  if [[ ! $BASE_CHOICE == 4 ]]; then
    skopeo inspect docker://quay.io/opendatahub-contrib/${BASE_IMAGE} > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      echo "I have found this image on quay.io/opendatahub-contrib, all is good!"
    else
      skopeo inspect docker://quay.io/opendatahub-contrib/${BASE_IMAGE::-8}latest > /dev/null 2>&1
      if [[ $? -eq 0 ]]; then
        echo "This image could not be found on your system, so I will use the equivalent latest build from quay.io/opendatahub-contrib instead."
        echo
        echo "The base image will be:"
        echo "  quay.io/opendatahub-contrib/${BASE_IMAGE::-8}latest"
        BASE_IMAGE="quay.io/opendatahub-contrib/${BASE_IMAGE::-8}latest"
      else
        echo "Sorry, I could not find this image either locally or its latest version on quay.io/opendatahub-contrib, exiting..."
        exit 1
      fi
    fi 
  else
    skopeo inspect docker://$BASE_IMAGE > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      echo "This image is not present on your system but I found it in the repo you indicated, so all is good!" 1
    else
      echo "Sorry, I could not find the image you indicated, exiting..."
      exit 1
    fi
  fi
fi

# App Bundle Check
bundle_folder="./snippets/bundles"
bundle_array=($(list_subfolders "$bundle_folder"))
bundle_found=0
# Iterate through the array
for folder in "${bundle_array[@]}"; do
    echo $folder
    # Check if the folder name matches the pattern
    if [[ "$folder" =~ ^[0-9]+-"$BUNDLE" ]]; then
        APP_BUNDLE_FOLDER=$folder
        APP_BUNDLE_NAME=${APP_BUNDLE_FOLDER#*-}
        bundle_found=1
    fi
done

if [[ $bundle_found == 0 ]]; then
    echo "I did not find any bundle matching the name ${BUNDLE}."
    exit 1
fi

# IDE Check
ide_folder="./snippets/ides"
ide_array=($(list_subfolders "$ide_folder"))
ide_found=0
# Iterate through the array
for folder in "${ide_array[@]}"; do
# Check if the folder name matches the pattern
    if [[ "$folder" =~ ^[0-9]+-"$IDE" ]]; then
        IDE_FOLDER=$folder
        IDE_NAME=${IDE_FOLDER#*-}
        ide_found=1
    fi
done

if [[ $ide_found == 0 ]]; then
    echo "I did not find any IDE matching the name ${IDE}."
    exit 1
fi

# Build the image
EXPORT_FOLDER=${EXPORT_FOLDER:-"custom-recipes"}

# Check if Containerfile snippets exist
if [[ ! -d "snippets" ]]; then
  echo "No snippets were found!"
  exit 1
fi

# Set some variables used in the Containerfile snippets
OS_VERSION="c9s"
if [[ $BASE_IMAGE == *cuda* ]]; then CUDA='cuda-'; else CUDA=''; fi
if [[ $PYTHON_VERSION == 'py39' ]]; then PYTHON_FOLDER='python3.9'; fi
if [[ $PYTHON_VERSION == 'py311' ]]; then PYTHON_FOLDER='python3.11'; fi

# Prepare temporary folder to create the build source
FOLDER_NAME=${CUDA}${IDE_NAME}-${APP_BUNDLE_NAME}-${OS_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}
mkdir -p $EXPORT_FOLDER/$FOLDER_NAME

# Assemble the Containerfile by concatenating snippets
CONTAINERFILE_CONTENT=""

# Add Builder image before the main one
if [[ -d snippets/bundles/$APP_BUNDLE_FOLDER/builder ]]; then
  if [[ -d snippets/bundles/$APP_BUNDLE_FOLDER/builder/files ]]; then
    cp -r snippets/bundles/$APP_BUNDLE_FOLDER/builder/files/* $EXPORT_FOLDER/$FOLDER_NAME/
  fi
  CONTAINERFILE_CONTENT+=$(envsubst '${BASE_IMAGE}' < snippets/bundles/$APP_BUNDLE_FOLDER/builder/builder.snippet)$'\n\n'
fi

# Start with the base image and labels
CONTAINERFILE_CONTENT+=$(envsubst '${BASE_IMAGE} ${IMAGE_TYPE} ${CUDA} ${IDE_NAME} ${APP_BUNDLE_NAME} ${OS_VERSION} ${PYTHON_VERSION} ${RELEASE} ${DATE}' < snippets/base/base.snippet)$'\n\n'

# Add OS packages
if [[ -d snippets/bundles/$APP_BUNDLE_FOLDER/os ]]; then
  cp snippets/bundles/$APP_BUNDLE_FOLDER/os/os-packages.txt $EXPORT_FOLDER/$FOLDER_NAME/
  CONTAINERFILE_CONTENT+=$(cat "snippets/bundles/os_packages.snippet")$'\n\n'
fi

# Add custom Containerfile code
if [[ -d snippets/bundles/$APP_BUNDLE_FOLDER/custom ]]; then
  if [[ -d snippets/bundles/$APP_BUNDLE_FOLDER/custom/files ]]; then
    cp -r snippets/bundles/$APP_BUNDLE_FOLDER/custom/files/* $EXPORT_FOLDER/$FOLDER_NAME/
  fi
  CONTAINERFILE_CONTENT+=$(cat "snippets/bundles/$APP_BUNDLE_FOLDER/custom/custom.snippet")$'\n\n'
fi

# Add Python packages
if [[ -d snippets/bundles/$APP_BUNDLE_FOLDER/$PYTHON_VERSION ]]; then
  cp snippets/bundles/$APP_BUNDLE_FOLDER/$PYTHON_VERSION/requirements.txt $EXPORT_FOLDER/$FOLDER_NAME/
  CONTAINERFILE_CONTENT+=$(envsubst '${PYTHON_FOLDER}' < snippets/bundles/python_packages.snippet)$'\n\n'
fi

# IDE or Runtime code
if [[ -d snippets/ides/$IDE_FOLDER/files ]]; then
  cp -r snippets/ides/$IDE_FOLDER/files/* $EXPORT_FOLDER/$FOLDER_NAME/
fi
if [[ -d snippets/ides/$IDE_FOLDER/os ]]; then
  mkdir -p $EXPORT_FOLDER/$FOLDER_NAME/os-ide/
  cp -r snippets/ides/$IDE_FOLDER/os/os-packages.txt $EXPORT_FOLDER/$FOLDER_NAME/os-ide/
  CONTAINERFILE_CONTENT+=$(cat "snippets/ides/os_packages_ide.snippet")$'\n\n'
fi
CONTAINERFILE_CONTENT+=$(envsubst '${CUDA} ${PYTHON_FOLDER} ${RELEASE}' < snippets/ides/$IDE_FOLDER/$IDE_NAME.snippet)$'\n\n'

# Jupyter-specific additional code
if [[ $IDE_NAME == 'jupyter' ]]; then 
  cp snippets/bundles/$APP_BUNDLE_FOLDER/$PYTHON_VERSION/requirements-jupyter.txt $EXPORT_FOLDER/$FOLDER_NAME/
fi

echo "$CONTAINERFILE_CONTENT" > $EXPORT_FOLDER/$FOLDER_NAME/Containerfile

echo "Your recipe has been saved to $EXPORT_FOLDER/$FOLDER_NAME."
echo
echo "You can build this image with:"
echo "cd $EXPORT_FOLDER/$FOLDER_NAME"
echo "podman build -t workbench-images:${CUDA}${IDE_NAME}-${APP_BUNDLE_NAME}-${OS_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE} ."