# Copyright (c) Niels Borie.

FROM jupyter/scipy-notebook

LABEL maintainer="Niels BORIE"

USER root

# --- Install python-tk htop python-boost
RUN apt-get update && \
    apt-get install -y --no-install-recommends python-tk software-properties-common htop libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# --- Install h2o
RUN $CONDA_DIR/bin/python -m pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

# --- Conda xgboost, lightgbm, catboost, h2o, gensim, mlxtend
RUN mamba install --quiet --yes \
    'boost' \
    'lightgbm' \
    'xgboost' \
    'catboost' \
    'gensim' \
    'mlxtend' \
    'tabulate' && \
    mamba clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


# --- Install vowpalwabbit, hyperopt, tpot, sklearn-deap, yellowbrick, spacy
RUN $CONDA_DIR/bin/python -m pip install vowpalwabbit \
					 hyperopt \
					 deap \
					 update_checker \
					 tqdm \
					 stopit \
					 scikit-mdr \
					 skrebate \
					 tpot \
					 sklearn-deap \
					 yellowbrick \
					 spacy \
					 gplearn \
					 kmapper \
					 shap \
					 lime 

###########
#
# Add some usefull libs, inspired by kaggle's Dockerfile
# CREDITS : https://hub.docker.com/r/kaggle/python/dockerfile
#
###########
#RUN $CONDA_DIR/bin/python -m pip install --upgrade mpld3
RUN $CONDA_DIR/bin/python -m pip install mplleaflet \
					 gpxpy \
					 arrow \
					 sexmachine \
					 Geohash \
					 haversine \
					 toolz cytoolz \
					 sacred \
					 plotly \
					 git+https://github.com/nicta/dora.git \
					 git+https://github.com/hyperopt/hyperopt.git \
# tflean. Deep learning library featuring a higher-level API for TensorFlow. http://tflearn.org
					 git+https://github.com/tflearn/tflearn.git \
					 fitter \
					 langid \
# Delorean. Useful for dealing with datetime
					 delorean \
					 trueskill \
					 heamy \
					 vida \
# Useful data exploration libraries (for missing data and generating reports)
					 missingno \
					 pandas-profiling \
					 s2sphere
###########
#
# Issue #1
# pandas.read_hdf
#
###########
RUN $CONDA_DIR/bin/python -m pip install --upgrade tables

# clean up pip cache
RUN rm -rf /root/.cache/pip/*
