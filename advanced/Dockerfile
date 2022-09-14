# Copyright (c) Niels Borie.

FROM nielsborie/base-py39

LABEL maintainer="Niels BORIE"

# --- Install h2o
RUN pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

# Create the environment:
COPY environment.yml .
RUN mamba env update --name py39 --file environment.yml --prune

# clean up pip cache
RUN rm -rf /root/.cache/pip/*