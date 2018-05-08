# melbourne.drupal.org.au

This is the codebase for the Drupal Melbourne community website.


## Setup local development

### Requirements

- [Docker Compose](https://docs.docker.com/compose/install/)


### 1. Install:

Run the appropriate command based on your operating system and/or shell:

* macOS, *nix:

  > `make install`


### 2. Access installed services:

- Frontend / Nuxt.js: http://drupalmel.localhost
- Backend / ContentaCMS: http://cms.drupalmel.localhost
- MailHog: http://mailhog.drupalmel.localhost


## Makefile commands

- **build:**

  Ensures that the Docker containers are running, and executes `composer install` inside the PHP container.


- **clean:**

  Executes the following commands:
  - clean-docker
  - clean-backend
  - clean-frontend


- **clean-backend:**

  Removes backend build files.


- **clean-docker:**

  Stops and removes Docker containers.


- **clean-frontend:**

  Removes frontend build files.


- **down:**

  Stops Docker containers.


- **drush:**

  Runs Drush (DRUpal SHell) commands inside the PHP container.

  *Important:* All Drush commands executed this way should be formatted as follows.

  > `make drush -- ARGS`

  Example:

  > `make drush -- en devel_generate -y`


- **init-env:**

  Initializes the projects `.env` file, if it doesn't exist alread, by copying `.env-example`.


- **install:**

  Initializes `.env`, starts docker containers, builds dependencies and installs Drupal.


- **logs:**

  Displays and follows the Docker Compose container logs.


- **up:**

  Starts the Docker containers.