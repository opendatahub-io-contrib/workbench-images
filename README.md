# Workbench Images

*[Changelog](CHANGELOG.md)*

Various **Workbench and Runtime images** to use with [Open Data Hub](http://opendatahub.io/) (ODH) or [Red Hat OpenShift Data Science](https://www.redhat.com/en/technologies/cloud-computing/openshift/openshift-data-science) (RHODS).

The Workbench and Runtime images are built in a modular way, allowing for full flexibility in the packages and applications (**Datascience**, **PyTorch**, **Tensorflow**, **Langchain**,...) or IDEs (**Jupyter**, **VSCode**, **RStudio**, **Langflow**,...) you want to use.

With all those possible configurations, only some images are pre-built and published (the most important ones). Those are listed below.

An interactive **Wizard** allows you to also easily create you own image! See [Building an image](#building-an-image).

## Available Images

All images listed below are based on CentOS Stream 9 with Python 3.11 (except the Langflow image based on 3.9 due to compatibility issues).

### Workbench images

Those images can be used directly as Workbenches within ODH or RHODS after importing them (Settings->Notebook images->Import new image).

| Image description | Pull address |
|-------------------|--------------|
|Jupyter Data Science|quay.io/opendatahub-contrib/workbench-images:jupyter-datascience-c9s-py311_2023c_latest|
|VSCode Data Science|quay.io/opendatahub-contrib/workbench-images:vscode-datascience-c9s-py311_2023c_latest|
|RStudio|quay.io/opendatahub-contrib/workbench-images:rstudio-r-c9s-py311_2023c_latest|
|Jupyter PyTorch (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-jupyter-pytorch-c9s-py311_2023c_latest|
|VSCode PyTorch (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-vscode-pytorch-c9s-py311_2023c_latest|
|Jupyter Tensorflow (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-jupyter-tensorflow-c9s-py311_2023c_latest|
|Jupyter Langchain (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-jupyter-langchain-c9s-py311_2023c_latest|
|Langflow (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-langflow-langflow-c9s-py39_2023c_latest|

### Runtime images

Those images can be used in a Data Science Pipeline. They contain the exact same set of libraries as workbench images, except the IDE part.

| Image description | Pull address |
|-------------------|--------------|
|Runtime Data Science|quay.io/opendatahub-contrib/workbench-images:runtime-datascience-c9s-py311_2023c_latest|
|Runtime Data Science (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-runtime-datascience-c9s-py311_2023c_latest|
|Runtime PyTorch (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-runtime-pytorch-c9s-py311_2023c_latest|
|Runtime Tensorflow (CUDA)|quay.io/opendatahub-contrib/workbench-images:cuda-runtime-tensorflow-c9s-py39_2023c_latest|
|Runtime R|quay.io/opendatahub-contrib/workbench-images:runtime-r-c9s-py311_2023c_latest|
|Runtime Spark|quay.io/opendatahub-contrib/workbench-images:runtime-spark-c9s-py311_2023c_latest|

## Detailed Images Content

Images consist of:

- A base OS image
- Some base OS packages
- A bundle of applications and libraries
- An IDE (or not in the case of Runtime images)

So with different sets of OS packages, bundles and IDEs to choose from, you can create the image most suited to your need!

### Base (OS)

All images are based on CentOS Stream 9. This allows to install applications and libraries that would not be available on UBI-based images. The images could also be easily ported to RHEL to get full support. Epel and CRB repos are enabled, as well as rpmfusion and other proprietary repos from Microsoft, Cisco and MongoDB.

### OS Packages

The base images include the following main libraries out of the box:

- FFmpeg
- GStreamer + various codecs
- OpenH264
- MongoDB Client
- MSSQL Client
- MySQL Client
- PostgreSQL Client
- UnixODBC
- Git LFS

**Full list**: diffutils, ffmpeg, git-lfs, gstreamer1, gstreamer1-libav, gstreamer1-plugin-openh264, gstreamer1-plugins-base, gstreamer1-plugins-base-tools, hdf5, jq, lame, lcms2, libsndfile, llvm, llvm-devel, lz4, mongocli, mssql-tools18, mysql, nano, openh264, postgresql, tk, unixODBC, unixODBC-devel, zstd.

### Python Version

Whenever possible, applications/libraries bundles are available for both Python 3.9 and Python 3.11.

### Bundles

Bundles are sets of applications and libraries available to build the different images, depending of the functionalities you want. The following bundles are available in the latest release (2023c).

| Bundle name | Description | Included Libraries/Application |
|-------------------|--------------|--------------|
|Minimal|Minimal set of Python packages|pip~=23.2.1, setuptools~=68.1.2, wheel~=0.41.2|
|Data Science|Standard set of Data Science tools|Minimal + boto3~=1.28.40, codeflare-sdk~=0.7.1, kafka-python~=2.0.2, kubernetes~=25.3.0, matplotlib~=3.7.2, numpy~=1.24.4, pandas~=2.1.0, plotly~=5.16.1, scikit-learn~=1.3.0, scipy~=1.11.2, skl2onnx~=1.15.0, pyodbc~=4.0.39, pymongo~=4.5.0, psycopg~=3.1.10, mysql-connector-python~=8.0.33|
|PyTorch|PyTorch 2.0.1 + TorchVision|Data Science + torch==2.0.1+cu118, torchvision==0.15.2+cu118, tensorboard~=2.14.0|
|Tensorflow|Tensorflow 2.13.0 + TF2Onnx|Data Science + tensorflow~=2.13.0, tensorboard~=2.13.0, tf2onnx~=1.15.1|
|LangChain|PyTorch 2.0.1 + LangChain 0.0.285|PyTorch + langchain==0.0.285 (extras=["llms"]), text-generation = "~=0.6.0"|
|Langflow (Python 3.9 only)|PyTorch 2.0.1 + LangChain 0.0.256 + LangFlow 0.4.18|PyTorch + langchain==0.0.256 (extras=["llms"]), langflow==0.4.18, text-generation = "~=0.6.0"|
|OptaPy|OptaPy 9.37.0b0|Data Science + optapy==9.37.0b0 + Java 11|
|R|R 4.3.1|R-core, R-core-devel, R-java, R-Rcpp, R-highlight, R-littler, R-littler-examples|
|Spark|Spark 3.4.1|Data Science + pyspark~=3.4.1 + Spark 3.4.1 + Java 11|

### IDEs

The following IDEs are available:

- Jupyter ~=3.6.5
- VSCode 4.16.1
- RStudio 2023.06.01
- LangFlow 0.4.18 (will only work with the Langflow bundle)

## Building an image

If the pre-built images are not enough, you can easily create your own one with the available bundles and IDEs.

**Requirements**: [Podman](https://podman.io/) and [Skopeo](https://github.com/containers/skopeo/blob/main/install.md) have to be installed on your system to be able to use the wizard.

- Clone this repo.
- Launch the wizard: `./interactive-image-builder.sh`
- Answer a few questions.

Based on your choices, the wizard will create the recipe and give you the instructions on how to build the image.

## Development

For the development of new recipes for Bundles, IDEs,.. please see the [Development](DEVELOPMENT.md) page.
