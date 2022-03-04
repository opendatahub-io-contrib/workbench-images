import setuptools

setuptools.setup(
    name="customlauncher",
    version='0.1',
    url="https://github.com/",
    author="Guillaume Moutier based on Project Jupyter Contributors",
    description="gmoutier@redhat.com",
    packages=['customlauncher'],
	keywords=['Jupyter'],
	classifiers=['Framework :: Jupyter'],
    install_requires=[
        'jupyter-server-proxy'
    ],
    entry_points={
        'jupyter_serverproxy_servers': [
            'rstudio = customlauncher:setup_rstudio',
        ]
    },
    package_data={
        'customlauncher': ['icons/*'],
    },
)
