# Define build arguments
ARG PYTHON_VERSION
ARG PYTHON_RELEASE_VERSION
ARG IMAGE_VERSION
ARG BUILDER

FROM nielsborie/machine-learning-environments:base-${BUILDER}-py${PYTHON_VERSION}-${IMAGE_VERSION} as base

ARG PYTHON_VERSION
ARG PYTHON_RELEASE_VERSION
ENV ENV_NAME=py${PYTHON_VERSION}

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml .
RUN sed -i "s/python=[0-9]\+\.[0-9]\+\.[0-9]\+/python=${PYTHON_RELEASE_VERSION}/" environment.yml
RUN micromamba install -y -n ${ENV_NAME} -f environment.yml

# Stage 2: Java installation
FROM openjdk:17-jdk-slim as java_backend

# Set Java in PATH
ENV PATH="/usr/local/openjdk-17/bin:${PATH}"

# Stage 3: Final stage
FROM base

# Copy Java binaries from java_backend stage
COPY --from=java_backend /usr/local/openjdk-17 /opt/openjdk-17

# Set Java in PATH and LD_LIBRARY_PATH
ENV PATH="/opt/openjdk-17/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/openjdk-17/lib/server"

# Install additional Python packages and configure Java
RUN micromamba run -n py3.9 pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

USER root
RUN rm -rf /root/.cache/pip/*
USER $MAMBA_USER
