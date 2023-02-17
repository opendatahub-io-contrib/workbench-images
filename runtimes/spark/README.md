# Spark runtime image

Runtime based on the Data Science runtime, adding:

* [Spark](https://spark.apache.org/) ([Github repo](https://github.com/apache/spark))

Apache Spark™ is a multi-language engine for executing data engineering, data science, and machine learning on single-node machines or clusters.

## Standard images

Build example from UBI9 with Python 3.9:

```bash
make ubi9-py39 RELEASE=dev DATE=20230101
```

## CUDA images

Build example from UBI9 with Python 3.9 with CUDA:

```bash
make cuda-ubi9-py39 RELEASE=dev DATE=20230101
```
