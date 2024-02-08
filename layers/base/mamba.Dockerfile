FROM mambaorg/micromamba

ARG PYTHON_VERSION
ARG PYTHON_RELEASE_VERSION

ENV ENV_NAME=py${PYTHON_VERSION}

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /opt/environment.yml

RUN micromamba config set extract_threads 1 && \
    micromamba config append channels conda-forge && \
    micromamba create -n ${ENV_NAME} python=${PYTHON_RELEASE_VERSION} -y && \
    micromamba install -y -n ${ENV_NAME} -f /opt/environment.yml && \
    echo "micromamba activate ${ENV_NAME}" >> ~/.bashrc && \
    micromamba clean --all --yes

ENV PATH /opt/conda/envs/${ENV_NAME}/bin:$PATH

ENTRYPOINT ["/bin/bash"]