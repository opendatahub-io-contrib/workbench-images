# Spark/PySpark image

This is the datascience notebook version, enhanced with Spark capabilities.

## Standard (local) use

You can use it as a standard notebook and run Spark/PySpark code with a local Spark.

## Spark-submit to Kubernetes

Spark has builtin kubernetes support, so you can directly launch a Spark job or a Spark cluster from your notebook. This only requires to setup specific rights for the ServiceAccount that will be used to launch the driver and/or executor pods.

In the `example` folder you will find:

* `rbac.yam`: this defines a role that you can create in the namespace where your notebook is running (default `rhods-notebooks`), and a RoleBinding that applies this role to the ServiceAccount used to launch the driver and the executor. To enable this feature, you only have to change the `serviceaccount_name` entries by the name of the ServiceAccount used to launch your notebook. With recent versions of ODH or RHODS, this will be something like `jupyter-nb-username`, with the username part being the name with which you are authenticated. You can also apply the Role to groups if you want to enable the feature for multiple users at once.
* Two notebooks with standard Spark (jars), and PySpark examples. They are launching spark-submit commands in client mode. As the driver is running directly inside the container image, executors are automatically shut down when the notebook (or the kernel) is stopped, allowing for auto-cleaning if you forget to shut down your spark instance.

Note: as the Role can be applied on a per-user or per-group basis, you can control who can launch Spark jobs like this. Also, you can enable it in some specific namespaces only (Workspace from Data Science Projects feature), then even set quotas on this namespace to prevent people consuming too many resources.
