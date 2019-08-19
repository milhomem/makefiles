.PHONY : php-lint

COMPOSER ?= $(shell command -v composer 2> /dev/null || echo composer)
COMPOSER_HOME ?= $(HOME)/.composer
COMPOSER_ARGS ?= --no-scripts
vendor: composer.json composer.lock vendor/autoload.php
	@echo "Missing dependency $@"
	COMPOSER_HOME=$(COMPOSER_HOME) $(COMPOSER) install $(COMPOSER_ARGS)

vendor/autoload.php:
	@echo "Missing essential dependency $@, cleaning incomplete vendor folder"
	-rm -rf vendor

php-lint: vendor
	./vendor/bin/phpcs
