include .env

.DEFAULT_GOAL := help
.PHONY: build clean clean-backend clean-docker clean-frontend db-export db-import db-status down drush drupal help init-env install lint lint-backend lint-frontend logs test test-behat up

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

## Export the installed Drupal database.
db-export:
	$(call title,Exporting database backup)
	$(call exec,docker-compose exec php drush sql-dump --result-file=/var/www/database/$(filter-out $@,$(MAKECMDGOALS)))

## Import a database backup.
db-import:
	$(call title,Importing database backup)
	$(call exec,docker-compose exec php sh -c "drush sqlc --root=$(DRUPAL_ROOT) < /var/www/database/$(filter-out $@,$(MAKECMDGOALS))")

## Check if MariaDB is running.
db-status:
	$(call title,Ensuring MariaDB is running)
	$(call exec,docker-compose exec mariadb wait_for "mysqladmin -uroot -p${DB_PASSWORD} -h${DB_HOST} status &> /dev/null" "MariaDB" $(DB_HOST) 12 5 0)

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
	$(call exec,docker-compose exec php sh -c "drush -r $(DRUPAL_ROOT) -l http://cms.$(PROJECT_BASE_URL) $(filter-out $@,$(MAKECMDGOALS))")

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
install: init-env build db-status
	$(call title,Installing Drupal)
	$(call exec,chmod +w backend/web/sites/default/settings.php | true)
	$(call exec,docker-compose exec php sh -c "drush --root=$(DRUPAL_ROOT) -y si contenta_jsonapi install_configure_form.include_recipes_magazin=NULL")

	$(call title,Importing Meetup.com events)
	$(call exec,docker-compose exec php sh -c "drush --root=$(DRUPAL_ROOT) cron")
	$(call exec,docker-compose exec php sh -c "drush --root=$(DRUPAL_ROOT) queue-run drupalmel_meetup_events_queue")

	$(call title,Installation complete)
	@printf "${GREEN}Frontend      :${RESET} http://$(PROJECT_BASE_URL)\n"
	@printf "${GREEN}Backend       :${RESET} http://cms.$(PROJECT_BASE_URL)\n"
	@printf "${GREEN}MailHog       :${RESET} http://mailhog.$(PROJECT_BASE_URL)\n\n"
	@printf "${GREEN}One-time login:${RESET} " && docker-compose exec php sh -c "drush --root=$(DRUPAL_ROOT) -l http://cms.$(PROJECT_BASE_URL) uli"

## Checking project coding standards.
lint: lint-backend lint-frontend

## Check backend coding standards.
lint-backend:
	$(call title,Checking PHP coding standards)
	$(call exec,docker-compose exec php bin/phpcs)

## Check frontend coding standards.
lint-frontend:
	$(call title,Checking JavaScript coding standards)
	$(call exec,docker-compose exec node npm run lint)

## Display docker logs.
logs:
	$(call title,Displaying docker logs)
	$(call exec,docker-compose logs --follow $(filter-out $@,$(MAKECMDGOALS)))

## Run all tests.
test: test-behat test-backstopjs

## Run behat tests.
test-behat:
	$(call title,Running Behat tests)
	$(call exec,docker-compose exec php sh -c "cd ../behat && ../html/bin/behat --colors --format=pretty --out=std --format=junit --format=html $(filter-out $@,$(MAKECMDGOALS))")

test-backstopjs:
	$(call title,Running BackstopJS tests)
	docker run --network=$(DOCKER_NETWORK) --rm -it -v $(shell pwd)/tests/backstopjs:/src backstopjs/backstopjs reference
	docker run --network=$(DOCKER_NETWORK) --rm -it -v $(shell pwd)/tests/backstopjs:/src backstopjs/backstopjs test

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

DOCKER_NETWORK = $(call shell,docker inspect $(call shell,docker-compose ps -q traefik) -f "{{ json .NetworkSettings.Networks }}" | sed -E 's/^\{"([a-zA-Z_]*).*/\1/g')
DRUPAL_ROOT ?= /var/www/html/web
TARGET_MAX_CHAR_NUM = 20


# FUNCTIONS.

## Execute command and display executed command to user.
define exec
	@printf "$$ ${YELLOW}${subst ",',${1}}${RESET}\n\n" && $1
endef

## Display the target title to user.
define title
	@printf "\n${GREEN}>>> ${1}...${RESET}\n\n"
endef


# https://stackoverflow.com/a/6273809/1826109
%:
	@: