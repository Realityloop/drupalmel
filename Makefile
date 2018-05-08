.DEFAULT_GOAL := help
.PHONY: build clean down help up install


# TARGETS

## Ensure that the project has a .env file.
.env:
	@if [ ! -e .env ] ; then \
		echo "\n${GREEN}>>> Creating .env file...${RESET}\n" ; \
		echo "$$ ${YELLOW}cp .env-example .env${RESET}\n" ; \
		cp .env-example .env ; \
	fi

## Build composer dependencies.
build: .env up
	$(call title,Installing composer dependencies)
	$(call exec,docker-compose exec php composer install)

## Remove containers and build files.
clean: clean-docker clean-backend clean-frontend

## Remove backend build files.
clean-backend:
	$(call title,Removing backend build files)
	$(call exec,cd backend && rm -rf bin vendor web/core web/modules/contrib web/themes/contrib web/profiles/contrib web/libraries)

## Remove docker containers.
clean-docker: down
	$(call title,Removing docker containers)
	$(call exec,docker-compose down -v)

## Remove frontend build files.
clean-frontend:
	$(call title,Removing frontend build files)
	$(call exec,cd frontend && rm -rf .nuxt dist node_modules)

## Stop docker containers.
down: .env
	$(call title,Stopping docker containers)
	$(call exec,docker-compose stop)

## Display this help message.
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Install Drupal.
install: build
	$(call title,Installing Drupal)
	$(call exec,docker-compose exec php drush --root=/var/www/html/web -y si contenta_jsonapi install_configure_form.include_recipes_magazin=NULL)

## Display docker logs.
logs: up
	$(call title,Displaying docker logs)
	$(call exec,docker-compose logs --follow)

## Start docker containers.
up: .env
	$(call title,Starting docker containers)
	$(call exec,docker-compose up -d --remove-orphans)


# VARIABLES.

## Colors for output text.

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

## Help variables.

TARGET_MAX_CHAR_NUM=20


# FUNCTIONS.

## Execute command and display executed command to user.
define exec
	@echo "$$ ${YELLOW}${1}${RESET}\n" && $1
endef

## Display the target title to user.
define title
	@echo "\n${GREEN}>>> ${1}...${RESET}\n"
endef
