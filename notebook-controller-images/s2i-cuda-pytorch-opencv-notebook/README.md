# PyTorch + OpenCV notebook

Custom notebook based on RHODS standard data science notebook, adding:

* CUDA

* [PyTorch](https://pytorch.org/) ([Github repo](https://github.com/pytorch/pytorch))

* [OpenCV](https://opencv.org/) ([Github repo](https://github.com/opencv/opencv))

* [Streamlit](https://streamlit.io/) ([Github repo](https://github.com/streamlit/streamlit))

Build example:

```bash
podman build --build-arg=BASE_IMAGE=s2i-minimal-notebook-cuda-:0.0.1 -t s2i-cuda-pytorch-opencv:0.0.1 .
```
