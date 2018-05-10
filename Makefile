include .env

.DEFAULT_GOAL := help
.PHONY: build clean clean-backend clean-docker clean-frontend down drush drupal help init-env install lint lint-backend lint-frontend logs up

# TARGETS

## Build composer dependencies.
build: up
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
down:
	$(call title,Stopping docker containers)
	$(call exec,docker-compose stop)

## Execute a Drupal Console command.
drupal:
	$(call title,Executing Drupal Console command inside php container)
	$(call exec,docker-compose exec php drupal --root=$(DRUPAL_ROOT) $(filter-out $@,$(MAKECMDGOALS)))

## Execute a Drush (DRUpal SHell) command.
drush:
	$(call title,Executing Drush command inside php container)
	$(call exec,docker-compose exec php drush -r $(DRUPAL_ROOT) -l http://cms.$(PROJECT_BASE_URL) $(filter-out $@,$(MAKECMDGOALS)))

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

## Initialises projects .env file.
init-env:
	@if [ ! -e .env ] ; then \
		printf "\n${GREEN}>>> Creating .env file...${RESET}\n" ; \
		printf "$$ ${YELLOW}cp .env-example .env${RESET}\n" ; \
		cp .env-example .env ; \
	fi

## Install Drupal.
install: init-env build
	$(call title,Installing Drupal)
	$(call exec,docker-compose exec php drush --root=$(DRUPAL_ROOT) -y si contenta_jsonapi install_configure_form.include_recipes_magazin=NULL)

	$(call title,Importing Meetup.com events)
	$(call exec,docker-compose exec php drush --root=$(DRUPAL_ROOT) cron)
	$(call exec,docker-compose exec php drush --root=$(DRUPAL_ROOT) queue-run drupalmel_meetup_events_queue)

	$(call title,Installation complete)
	@printf "${GREEN}Frontend :${RESET} http://$(PROJECT_BASE_URL)"
	@printf "${GREEN}Backend  :${RESET} $(shell docker-compose exec php drush --root=$(DRUPAL_ROOT) -l http://cms.$(PROJECT_BASE_URL) uli)*"
	@printf "${GREEN}MailHog  :${RESET} http://mailhog.$(PROJECT_BASE_URL)"
	@printf "\n* One time login link."

## Checking project coding standards.
lint: lint-backend lint-frontend

## Check backend coding standards.
lint-backend:
	$(call title,Checking PHP coding standards)
	$(call exec,docker-compose exec php phpcs)

## Check frontend coding standards.
lint-frontend:
	$(call title,Checking JavaScript coding standards)
	$(call exec,docker-compose exec node npm run lint)

## Display docker logs.
logs:
	$(call title,Displaying docker logs)
	$(call exec,docker-compose logs --follow $(filter-out $@,$(MAKECMDGOALS)))

## Start docker containers.
up:
	$(call title,Starting docker containers)
	$(call exec,COMPOSE_CONVERT_WINDOWS_PATHS=1 docker-compose up -d --remove-orphans)


# VARIABLES.

## Colors for output text.

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

## Other variables.

DRUPAL_ROOT ?= /var/www/html/web
TARGET_MAX_CHAR_NUM = 20


# FUNCTIONS.

## Execute command and display executed command to user.
define exec
	@printf "$$ ${YELLOW}${1}${RESET}\r\n" && $1
endef

## Display the target title to user.
define title
	@printf "\n${GREEN}>>> ${1}...${RESET}\n"
endef


# https://stackoverflow.com/a/6273809/1826109
%:
	@: