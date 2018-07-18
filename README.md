# ml-docker
An all-in-one Docker image for machine learning. Contains all the popular python machine learning librairies (scikit-learn, xgboost, LightGBM, gensim,Keras, etc...).
---

## Specs
This is what you get out of the box when you create a container with the provided image/Dockerfile:

* Ubuntu 18.04
* GCC/G++ 7
* Java 8 
* [Jupyter Notebook](https://hub.docker.com/r/jupyter/tensorflow-notebook/)
* [Conda Python 3.6.x](https://www.anaconda.com/what-is-anaconda/)
* Python Data Analysis : [Numpy](http://www.numpy.org/), [Pandas](http://pandas.pydata.org/), [Matplotlib](http://matplotlib.org/), [SciPy](https://www.scipy.org/), [Seaborn](https://seaborn.pydata.org/), [Yellowbrick](http://www.scikit-yb.org/en/latest/)
* Python Machine Learning : [scikit-learn](https://www.anaconda.com/what-is-anaconda/), [xgboost](https://xgboost.readthedocs.io/en/latest/model.html), [LightGBM](https://lightgbm.readthedocs.io/en/latest/index.html), [Catboost](https://github.com/catboost/catboost), [mlxtend](https://github.com/rasbt/mlxtend)
* Python NLP : [gensim](https://radimrehurek.com/gensim/), [spaCy](https://github.com/explosion/spaCy)
* Python Auto-ML : [TPOT](https://epistasislab.github.io/tpot/), [h2o-automl](http://docs.h2o.ai/h2o/latest-stable/h2o-docs/automl.html)
* Python Hyper-Optimizer : [hyperopt](https://github.com/hyperopt/hyperopt), [sklearn-deap](https://github.com/rsteca/sklearn-deap)
* Python Deep Learning : [Tensorflow](https://www.tensorflow.org/), [Keras](http://keras.io/)
* h2o plateform : [h2o](https://www.h2o.ai/)

---
## Setup
### Prerequisites
Install Docker following the installation guide for your platform: [here](https://docs.docker.com/engine/installation/)

---

## Obtaining the Docker image
### Option 1: Download the Docker image from Docker Hub
* Available here : (https://hub.docker.com/r/nielsborie/ml-docker/)

```bash
docker pull nielsborie/ml-docker
```
### Option 2: Build the Docker image locally
#### First clone the repository
```bash
git clone https://github.com/nielsborie/ml-docker.git
cd /ml-docker
```

##### Basic building : 
```bash
docker build . -t ml-docker
```

##### If you have a proxy issue execute the following line : 
```bash
docker build . --no-cache --force-rm --build-arg http_proxy=<proxy> --build-arg https_proxy=<proxy> --build-arg no_proxy=localhost,<proxy>,<proxy>,.an.local -t ml-docker
```

## Running the Docker image as a Container
Once we've built the image, we have all the frameworks we need installed in it. We can now spin up one or more containers using this image.

### Basic run
```bash
docker run --name ML-env -p 8887:8888 nielsborie/ml-docker
```

<p align="center">
<img src="https://github.com/nielsborie/ml-docker/blob/master/view/docker_run.PNG" width=500 />
</p>


### in detached mode (-d)
```bash
docker run --name ML-env -d -p 8887:8888 nielsborie/ml-docker
```
### start & stop
```bash
docker start ML-env
docker stop ML-env
```

By default the image automatically launches a jupyter notebook on port 8887 of your localhost. 

<p align="center">
<img src="https://github.com/nielsborie/ml-docker/blob/master/view/jupyter.PNG" width=500 />
</p>

### to enter in the running container
```bash
docker exec -it ML-env /bin/bash
```
<p align="center">
<img src="https://github.com/nielsborie/ml-docker/blob/master/view/docker_exec.PNG" width=500 />
</p>

## To go further 
##### If you want a real password (and avoid copy/paste token step...) 
```bash
docker run --name ML-env -d -p 8887:8888 -d nielsborie/ml-docker start-notebook.sh --NotebookApp.password="sha1:b6dba7097c97:7bded30fcbd5089adb3b63496d5e68921e102a5f" 
```
**default password = admin**

##### If you want to share your current working folder, you can map it with "-v" or "--volume"
```bash
docker run --name ML-env -p 8887:8888 -d -v /sharedfolder:/home/jovyan/work/ -e NB_UID=<your-UID> --user root nielsborie/ml-docker start-notebook.sh --NotebookApp.password="sha1:b6dba7097c97:7bded30fcbd5089adb3b63496d5e68921e102a5f"
```
---


| Parameter      | Explanation |
|----------------|-------------|
|`-it`             | This creates an interactive terminal you can use to iteract with your container |
|`--name`             | This set a name to our container, in our case we use `ML-env` but we can change it |
|`-p 8887:8888`    | This exposes the ports inside the container so they can be accessed from the host. The format is `-p <host-port>:<container-port>`. The default jupyter notebook runs on port 8888 |
|`-v /sharedfolder:/root/sharedfolder/` | This shares the folder `/sharedfolder` on your host machine to `/home/jovyan/work/sharedfolder/` inside your container. Any data written to this folder by the container will be persistent. You can modify this to anything of the format `-v /local/shared/folder:/shared/folder/in/container/`
|`nielsborie/ml-docker`   | This the image that you want to run. The format is `image:tag`. In our case, we use the image `ml-docker` and tag `latest` |
|`start-notebook.sh --NotebookApp.password`   | It allows to launch the jupyter with a password already configured to `bleckwen` |

---


##### If you need to change the password check : 
[Jupyter notebook documentation](http://jupyter-notebook.readthedocs.io/en/stable/public_server.html)

##### You can find additionnal info here : 
[Jupyter docker documentation](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html?highlight=password)

---

