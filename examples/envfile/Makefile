#!/usr/bin/make
include ../../*.mk

-include .env

install:
	@echo cat .env

env : SHELL := $(DOTENV_SHELL)
env:
	@env | grep -f <(sed 's/=.*//' .env)
