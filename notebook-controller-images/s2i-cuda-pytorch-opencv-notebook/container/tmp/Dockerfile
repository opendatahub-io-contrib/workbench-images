ARG BASE_IMAGE
FROM ${BASE_IMAGE} as BUILDER

ARG OPENCV_VERSION=4.6.0
ARG CUDA_ARCH_BIN=6.0,6.1,7.0,7.5,8.0,8.6

USER 0

##########################################
# Install various dependencies for build #
##########################################

COPY oneAPI.repo /etc/yum.repos.d/

# Install needed packages to build
RUN yum install -y yum-utils && \
    yum-config-manager --enable crb && \
    yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    yum install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm && \
    yum install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm && \
    INSTALL_PKGS="libsndfile ffmpeg ffmpeg-devel epel-release git gcc gcc-c++ \
    cmake qt5-qtbase-devel \
    gtk2-devel libpng-devel jasper-devel openexr-devel libwebp-devel \
    libjpeg-turbo-devel libtiff-devel tbb-devel libv4l-devel \
    eigen3-devel freeglut-devel mesa-libGL mesa-libGL-devel \
    boost boost-thread boost-devel gstreamer1-plugins-base \
    gstreamer1-plugins-base-devel hdf5  hdf5-devel \
    lapack lapack-devel lmdb-devel gflags-devel glog-devel tesseract-devel \
    intel-oneapi-mkl-devel-2022.1.0" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    rm -rf /var/cache/dnf && \
    cp /opt/intel/oneapi/mkl/2022.1.0/lib/pkgconfig/*.pc /usr/share/pkgconfig/ && \
    ldconfig

# Set Env manually as source setvars.sh is now working
ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/tbb/2021.6.0/env/..:/opt/intel/oneapi/compiler/2022.1.0/linux/IntelDPCPP \
    CMPLR_ROOT=/opt/intel/oneapi/compiler/2022.1.0 \
    CPATH=/opt/intel/oneapi/tbb/2021.6.0/env/../include:/opt/intel/oneapi/mkl/2022.1.0/include \
    DIAGUTIL_PATH=/opt/intel/oneapi/compiler/2022.1.0/sys_check/sys_check.sh \
    LD_LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.6.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/mkl/2022.1.0/lib/intel64:/opt/intel/oneapi/compiler/2022.1.0/linux/lib:/opt/intel/oneapi/compiler/2022.1.0/linux/lib/x64:/opt/intel/oneapi/compiler/2022.1.0/linux/compiler/lib/intel64_lin:/usr/local/nvidia/lib:/usr/local/nvidia/lib64 \
    LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.6.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/mkl/2022.1.0/lib/intel64:/opt/intel/oneapi/compiler/2022.1.0/linux/compiler/lib/intel64_lin:/opt/intel/oneapi/compiler/2022.1.0/linux/lib:/usr/local/cuda/lib64/stubs \
    MANPATH=/opt/intel/oneapi/compiler/2022.1.0/documentation/en/man/common: \
    MKLROOT=/opt/intel/oneapi/mkl/2022.1.0 \
    MKL_INCLUDE_DIR=/opt/intel/oneapi/mkl/2022.1.0/include \
    MKL_LIBRARIES=/opt/intel/oneapi/mkl/2022.1.0/lib/intel64 \
    NLSPATH=/opt/intel/oneapi/mkl/2022.1.0/lib/intel64/locale/%l_%t/%N:/opt/intel/oneapi/compiler/2022.1.0/linux/compiler/lib/intel64_lin/locale/%l_%t/%N \
    OCL_ICD_FILENAMES=/opt/intel/oneapi/compiler/2022.1.0/linux/lib/x64/libintelocl.so \
    ONEAPI_ROOT=/opt/intel/oneapi \
    PATH=/opt/intel/oneapi/mkl/2022.1.0/bin/intel64:/opt/intel/oneapi/compiler/2022.1.0/linux/bin/intel64:/opt/intel/oneapi/compiler/2022.1.0/linux/bin:$PATH \
    SETVARS_COMPLETED=1 \
    TBBROOT=/opt/intel/oneapi/tbb/2021.6.0/env/..
    

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
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_JAVA=OFF \
    -D BUILD_opencv_gapi=OFF \
    -D BUILD_OPENCV_PYTHON2=OFF \
    -D BUILD_opencv_python3=ON \
    -D BUILD_opencv_world=ON \
    -D BUILD_PERF_TESTS=OFF   \
    -D BUILD_TESTS=OFF  \
    -D CMAKE_INSTALL_PREFIX=/opt/opencv \
    -D CMAKE_LIBRARY_PATH=/opt/app-root/lib \
    -D CUDA_ARCH_BIN=${CUDA_ARCH_BIN} \
    -D CUDA_FAST_MATH=ON \
    -D ENABLE_FAST_MATH=1 \
    -D HAVE_opencv_python3=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D MKL_USE_MULTITHREAD=ON \
    -D MKL_WITH_OPENMP=ON \
    -D MKL_WITH_TBB=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D OPENCV_ENABLE_NONFREE=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_build/opencv_contrib/modules \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_PYTHON3_INSTALL_PATH=/opt/app-root/lib/python3.9/site-packages \
    -D PYTHON3_EXECUTABLE=/opt/app-root/bin/python \
    -D PYTHON3_INCLUDE_DIR=/opt/app-root/include/site/python3.9 \
    -D PYTHON3_INCLUDE_PATH=/opt/app-root/include/site/python3.9 \
    -D PYTHON3_LIBRARIES=/usr/lib64/libpython3.9.so \
    -D PYTHON3_LIBRARY=/usr/lib64/libpython3.9.so \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=/opt/app-root/lib/python3.9/site-packages/numpy/core/include \
    -D PYTHON3_PACKAGES_PATH=/opt/app-root/lib/python3.9/site-packages \
    -D PYTHON_EXECUTABLE=/opt/app-root/bin/python3 \
    -D WITH_CUBLAS=ON \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=ON \
    -D WITH_CUFFT=ON \
    -D WITH_EIGEN=ON \
    -D WITH_FFMPEG=ON \
    -D WITH_GDCM=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_IPP=ON \
    -D WITH_LAPACK=ON \
    -D WITH_MKL=ON \
    -D WITH_NVCUVID=ON \
    -D WITH_OPENGL=ON \
    -D WITH_TBB=ON ..

RUN make -j`nproc` && \
    make install && \
    cp /opt/opencv/lib64/pkgconfig/opencv4.pc /usr/share/pkgconfig/ && \
    ldconfig

##############################
## Build PyTorch from source #
##############################

# PyTorch Dependencies

WORKDIR /tmp

COPY make.inc /tmp/

# Install some Python dependencies
RUN pip install astunparse ninja future    

# Compile Magma
RUN mkdir -p magma_build && cd magma_build && \
    wget http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.6.2.tar.gz && \
    tar -xvzf magma-2.6.2.tar.gz && cd /tmp/magma_build/magma-2.6.2 && \
    cp /tmp/make.inc /tmp/magma_build/magma-2.6.2 && \
    # Don't compile Fortran modules
    sed -i -e 's/FORT\ *?=\ gfortran/#FORT/' Makefile && \
    make  -j`nproc` lib && \
    make  -j`nproc` sparse-lib && \
    # Remove copy of Fortan modules
    sed -i -e '/cp\ include\/\*\.mod/d' Makefile && \
    make install prefix=/opt/magma && \
    ln -s /opt/magma/lib/pkgconfig/magma.pc /usr/share/pkgconfig/ && \
    ldconfig

# Install PyTorch from source
ENV USE_MKL=1 \
    USE_MKLDNN=1 \
    CMAKE_INCLUDE_PATH=$MKL_INCLUDE_DIR:$CMAKE_INCLUDE_PATH \
    CMAKE_LIBRARY_PATH=$MKL_LIBRARIES:$CMAKE_LIBRARY_PATH \
    BLAS=MKL \
    USE_TBB=1 \
    MKL_TBB=1 \
    MKL_THREADING=TBB \
    MKLDNN_THREADING=TBB \
    USE_CUDA=1 \
    TORCH_CUDA_ARCH_LIST="6.0;6.1;7.0;7.5;8.0;8.6" \
    USE_OPENCV=1 \
    USE_FFMPEG=1 \
    USE_LMDB=1 \
    BUILD_CAFFE2=1 \
    USE_NUMA=OFF \
    USE_MPI=OFF \
    # Intel Optimizations https://github.com/intel/intel-extension-for-pytorch/blob/master/docs/tutorials/performance_tuning/tuning_guide.md#intel-openmp
    LD_PRELOAD=/opt/intel/oneapi/compiler/2022.1.0/linux/compiler/lib/intel64_lin/libiomp5.so:$LD_PRELOAD \
    KMP_AFFINITY=granularity=fine,compact,1,0

COPY ffmpeg5-compat.patch /tmp/

RUN mkdir -p /tmp/pytorch_build && cd /tmp/pytorch_build && \
    git clone --recurse-submodules -j 8 --depth 1 --branch v1.12.0 https://github.com/pytorch/pytorch && \
    cd /tmp/pytorch_build/pytorch && \
    # Patch for FFMpeg-5 compatibility
    cp /tmp/ffmpeg5-compat.patch ./ && \
    patch -p1 < ffmpeg5-compat.patch && \
    # Git repo has pre-release numbering, which prevents pip list to get the right version
    echo "1.12.0" > version.txt && \
    # Remove git directory to not pollute version numbers
    rm -rf .git && \
    MAXJOBS=`nproc` python setup.py install --prefix=/opt/app-root/torch && \
    ln -s /opt/app-root/torch/lib64/python3.9/site-packages/torch /opt/app-root/lib/python3.9/site-packages/torch && \
    ln -s /opt/app-root/torch/lib64/python3.9/site-packages/caffe2 /opt/app-root/lib/python3.9/site-packages/caffe2 && \
    ln -s /opt/app-root/torch/lib64/python3.9/site-packages/torch-1.12.0-py3.9.egg-info /opt/app-root/lib/python3.9/site-packages/torch-1.12.0-py3.9.egg-info && \
    ln -s /opt/app-root/torch/lib64/python3.9/site-packages/torchgen /opt/app-root/lib/python3.9/site-packages/torchgen

# Install Torchvision from source

ENV FORCE_CUDA=1

RUN mkdir -p /tmp/torchvision_build && cd /tmp/torchvision_build && \
    git clone --recurse-submodules -j 8 --depth 1 --branch v0.13.0 https://github.com/pytorch/vision && \
    cd /tmp/torchvision_build/vision && \
    # Git repo has pre-release numbering, which prevents pip list to get the right version
    echo "0.13.0" > version.txt && \
    # Remove git directory to not pollute version numbers
    rm -rf .git && \
    MAXJOBS=`nproc` python setup.py install --prefix=/opt/app-root/torchvision && \
    ln -s /opt/app-root/torchvision/lib64/python3.9/site-packages/torchvision-0.13.0-py3.9-linux-x86_64.egg/torchvision /opt/app-root/lib/python3.9/site-packages/torchvision && \
    ln -s /opt/app-root/torchvision/lib64/python3.9/site-packages/torchvision-0.13.0-py3.9-linux-x86_64.egg/EGG-INFO /opt/app-root/lib/python3.9/site-packages/torchvision-0.13.0-py3.9.egg-info

# TorchAudio

ENV BUILD_SOX=ON \
    BUILD_KALDI=ON \
    BUILD_RNNT=ON \
    BUILD_CTC_DECODER=ON \
    BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON \
    USE_FFMPEG=ON \
    USE_CUDA=ON \
    USE_ROCM=OFF \
    USE_OPENMP=OFF

RUN mkdir -p /tmp/torchaudio_build && cd /tmp/torchaudio_build && \
    git clone --recurse-submodules -j 8 --depth 1 --branch v0.12.0 https://github.com/pytorch/audio.git && \
    cd /tmp/torchaudio_build/audio && \
    # Git repo has pre-release numbering, which prevents pip list to get the right version
    echo "0.12.0" > version.txt && \
    MAXJOBS=`nproc` python setup.py install --prefix=/opt/app-root/torchaudio && \
    ln -s /opt/app-root/torchaudio/lib64/python3.9/site-packages/torchaudio-0.12.0+2e13884-py3.9-linux-x86_64.egg/torchaudio /opt/app-root/lib/python3.9/site-packages/torchaudio && \
    ln -s /opt/app-root/torchaudio/lib64/python3.9/site-packages/torchaudio-0.12.0+2e13884-py3.9-linux-x86_64.egg/EGG-INFO /opt/app-root/lib/python3.9/site-packages/torchaudio-0.12.0-py3.9.egg-info
