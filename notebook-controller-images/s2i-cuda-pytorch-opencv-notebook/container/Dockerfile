# ARGS found in the different build layers
ARG BASE_IMAGE
ARG OPENCV_VERSION=4.6.0
ARG CUDA_VERSION=11.6.2-cudnn8-devel-centosstream8
ARG CUDA_ARCH_BIN=6.1


FROM ${BASE_IMAGE} as BUILDER

USER 0

##########################################
# Install various dependencies for build #
##########################################

RUN yum install -y yum-utils && \
    yum-config-manager --enable powertools && \
    yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm && \
    yum install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm && \
    INSTALL_PKGS="libsndfile \
    ffmpeg \
    ffmpeg-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    rm -rf /var/cache/dnf

# Install needed packages to build
RUN INSTALL_PKGS="epel-release git gcc gcc-c++ cmake qt5-qtbase-devel \
    gtk2-devel libpng-devel jasper-devel OpenEXR-devel libwebp-devel \
    libjpeg-turbo-devel libtiff-devel tbb-devel libv4l-devel \
    eigen3-devel freeglut-devel mesa-libGL mesa-libGL-devel \
    boost boost-thread boost-devel gstreamer1-plugins-base \
    gstreamer1-plugins-base-devel hdf5  hdf5-devel openblas openblas-devel \
    lapack lapack-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    rm -rf /var/cache/dnf

##############################
## Build PyTorch from source #
##############################

# PyTorch Dependencies

# Install Intel MKL
RUN pip install astunparse ninja future mkl mkl-include mkl-devel

WORKDIR /tmp

COPY make.inc .

# Compile Magma
RUN mkdir -p magma_build && cd magma_build && \
    wget http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.6.2.tar.gz && \
    tar -xvzf magma-2.6.2.tar.gz && cd /tmp/magma_build/magma-2.6.2 && \
    cp /tmp/make.inc /tmp/magma_build/magma-2.6.2 && \
    sed -i -e 's/FORT\ *?=\ gfortran/#FORT/' Makefile && \
    make lib && \
    make sparse-lib && \
    # Remove copy of Fortan modules
    RUN sed -i -e '/cp\ include\/\*\.mod/d' Makefile && \
    make install prefix=/opt/magma && \
    ln -s /opt/magma/lib/pkgconfig/magma.pc /usr/share/pkgconfig/ && \
    ldconfig

# Notes
export MKL_ROOT=/opt/app-root
export MKL_INCLUDE_DIR=/opt/app-root/include
export MKL_LIBRARIES=/opt/app-root/lib
export CMAKE_INCLUDE_PATH=$MKL_INCLUDE:$CMAKE_INCLUDE_PATH
export CMAKE_LIBRARY_PATH=$MKL_LIBRARY:$CMAKE_LIBRARY_PATH
export USE_OPENCV=1
export USE_FFMPEG=1
export USE_LMDB=1
export LD_PRELOAD=/opt/app-root/lib/libiomp5.so
export TORCH_CUDA_ARCH_LIST="6.0;6.1;7.0;7.5;8.0;8.6"
export USE_MKLDNN=1
export USE_MKL=1
export USE_OPENCV=1
export BLAS=MKL
export USE_TBB=1 
export MKL_TBB=1
export MKL_THREADING=TBB
export MKLDNN_THREADING=TBB
export USE_CUDA=1
export BUILD_CAFFE2=1
export USE_NUMA=OFF
export USE_MPI=OFF

install ccache

#LMDB_INCLUDE_DIR LMDB_LIBRARIES

# Compile PyTorch
ENV USE_MKDNN=ON \
    USE_MKL=ON

RUN mkdir -p /tmp/pytorch_build && cd /tmp/pytorch_build && \
    git clone --recurse-submodules -j 8 --depth 1 --branch v1.12.0 https://github.com/pytorch/pytorch && \
    cd /tmp/pytorch_build/pytorch && \
    MAXJOBS=`nproc --ignore=2` python setup.py install --prefix=/opt/app-root/torch 

#########################################
## Build OpenCV and Contrib from source #
#########################################

# Build OpenCV
RUN mkdir -p /tmp/opencv_build && cd /tmp/opencv_build && \
    git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git && \
    git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git && \
    mkdir -p /tmp/opencv_build/opencv/build

WORKDIR /tmp/opencv_build/opencv/build

RUN cmake3 -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/opt/opencv \
    -D HAVE_opencv_python3=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_TBB=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D OPENCV_ENABLE_NONFREE=OFF \
    -D CUDA_ARCH_BIN=6.0,6.1,7.0,7.5,8.0,8.6 \
    -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=OFF ..

RUN make -j`nproc --ignore=2`

RUN make install

######################
## Build final image #
######################

#FROM DATASCIENCE as FINAL

#USER 0

#RUN yum install -y yum-utils && \
#    yum-config-manager --enable powertools && \
#    yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
#    yum install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm && \
#    yum install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm && \
#    INSTALL_PKGS="libsndfile \
#    ffmpeg \
#    ffmpeg-devel" && \
#    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
#    rpm -V $INSTALL_PKGS && \
#    yum -y clean all --enablerepo='*' && \
#    rm -rf /var/cache/dnf

# Install runtime packages
#RUN INSTALL_PKGS="epel-release git qt5-qtbase gtk2 libpng jasper-libs OpenEXR-libs \
#    libwebp libjpeg-turbo libtiff tbb libv4l eigen3-devel freeglut mesa-libGL \
#    boost boost-thread gstreamer1-plugins-base hdf5 openblas lapack exempi \
#    PackageKit-gstreamer-plugin gstreamer-plugin-crystalhd gstreamer1 \
#    gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good \
#    gstreamer1-plugins-ugly-free gstreamer1-svt-av1 gstreamer1-svt-vp9" && \
#    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
#    rpm -V $INSTALL_PKGS && \
#    yum -y clean all --enablerepo='*' && \
#    rm -rf /var/cache/dnf

#COPY --from=BUILDER /opt/opencv /opt/opencv

## Link OpenCV, and include it in the Python path (venv)
#RUN ln -s /opt/opencv/lib64/pkgconfig/opencv4.pc /usr/share/pkgconfig/ && \
#    ldconfig && \
#    ln -s /opt/opencv/lib/python3.9/site-packages/cv2 /opt/app-root/lib/python3.9/site-packages/cv2 && \
#    fix-permissions /opt/app-root

#WORKDIR /opt/app-root/src
#USER 1001

#CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 --port=8080