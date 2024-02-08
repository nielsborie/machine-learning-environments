FROM continuumio/miniconda3

ARG PYTHON_VERSION=3.9
ARG PYTHON_RELEASE_VERSION=3.9.18

ENV ENV_NAME=py${PYTHON_VERSION}

RUN conda update conda && conda install mamba -n base -c conda-forge

COPY environment.yml /opt/environment.yml

RUN conda create -n ${ENV_NAME} python=${PYTHON_RELEASE_VERSION} -y

RUN conda env update -n ${ENV_NAME} -f /opt/environment.yml && \
    conda clean --all --yes

RUN echo "source activate ${ENV_NAME}" > ~/.bashrc
ENV PATH /opt/conda/envs/${ENV_NAME}/bin:$PATH

ENTRYPOINT ["/bin/bash"]