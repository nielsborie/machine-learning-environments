FROM continuumio/miniconda3

RUN conda install mamba -n base -c conda-forge

RUN conda create -n py39 python=3.9

# Make RUN commands use the new environment:
SHELL ["conda", "run", "--no-capture-output", "-n", "py39", "/bin/bash", "-c"]

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "py39", "python"]