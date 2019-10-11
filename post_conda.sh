#!/usr/bin/env bash

jupyter labextension install --dev-build=False \
    @jupyterlab/hub-extension \
    @jupyter-widgets/jupyterlab-manager \
    @jupyter-widgets/jupyterlab-sidecar \
    @pyviz/jupyterlab_pyviz \
    dask-labextension \
    jupyterlab_bokeh \
    jupyter-leaflet
conda clean --all
jupyter lab clean 