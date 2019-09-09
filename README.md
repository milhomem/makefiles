# Makefiles utilities
__Make__ recipes, functions, and variables to be reused by Makefiles __with environment variables__.

### Goal

- Create reusable Makefiles that can easily adapt using environment variables or function parameters.

- Secondary goal
  -  Create an archive of Makefile tips and tricks by example that can be replicated.

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

.DEFAULT_GOAL := help
SHELL := /bin/bash

include makefiles/*.mk
-include .env

test : SHELL := $(DOTENV_SHELL)
test:
...
```

### Functions & Recipes

#### Feature list:

Name | Type | Purpose
---- | ---- |-------
help | Phony | Auto generates a help menu from comments
.env | File Recipe | Creates a combined `.env` file from a `.env.dist` file and the current `.env` file
env-to-envfile | Phony | Dumps the environment variables to a `.env` file scoped to the `.env.dist` variables and its defaults
docker-build | Phony | Builds a `Dockerfile` and tag it using the `docker` binary
docker-build-push | Phony | Pushes a recently build to a remote registry using the `docker` binary
docker_run | Function | Runs a command inside a docker image
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

__`docker_run` function:__

_positional parameters_: command, image, flags 

Composes a Docker run command useful for once off tasks. 
It will remove the container by default and run it interactively with tty.

_Try to avoid using this function everywhere to avoid interdependency on Docker._ 

E.g. [this file]() //TODO

```makefile
ssh:
	$(call docker_run, bash, busybox, -v $$PWD:/app -it)
```

> __Attention__: the _-it_ flag is for commands that need to emulate a terminal

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
