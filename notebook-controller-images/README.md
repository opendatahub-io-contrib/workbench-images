# JupyterHub Custom Notebook Images

Those images were created to be used with ODH or RHODS with the **Kubeflow Notebook Controller as the launcher (from ODH1.4 and RHODS ...)**

## Non-CUDA images

(see next section for the image trees)

### S2I base images from UBI or CentOS Stream + Python

- Base s2i image based on UBI9 with Python 3.9: [s2i-base-ubi9-py39](https://quay.io/repository/guimou/s2i-base-ubi9-py39)
- Base s2i image based on CentOS Stream 9 with Python 3.9: [s2i-base-cs9-py39](https://quay.io/repository/guimou/s2i-base-cs9-py39)
- Base s2i image based on UBI8 with Python 3.8: [s2i-base-ubi8-py38](https://quay.io/repository/guimou/s2i-base-ubi8-py38)

### S2I Minimal Notebook images

Minimal JupyterLab Notebook image, no additional Python packages, in different flavors (see above)

- Minimal JupyterLab Notebook image on UBI9 with Python 3.9: [s2i-minimal-notebook-ubi9-py39](https://quay.io/repository/guimou/s2i-minimal-notebook-ubi9-py39)
- Minimal JupyterLab Notebook image on UBI8 with Python 3.8: [s2i-minimal-notebook-ubi8-py38](https://quay.io/repository/guimou/s2i-minimal-notebook-ubi8-py38)

### S2I Datascience Notebook images

JupyterLab Notebook images with standard datascience packages, in different flavors (see above)

- Datascience Notebook image on UBI9 with Python 3.9: [s2i-datascience-notebook-ubi9-py39](https://quay.io/repository/guimou/s2i-datascience-notebook-ubi9-py39)
- Datascience Notebook image on UBI8 with Python 3.8: [s2i-datascience-notebook-ubi8-py38](https://quay.io/repository/guimou/s2i-datascience-notebook-ubi8-py38)

### RStudio images

- RStudio with R 4.1: [s2i-rstudio-cs9-py39](https://quay.io/repository/guimou/s2i-rstudio-cs9-py39)

## CUDA images

Coming soon...

## Images build logic

Notes:

- All the images support S2I to be easily extended.
- UBI8 + Python 3.8/Python 3.9 are there for reference only and backward compatibility.
- New development and images will be on UBI9 + Python 3.9 base, or CentOS Stream 9 if UBI9 is not possible.
- RStudio is built on a CentOS Stream 9 as packages are missing to install R properly in the UBI lines (even with all base repos and epel enabled).

### UBI9 Python 3.9 Tree

```mermaid
graph TB
    subgraph Main tree
    %% base
    ubi9py39(UBI9 Python 3.9)-->base-ubi9py39
    base-ubi9py39("Base<br/>(s2i-base-ubi9-py39)")

    %% Standard images
    base-ubi9py39-->minimal-ubi9py39
    minimal-ubi9py39("Minimal Notebook<br/>(s2i-minimal-notebook-ubi9-py39)")-->datascience-ubi9py39
    datascience-ubi9py39("DataScience Notebook<br/>(s2i-datascience-notebook-ubi9-py39)")

    %% CUDA images
    base-ubi9py39-.->|Through the CUDA build chain|base-cuda-ubi9py39
    base-cuda-ubi9py39("Base CUDA<br/>(s2i-base-cuda-ubi9-py39)")-->minimal-cuda-ubi9py39
    minimal-cuda-ubi9py39("Minimal CUDA Notebook<br/>(s2i-minimal-cuda-notebook-ubi9-py39)")-->datascience-cuda-ubi9py39
    datascience-cuda-ubi9py39("DataScience CUDA Notebook<br/>(s2i-datascience-cuda-notebook-ubi9-py39)")
    end

    %% Links between the two graphs
    base-ubi9py39-->base-ubi9py39-cuda-base
    base-ubi9py39-cuda-runtime-cudnn-->|Same image|base-cuda-ubi9py39

    %% CUDA build chain
    subgraph CUDA Build Chain
    base-ubi9py39-cuda-base("CUDA Base<br/>(s2i-base-ubi9-py39-cuda-base)")-->base-ubi9py39-cuda-runtime
    base-ubi9py39-cuda-runtime("CUDA Runtime<br/>(s2i-base-ubi9-py39-cuda-runtime)")-->base-ubi9py39-cuda-runtime-cudnn
    base-ubi9py39-cuda-runtime-cudnn("CUDA Runtime cuDNN<br/>(s2i-base-ubi9-py39-cuda-runtime-cudnn)")

    %% CUDA Devel branch
    base-ubi9py39-cuda-runtime-->base-ubi9py39-cuda-devel
    base-ubi9py39-cuda-devel("CUDA Devel<br/>(s2i-base-ubi9-py39-cuda-devel)")-->base-ubi9py39-cuda-devel-cudnn
    base-ubi9py39-cuda-devel-cudnn("CUDA Devel cuDNN<br/>(s2i-base-ubi9-py39-cuda-devel-cudnn)")
    end

```

### CentOS Stream 9 Python 3.9 Tree

```mermaid
graph LR
    subgraph CentOS Stream 9 Python 3.9 Family
    centosstream9(CentOS Stream 9)-->base-centosstream9py39
    base-centosstream9py39("Base<br/>(c9s py39)")-->rstudio-ubi8
    rstudio-ubi8("RStudio<br/>(c9s py39)")
    end
```

### UBI8 Python 3.8 Tree

```mermaid
graph TB
    subgraph Main tree
    %% base
    ubi8py38(UBI8 Python 3.8)-->base-ubi8py38
    base-ubi8py38("Base<br/>(s2i-base-ubi8-py38)")

    %% Standard images
    base-ubi8py38-->minimal-ubi8py38
    minimal-ubi8py38("Minimal Notebook<br/>(s2i-minimal-notebook-ubi8-py38)")-->datascience-ubi8py38
    datascience-ubi8py38("DataScience Notebook<br/>(s2i-datascience-notebook-ubi8-py38)")

    %% CUDA images
    base-ubi8py38-.->|Through the CUDA build chain|base-cuda-ubi8py38
    base-cuda-ubi8py38("Base CUDA<br/>(s2i-base-cuda-ubi8-py38)")-->minimal-cuda-ubi8py38
    minimal-cuda-ubi8py38("Minimal CUDA Notebook<br/>(s2i-minimal-cuda-notebook-ubi8-py38)")-->datascience-cuda-ubi8py38
    datascience-cuda-ubi8py38("DataScience CUDA Notebook<br/>(s2i-datascience-cuda-notebook-ubi8-py38)")
    end

    %% Links between the two graphs
    base-ubi8py38-->base-ubi8py38-cuda-base
    base-ubi8py38-cuda-runtime-cudnn-->|Same image|base-cuda-ubi8py38

    %% CUDA build chain
    subgraph CUDA Build Chain
    base-ubi8py38-cuda-base("CUDA Base<br/>(s2i-base-ubi8-py38-cuda-base)")-->base-ubi8py38-cuda-runtime
    base-ubi8py38-cuda-runtime("CUDA Runtime<br/>(s2i-base-ubi8-py38-cuda-runtime)")-->base-ubi8py38-cuda-runtime-cudnn
    base-ubi8py38-cuda-runtime-cudnn("CUDA Runtime cuDNN<br/>(s2i-base-ubi8-py38-cuda-runtime-cudnn)")

    %% CUDA Devel branch
    base-ubi8py38-cuda-runtime-->base-ubi8py38-cuda-devel
    base-ubi8py38-cuda-devel("CUDA Devel<br/>(s2i-base-ubi8-py38-cuda-devel)")-->base-ubi8py38-cuda-devel-cudnn
    base-ubi8py38-cuda-devel-cudnn("CUDA Devel cuDNN<br/>(s2i-base-ubi8-py38-cuda-devel-cudnn)")
    end

```

### UBI8 Python 3.9 Tree

```mermaid
graph LR
    subgraph UBI8 Python 3.9 Family
    ubi8py39(UBI8 Python 3.9)-->base-ubi8py39
    base-ubi8py39("Base<br/>(ubi8 py39)")-->minimalnb-ubi8py39
    base-ubi8py39-->vscode-ubi8
    minimalnb-ubi8py39("Minimal Notebook<br/>(ubi8 py39)")-->datascience-ubi8py39
    datascience-ubi8py39("DataScience Notebook<br/>(ubi8 py39)")
    vscode-ubi8("VSCode<br/>(ubi8 py39)")
    end
```
