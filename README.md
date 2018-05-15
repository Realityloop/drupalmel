# melbourne.drupal.org.au

This is the codebase for the Drupal Melbourne community website.

[![CircleCI](https://circleci.com/gh/Realityloop/drupalmel/tree/develop.svg?style=svg)](https://circleci.com/gh/Realityloop/drupalmel/tree/develop)

---

## Table of Contents

* [Local development](#local-development)
  * [Requirements](#requirements)
  * [Install](#install)
  * [Services](#services)
* [Makefile commands](#makefile-commands)
* [Help](#help)
  * [Bad Gateway](#bad-gateway)
  * [API Timeout](#api-timeout)

---

## Local development

### Requirements

* [Docker Compose](https://docs.docker.com/compose/install/)
* (Windows) [Git Bash](https://git-scm.com/download/win)
* (Windows) [Make for mingw64](README-WIN.md#make-for-mingw64)

### 1. Install

Run the following command in Terminal or Git Bash:

  > `make init && make install`

### 2. Services

* Frontend / Nuxt.js: [http://drupalmel.localhost](http://drupalmel.localhost)
* Backend / ContentaCMS: [http://cms.drupalmel.localhost](http://cms.drupalmel.localhost)
* MailHog: [http://mailhog.drupalmel.localhost](http://mailhog.drupalmel.localhost)

---

## Makefile commands

A Makefile is provided to control your development environment and process.

* **build:**

  Executes the following commands:
  * build-backend
  * build-frontend

* **build-backend:**

  Builds the backend codebase by running Composer install inside the PHP
  container.

* **build-frontend:**

  Builds the frontend codebase by running NPM install and Nuxt build inside
  the Node container.

* **clean:**

  Executes the following commands:
  * clean-docker
  * clean-backend
  * clean-frontend

* **clean-backend:**

  Removes backend build files.

* **clean-docker:**

  Stops and removes Docker containers.

* **clean-frontend:**

  Removes frontend build files.

* **db-export:**

  Exports a database file (argument required) relative to the `database` folder.

* **db-import:**

  Imports a database file (argument required) relative to the `database` folder.

* **db-status:**

  Checks the status of the MariaDB Docker container.

* **down:**

  Stops Docker containers.

* **drupal:**

  Runs Drupal Console commands inside the PHP container.

  *Important:* All Drupal Console commands executed this way should be formatted
  as follows.

  > `make drupal -- ARGS`

  Example:

  > `make drupal -- cr all`

* **drush:**

  Runs Drush (DRUpal SHell) commands inside the PHP container.

  *Important:* All Drush commands executed this way should be formatted as
  follows.

  > `make drush -- ARGS`

  Example:

  > `make drush -- en devel_generate -y`

* **init:**

  Initializes the projects `.env` file, if it doesn't exist alread, by copying
  `.env-example`.

* **install:**

  Initializes `.env`, starts docker containers, builds dependencies and installs
  Drupal.

* **lint:**

  Executes the following commands:
  * lint-backend
  * lint-frontend

* **lint-backend:**

  Runs code linting over the backend with PHP_CodeSniffer.

* **lint-frontend:**

  Runs code linting over the frontend with ESLint.

* **logs:**

  Displays and follows the Docker Compose container logs.

  _This command accepts arguments._

  > `make logs ARGS`

  Example:

  > `make logs php`

* **test:**

  Executes the following commands:
  * test-behat

* **test-behat:**

  Runs Behat tests.

* **up:**

  Starts the Docker containers.

---

## Help

* ### Bad Gateway

  > I'm seeing `Bad Gateway` while trying to access the frontend.

  This issue is likely due to the Nuxt.JS server not being ready yet.

  The Node container does the following when it launches: Installs NPM
  dependencies, Rebuilds Node SASS and then runs Nuxt.JS in development mode.

  To confirm the container is ready, you can watch the container logs with the
  following command:

  > ```make logs node```

* ### API Timeout

  > The API requests are all timing out.

  In the case that your development environment is running slowly you may be
  required to increase the timeout limit.

  To do so, open your projects `.env` file and increase the `API_TIMEOUT` value.
