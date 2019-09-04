# Makefiles utilities
Make utilities to be reused by Makefiles.

### Goal

Create reusable Makefiles that can easily adapt using environment variables or function parameters.

### Using the files

1. Clone to track `master` branch
1. Initiate the module a register on your git
1. Fetch contents
1. Stage changes with the configurations
1. Commit it to persist the configuration in your repository

```bash
git submodule add -b master https://github.com/milhomem/makefiles.git makefiles
git submodule init
git submodule update
git add makefiles .gitmodules
git commit
```

### Usage

Creare your make file and include all utilities from this project and start using it on your recipes.

```makefile
#!/usr/bin/make

SHELL := /bin/bash

default-recipe: envfile ## Build this project using docker; Updates your defined .env variables

-include .env
include makefiles/*.mk

...
```

### Functions & Recipes

#### Feature list:

Name | Type | Purpose
---- | ---- |-------
help | Phony | Auto generates a help menu from comments
.env | File Recipe | Creates a combined `.env` file from a `.env.dist` file and the current `.env` file
env-to-envfile | Phony | Dumps the environment variables to a `.env` file scoped to the `.env.dist` variables
docker-build | Phony | Builds a `Dockerfile` and tag it using the `docker` binary
docker-build-push | Phony | Pushes a recently build to a remote registry using the `docker` binary
k8s-minikube-volume | Phony | Mounts a local volume inside `minikube`
k8s-up | Phony | Applies a kubernetes folder of file using `kubectl` 
k8s-down | Phony | Deletes kubernetes resources from specifications using `kubectl`
k8s_minikube_open_service() | Function | Opens a given service name on your browser using `minikube`
k8s_jump() | Function | Forward a given port from a given service using `kubectl`
k8s_exec() | Function | Execute a _command_ using `kubectl` on a running container
k8s-registry | Phony | Create a new private registry entry using `kubectl` 
vendor | Folder Recipe | Uses `composer` to create the dependencies folder called `vendor` 
php-lint | Phony | Uses `phpcs` as a `vendor` dependency to lint based on `phpcs.xml` specs

#### Utils

__`help` recipe:__

```bash
make help
```

It's an easy way for document a help explanation for your Makefile recipes. All you have to do is
to add a double hashtag `##` after a recipe line and the recipe will be added to the help menu.

E.g. [this file](examples/help/Makefile)
```bash
help                           This help dialog.
install                        This text will be added to the help section of the install recipe
```

`envfile` recipe:

```bash
make .env
```

Creates a combined `.env` file based on a dist file. It's useful to keep the distributed values
up-to-date while keeping previous values already defined locally. 

E.g. [this file](examples/envfile/Makefile)
```bash
$ cat .env
PREVIOUS=KEY
VALUE=KEEP

$ cat .env.dist
VALUE='TO NOT BE MERGED'
MERGED='FROM DISTRIBUTED'

$ make .env

$ cat .env
MERGED=FROM DISTRIBUTED
PREVIOUS=KEY
VALUE=KEEP
```

`env-to-envfile` recipe:

//TODO

#### Docker

docker-build

//TODO

docker-build-push

//TODO

#### Kubernetes

k8s-minikube-volume

//TODO

k8s-up

//TODO
 
k8s-down

//TODO

k8s_minikube_open_service()

//TODO

k8s_jump()

//TODO

k8s_exec()

//TODO

k8s-registry

//TODO

#### PHP
 
vendor

//TODO
 
php-lint

//TODO
