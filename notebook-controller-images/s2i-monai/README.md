# S2I Monai image

Notebook based on the Data Science notebook, adding:

* [Monai](https://monai.io/) ([Github repo](https://github.com/Project-MONAI))

MONAI is a freely available, community-supported, PyTorch-based framework for deep learning in healthcare imaging. It provides domain-optimized foundational capabilities for developing healthcare imaging training workflows in a native PyTorch paradigm.
Project MONAI also includes MONAI Label, an intelligent open source image labeling and learning tool that helps researchers and clinicians collaborate, create annotated datasets, and build AI models in a standardized MONAI paradigm.

NOTE: CUDA is a requirement for Monai. However PyTorch is also a requirement, which comes with it own embedded CUDA when installed from PyPi (or Conda), so we can start from a standard image.

* [Streamlit](https://streamlit.io/) ([Github repo](https://github.com/streamlit/streamlit))

Streamlit turns data scripts into shareable web apps in minutes.
All in pure Python. No front‑end experience required.
See [details on Streamlit implementation](../streamlit-notebook/README.md).

Build example from UBI9 with Python 3.9:

```bash
make ubi9-py39 BASE_IMAGE=localhost/s2i-datascience-notebook-ubi9-py39:0.0.1 TAG=0.0.1
```
