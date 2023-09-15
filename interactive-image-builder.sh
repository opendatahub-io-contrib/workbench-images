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

# Intro
clear
echo "###############################"
echo "# The Custom Images Mageforge #"
echo "###############################"
echo
tw_echo "Welcome, brave Container voyager, to the depths of the Custom Images Mageforge, where we conjure containers of power and wisdom! 🔮🐉" 1
tw_echo "You have embarked on a perilous journey through the arcane corridors of containerization." 1
echo
tw_echo "To forge your Container image, you must answer the questions I present to you with wisdom and cunning." 1
tw_echo "Choose your path wisely, and we shall emerge victorious together! 🌀🗝️" 1
echo
tw_echo "Press any key to start this treacherous quest... 🌟" 1
read -n 1 -s

# Promt for release
clear
echo "Release name"
echo "------------"
tw_echo "Which name do you want to give to this release, for example: '2026a' (for default, '2023c', press enter): " 0
read -p "" RELEASE
RELEASE=${RELEASE:-"2023c"}

# Promt for date
clear
echo "Release date"
echo "------------"
tw_echo "Which date do you want to use for this release in YYYYMMDD format (for default '$(date +%Y%m%d)', press enter): " 0
read -p "" DATE
DATE=${DATE:-$(date +%Y%m%d)}

# Promt for base image
clear
echo "Which Base Image do you want to use?"
echo "------------------------------------"
tw_echo "1) Standard image (default, press enter)" 1
tw_echo "2) CUDA image - version 11.8" 1
tw_echo "3) CUDA development image - version 11.8" 1
tw_echo "4) Other" 1

BASE_CHOICE=$(select_value 4)

# Prompt for Python version
clear
echo "Which Python Version do you want to use?"
echo "----------------------------------------"
tw_echo "1) 3.11 (default, press enter)" 1
tw_echo "2) 3.9" 1

PYTHON_CHOICE=$(select_value 2)

case $PYTHON_CHOICE in
  1)
    PYTHON_VERSION="py311"
    ;;
  2)
    PYTHON_VERSION="py39"
    ;;
esac

# Build base image name
case $BASE_CHOICE in
  1)
    BASE_IMAGE="workbench-images:base-c9s-${PYTHON_VERSION}_${RELEASE}_${DATE}"
    ;;
  2)
    BASE_IMAGE="workbench-images:cuda-c9s-${PYTHON_VERSION}-runtime-cudnn_${RELEASE}_${DATE}"
    ;;
  3)
    BASE_IMAGE="workbench-images:cuda-c9s-${PYTHON_VERSION}-devel-cudnn_${RELEASE}_${DATE}"
    ;;
  4)
    tw_echo "Enter the full path/name of your base image (e.g. quay.io/my_repo/my_image:mytag): " 0
    read -p "" BASE_IMAGE
    ;;
esac

# Confirmation of base image
clear
podman images --format "{{.Repository}}:{{.Tag}}" | grep $BASE_IMAGE > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  tw_echo "The base image that will be used is:" 1
  tw_echo "  $BASE_IMAGE" 1
  tw_echo "It is present on your system, all is good!" 1
else
  tw_echo "The base image you want to use is:" 1
  tw_echo "  $BASE_IMAGE" 1
  echo
  if [[ ! $BASE_CHOICE == 4 ]]; then
    skopeo inspect docker://quay.io/opendatahub-contrib/${BASE_IMAGE} > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      tw_echo "I have found this image on quay.io/opendatahub-contrib, all is good!" 1
    else
      skopeo inspect docker://quay.io/opendatahub-contrib/${BASE_IMAGE::-8}latest > /dev/null 2>&1
      if [[ $? -eq 0 ]]; then
        tw_echo "This image could not be found on your system, so I will use the equivalent latest build from quay.io/opendatahub-contrib instead." 1
        echo
        tw_echo "The base image will be:" 1
        tw_echo "  quay.io/opendatahub-contrib/${BASE_IMAGE::-8}latest" 1
        BASE_IMAGE="quay.io/opendatahub-contrib/${BASE_IMAGE::-8}latest"
      else
        tw_echo "Sorry, I could not find this image either locally or its latest version on quay.io/opendatahub-contrib, exiting..." 1
        exit 1
      fi
    fi 
  else
    skopeo inspect docker://$BASE_IMAGE > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      tw_echo "This image is not present on your system but I found it in the repo you indicated, so all is good!" 1
    else
      tw_echo "Sorry, I could not find the image you indicated, exiting..." 1
      exit 1
    fi
  fi
