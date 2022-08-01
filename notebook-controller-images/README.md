# JupyterHub Custom Notebook Images

Those images were created to be used with ODH or RHODS with the **Kubeflow Notebook Controller as the launcher (from ODH1.4 and RHODS ...)**

## Non-CUDA images

(see next section for the images tree graphs)

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

### RStudio image

- RStudio with R 4.1: [s2i-rstudio-cs9-py39](https://quay.io/repository/guimou/s2i-rstudio-cs9-py39)

### Code-Server image

- Code-Server v4.5.1: [s2i-code-server-cs9-py39](https://quay.io/repository/guimou/s2i-code-server-cs9-py39)

## CUDA images

NOTE: the intermediate images from the CUDA build chain are not listed here, but available in the repos. Devel images may be needed to create further custom notebooks when building packages from source. See the tree graphs below for image names.

### S2I base CUDA images from UBI or CentOS Stream + Python

- Base CUDA s2i image based on UBI9 with Python 3.9: [s2i-base-cuda-ubi9-py39](https://quay.io/repository/guimou/s2i-base-ubi9-py39)
- Base CUDA s2i image based on CentOS Stream 9 with Python 3.9: [s2i-base-cuda-cs9-py39](https://quay.io/repository/guimou/s2i-base-cs9-py39)
- Base CUDA s2i image based on UBI8 with Python 3.8: [s2i-base-cuda-ubi8-py38](https://quay.io/repository/guimou/s2i-base-ubi8-py38)

### S2I CUDA Minimal Notebook images

Minimal JupyterLab Notebook image with CUDA, no additional Python packages, in different flavors (see above)

- Minimal JupyterLab Notebook image on UBI9 with Python 3.9: [s2i-minimal-cuda-notebook-ubi9-py39](https://quay.io/repository/guimou/s2i-minimal-cuda-notebook-ubi9-py39)
- Minimal JupyterLab Notebook image on UBI8 with Python 3.8: [s2i-minimal-cuda-notebook-ubi8-py38](https://quay.io/repository/guimou/s2i-minimal-cuda-notebook-ubi8-py38)

### S2I CUDA Datascience Notebook images

JupyterLab Notebook images with standard datascience packages, in different flavors (see above)

- Datascience Notebook image on UBI9 with Python 3.9: [s2i-datascience-cuda-notebook-ubi9-py39](https://quay.io/repository/guimou/s2i-datascience-cuda-notebook-ubi9-py39)
- Datascience Notebook image on UBI8 with Python 3.8: [s2i-datascience-cuda-notebook-ubi8-py38](https://quay.io/repository/guimou/s2i-datascience-cuda-notebook-ubi8-py38)

## Images build logic

Notes:

- All the images support S2I to be easily extended.
- UBI8 + Python 3.8/Python 3.9 are there for reference only and backward compatibility.
- New development and images will be on UBI9 + Python 3.9 base, or CentOS Stream 9 if UBI9 is not possible.
- For example, RStudio is built on a CentOS Stream 9 (and not UBI9) as many packages are missing to install R properly in the UBI lines (even with all base repos and epel enabled).

### UBI9 Python 3.9 Tree

```mermaid
graph TB
    subgraph Main Tree
    %% base
    ubi9py39(UBI9 Python 3.9)-->base-ubi9py39
    base-ubi9py39("Base<br/>(s2i-base-ubi9-py39)")

    %% Standard images
    base-ubi9py39-->minimal-ubi9py39
    minimal-ubi9py39("Minimal Notebook<br/>(s2i-minimal-notebook-ubi9-py39)")-->datascience-ubi9py39
    datascience-ubi9py39("DataScience Notebook<br/>(s2i-datascience-notebook-ubi9-py39)")
    base-ubi9py39-->code-server-ubi9py39
    code-server-ubi9py39("Code-Server<br/>(s2i-code-server-ubi9-py39)")

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
graph TB
    subgraph Main Tree
    %% base
    cs9(CentOS Stream 9)-->base-cs9py39
    base-cs9py39("Base<br/>(s2i-base-cs9-py39)")-->rstudio-cs9

    %% Standard images
    rstudio-cs9("RStudio<br/>(s2i-rstudio-cs9-py39)")

    %% CUDA images
    base-cs9py39-.->|Through the CUDA build chain|base-cuda-cs9py39
    base-cuda-cs9py39("Base CUDA<br/>(s2i-base-cuda-cs9-py39)")
    base-cuda-cs9py39-->pytorch-cuda-cs9py39
    pytorch-cuda-cs9py39("PyTorch CUDA<br/>(s2i-pytorch-cuda-cs9-py39)")
    end

    %% Links between the two graphs
    base-cs9py39-->base-cs9py39-cuda-base
    base-cs9py39-cuda-runtime-cudnn-->|Same image|base-cuda-cs9py39

    %% CUDA build chain
    subgraph CUDA Build Chain
    base-cs9py39-cuda-base("CUDA Base<br/>(s2i-base-cs9-py39-cuda-base)")-->base-cs9py39-cuda-runtime
    base-cs9py39-cuda-runtime("CUDA Runtime<br/>(s2i-base-cs9-py39-cuda-runtime)")-->base-cs9py39-cuda-runtime-cudnn
    base-cs9py39-cuda-runtime-cudnn("CUDA Runtime cuDNN<br/>(s2i-base-cs9-py39-cuda-runtime-cudnn)")

    %% CUDA Devel branch
    base-cs9py39-cuda-runtime-->base-cs9py39-cuda-devel
    base-cs9py39-cuda-devel("CUDA Devel<br/>(s2i-base-cs9-py39-cuda-devel)")-->base-cs9py39-cuda-devel-cudnn
    base-cs9py39-cuda-devel-cudnn("CUDA Devel cuDNN<br/>(s2i-base-cs9-py39-cuda-devel-cudnn)")
    base-cs9py39-cuda-devel-cudnn-.->|For source compiling<br/> and multilayer building|pytorch-cuda-cs9py39
    end
```

### UBI8 Python 3.8 Tree

```mermaid
graph TB
    subgraph Main Tree
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
