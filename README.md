# Custom notebook images

*[See changelog](CHANGELOG.md)*

Various custom Jupyter Notebook Images to use with [Open Data Hub](http://opendatahub.io/) (ODH) or [Red Hat OpenShift Data Science](https://www.redhat.com/fr/technologies/cloud-computing/openshift/openshift-data-science) (RHODS).

Images are organized under two main folders:

* [jupyterhub-images](/jupyterhub-images): those images were created to be used with ODH or RHODS with JupyterHub as the launcher (up to ODH1.3 and first versions of RHODS). They are now all compatible with the Kubeflow Notebook Controller, so latest versions of ODH or RHODS!
* [notebook-controller-images](notebook-controller-images): those images were created to be used with ODH or RHODS with the Kubeflow Notebook Controller as the launcher exclusively (from ODH1.4 and RHODS ...).
