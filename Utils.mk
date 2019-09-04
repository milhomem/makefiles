.PHONY : envfile env-to-envfile help

help: ## This help dialog.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 | "sort -u"}' $(MAKEFILE_LIST)

map = $(foreach a,$(2),$(call $(1),$(a)))
random_string = $(shell cat /dev/urandom | LC_CTYPE=C tr -dc 'a-z0-9' | fold -w $(1) | head -n 1)

.env: .env.dist
ifeq ("$(wildcard .env)","")
	cp $^ .env
endif
	@env -i bash -c 'set -a; source .env.dist; source .env; env -u PWD -u SHLVL -u _ | awk -F = '\''{printf "%s=\"%s\"\n", $$1, ENVIRON[$$1]}'\'' > .env'

env-to-envfile: .env.dist
ifneq ("$(wildcard .env)","")
	$(error File .env already exists!)
endif
	@env -i bash -c 'set -a; source .env.dist; env -u PWD -u SHLVL -u _' | awk -F = '$$1 in ENVIRON {printf "%s=\"%s\"\n", $$1, ENVIRON[$$1]}' > .env

git_add_remote = git remote set-url $1 $2 || git remote add --fetch $1 $2
