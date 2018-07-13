# Copyright (c) Niels Borie.

FROM jupyter/tensorflow-notebook:5811dcb711ba

LABEL maintainer="Niels BORIE"

USER root

# --- Install python-tk htop python-boost
RUN apt-get update && \
    apt-get install -y --no-install-recommends python-tk software-properties-common htop libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --- Install dependency gcc/g++
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

# --- Install gcc/g++
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc-7 g++-7 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --- Update alternatives
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7

# --- Conda xgboost, lightgbm, catboost, h2o, gensim, mlxtend
RUN conda install --quiet --yes \
    'boost' \
    'lightgbm' \
    'xgboost' \
    'catboost' \
    'h2o' \
    'gensim' \
    'mlxtend' \
    'tabulate' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# --- Install vowpalwabbit, hyperopt, tpot, sklearn-deap, yellowbrick
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

