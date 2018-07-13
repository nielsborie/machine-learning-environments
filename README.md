# ml-docker
The ml-docker is a ready-to-run Docker image containing a large number of (python compatible)machine learning libraries.

---

## What's in there? 

* Jupyter Notebook
* Conda Python 3.6.x
* Python Machine Learning : numpy, pandas, matplotlib, scipy, seaborn, scikit-learn
* Python Deep Learning : TensorFlow+Keras

---

## How to run it? 
##### You can pull the already built image
* Available here : 

```bash
docker pull 
```

##### And run it
###### Basic run
```bash
docker run --name ML-env -p 8887:8888 nielsborie/ml-docker
```
###### in detached mode (-d)
```bash
docker run --name ML-env -d -p 8887:8888 nielsborie/ml-docker
```
###### start & stop
```bash
docker start ML-env
docker stop ML-env
```
###### If you want a real password (and avoid copy/paste token step...) 
```bash
docker run --name ML-env -d -p 8887:8888 -d nielsborie/ml-docker start-notebook.sh --NotebookApp.password="sha1:ff6a3551e13f:c3edadaa0cb4bed02293c96c14d755611069a4ba" 
```
**default password = bleckwen**

##### If you want to share your current working folder, you can map it with "-v" or "--volume"
```bash
docker run --name ML-env -p 8887:8888 -d -v </your-directory/>:/home/jovyan/work/ -e NB_UID=<your-UID/> --user root nielsborie/ml-docker start-notebook.sh --NotebookApp.password="sha1:ff6a3551e13f:c3edadaa0cb4bed02293c96c14d755611069a4ba"
```

###### If you need to change the password check : 
[Jupyter notebook documentation](http://jupyter-notebook.readthedocs.io/en/stable/public_server.html)

###### You can find additionnal info here : 
[Jupyter docker documentation](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html?highlight=password)

---

## How to build it? 
#### First clone the repository
```bash
git clone https://github.com/nielsborie/ml-docker.git
cd /ml-docker
```
#### Basic building : 
```bash
docker build . -t ml-docker
```

#### If you have a proxy issue execute the following line : 
```bash
docker build . --no-cache --force-rm --build-arg http_proxy=http://172.16.99.9:3129 --build-arg https_proxy=http://172.16.99.9:3129 --build-arg no_proxy=localhost,127.0.0.1,172.26.1.100,172.26.1.107,.an.local -t ml-docker
```

