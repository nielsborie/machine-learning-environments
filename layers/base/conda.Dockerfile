FROM continuumio/miniconda3

ARG PYTHON_VERSION
ARG PYTHON_RELEASE_VERSION

ENV ENV_NAME=py${PYTHON_VERSION}

COPY environment.yml /opt/environment.yml

RUN /opt/conda/bin/conda create -n py${PYTHON_VERSION} python=${PYTHON_RELEASE_VERSION} -y && \
    /opt/conda/bin/conda init bash && \
    /opt/conda/bin/conda env update -n py${PYTHON_VERSION} -f /opt/environment.yml && \
    echo "conda activate py${PYTHON_VERSION}" >> ~/.bashrc && \
    /opt/conda/bin/conda clean --all --yes

ENV PATH=/opt/conda/envs/py${PYTHON_VERSION}/bin:$PATH

ENTRYPOINT ["/bin/bash"]