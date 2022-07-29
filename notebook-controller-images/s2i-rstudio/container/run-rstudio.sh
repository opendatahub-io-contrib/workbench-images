#!/bin/bash

# Create lib folders if it does not exist
mkdir -p  /opt/app-root/src/Rpackages/4.1

# rstudio terminal cant see environment variables set by the container runtime
# (which breaks kubectl, to fix this we store the KUBERNETES_* env vars in Renviron.site)
#env | grep KUBERNETES_ >> ${R_HOME}/etc/Renviron.site

export USER=$(whoami)

launch_command=$(python /opt/app-root/bin/setup_rstudio.py)

echo $launch_command

eval $launch_command
