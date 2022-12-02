# S2I Spark image

Notebook based on the Data Science notebook, adding:

* [Spark](https://spark.apache.org/) ([Github repo](https://github.com/apache/spark))

Apache Spark™ is a multi-language engine for executing data engineering, data science, and machine learning on single-node machines or clusters.

Build example from UBI9 with Python 3.9:

```bash
make ubi9-py39 BASE_IMAGE=localhost/s2i-datascience-notebook-ubi9-py39:0.0.1 TAG=0.0.1
```
