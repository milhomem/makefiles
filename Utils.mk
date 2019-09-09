.PHONY : env-to-envfile help

help: ## This help dialog.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 | "sort -u"}' $(MAKEFILE_LIST)

map = $(foreach a,$(2),$(call $(1),$(a)))

random_string = $(shell cat /dev/urandom | LC_CTYPE=C tr -dc 'a-z0-9' | fold -w $(1) | head -n 1)

# Reduces the amount of variables exported to the environment
.env : SHELL := env -i bash
.env : .SHELLFLAGS := +o allexport -c
.env: .env.dist
#.env: Pesudocode
# Checks and copy distribution in the first time
# Load distribution .env
# Load .env and override variables from distribution
# Add new variables from distribution to the .env file
# Reprint .env to _add quotes_ but keeping the same order and comments
# Quotes on .env will simplify the use or _source aka ._
ifeq ("$(wildcard .env)","")
	cp $^ .env
endif
ifneq ("$(wildcard .env.swp)","")
	$(error Found a swap file by the name .env.swp)
endif
	@$(call envfile_to_env, .env.dist); \
	 $(call envfile_to_env, .env); \
	 env -u PWD -u SHLVL -u _ | join -v 2 -t = -j 1 <(sort .env) <(sort -) >> .env; \
	 awk -F = '($$1 in ENVIRON) {printf "%s=\"%s\"\n", $$1, ENVIRON[$$1]} !($$1 in ENVIRON) {print}' .env > $(call swap_file,.env)

# Inspired by https://github.com/madcoda/dotenv-shell/blob/master/dotenv.sh
# Removes quotes and export vars, does not fails when dist has no quotes
envfile_to_env = while IFS='=' read -r key temp || [ -n "$$key" ]; \
	do \
		value=$$(eval echo "$$temp"); \
        eval export "$$key='$$value'"; \
	done < $(1) > /dev/null

swap_file = $(1).swp && mv $(1){.swp,}

env-to-envfile : SHELL := env bash
env-to-envfile: .env.dist ## Dumps the environment variables to a `.env` file scoped to the `.env.dist` variables and its defaults
ifneq ("$(wildcard .env)","")
	$(error File .env already exists!)
endif
	@$(call envfile_to_env, .env.dist); env -u PWD -u SHLVL -u _ | awk -F = '$$1 in ENVIRON {printf "%s=\"%s\"\n", $$1, ENVIRON[$$1]}' > .env

# Shell that exports .env vars to all recipe commands
DOTENV_SHELL := BASH_ENV=.env env bash -o allexport

git_add_remote = git remote set-url $1 $2 || git remote add --fetch $1 $2
