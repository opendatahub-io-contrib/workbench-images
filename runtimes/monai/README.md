# Monai image

Datascience runtime image adding:

* [Monai](https://monai.io/) ([Github repo](https://github.com/Project-MONAI))

MONAI is a freely available, community-supported, PyTorch-based framework for deep learning in healthcare imaging. It provides domain-optimized foundational capabilities for developing healthcare imaging training workflows in a native PyTorch paradigm.
Project MONAI also includes MONAI Label, an intelligent open source image labeling and learning tool that helps researchers and clinicians collaborate, create annotated datasets, and build AI models in a standardized MONAI paradigm.
This deployment of MONAI includes all the [optional dependencies](https://docs.monai.io/en/stable/installation.html#installing-the-recommended-dependencies) to get you going quickly.

IMPORTANT NOTE: CUDA is a requirement for Monai. However PyTorch is also a requirement, which comes with it own embedded CUDA when installed from PyPi (or Conda), so we can start from a standard image.

* [OpenCV](https://opencv.org/) ([Github repo](https://github.com/opencv/opencv))

OpenCV (Open Source Computer Vision Library) is an open source computer vision and machine learning software library. OpenCV was built to provide a common infrastructure for computer vision applications and to accelerate the use of machine perception in the commercial products. Being an Apache 2 licensed product, OpenCV makes it easy for businesses to utilize and modify the code.

## Standard Image

Build example from UBI9 with Python 3.9:

```bash
make c9s-py39 RELEASE=dev DATE=20230101
```