fi
tw_echo "Press any key to continue (CTRL+C to end the wizard)..." 0
read -n 1 -s

# Prompt for App Bundle
clear
echo "Which Applications/Libraries bundle do you want to use?"
echo "-------------------------------------------------------"
bundle_folder="./snippets/bundles"
APP_BUNDLE_FOLDER="$(select_subfolder "$bundle_folder" "$PYTHON_VERSION")"
# Remove the leading number and hyphen
APP_BUNDLE_NAME=${APP_BUNDLE_FOLDER#*-}

# Prompt for IDE choice
clear
echo "Which IDE do you want to use?"
echo "------------------------------"
ide_folder="./snippets/ides"
IMAGE_IDE_FOLDER="$(select_subfolder "$ide_folder")"
IMAGE_IDE_NAME=${IMAGE_IDE_FOLDER#*-}

if [[ $IMAGE_IDE_NAME == "runtime" ]]; then
  IMAGE_TYPE="runtime"
else
  IMAGE_TYPE="workbench"
fi

# Build the image
clear
tw_echo "Let's create you image recipe!" 1
echo
tw_echo "In which folder do you want to store this recipe (for default, 'custom-recipes', press enter)?" 1
read -p "" EXPORT_FOLDER
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
FOLDER_NAME=${CUDA}${IMAGE_IDE_NAME}-${APP_BUNDLE_NAME}-${OS_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}
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
CONTAINERFILE_CONTENT+=$(envsubst '${BASE_IMAGE} ${IMAGE_TYPE} ${CUDA} ${IMAGE_IDE_NAME} ${APP_BUNDLE_NAME} ${OS_VERSION} ${PYTHON_VERSION} ${RELEASE} ${DATE}' < snippets/base/base.snippet)$'\n\n'

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
if [[ -d snippets/ides/$IMAGE_IDE_FOLDER/files ]]; then
  cp -r snippets/ides/$IMAGE_IDE_FOLDER/files/* $EXPORT_FOLDER/$FOLDER_NAME/
fi
if [[ -d snippets/ides/$IMAGE_IDE_FOLDER/os ]]; then
  mkdir -p $EXPORT_FOLDER/$FOLDER_NAME/os-ide/
  cp -r snippets/ides/$IMAGE_IDE_FOLDER/os/os-packages.txt $EXPORT_FOLDER/$FOLDER_NAME/os-ide/
  CONTAINERFILE_CONTENT+=$(cat "snippets/ides/os_packages_ide.snippet")$'\n\n'
fi
CONTAINERFILE_CONTENT+=$(envsubst '${CUDA} ${PYTHON_FOLDER} ${RELEASE}' < snippets/ides/$IMAGE_IDE_FOLDER/$IMAGE_IDE_NAME.snippet)$'\n\n'

# Jupyter-specific additional code
if [[ $IMAGE_IDE_NAME == 'jupyter' ]]; then 
  cp snippets/bundles/$APP_BUNDLE_FOLDER/$PYTHON_VERSION/requirements-jupyter.txt $EXPORT_FOLDER/$FOLDER_NAME/
fi

echo "$CONTAINERFILE_CONTENT" > $EXPORT_FOLDER/$FOLDER_NAME/Containerfile

tw_echo "Your recipe has been saved to $EXPORT_FOLDER/$FOLDER_NAME." 1
echo
tw_echo "You can build this image with:" 1
tw_echo "cd $EXPORT_FOLDER/$FOLDER_NAME" 1
tw_echo "podman build -t workbench-images:${CUDA}${IMAGE_IDE_NAME}-${APP_BUNDLE_NAME}-${OS_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE} ." 1
