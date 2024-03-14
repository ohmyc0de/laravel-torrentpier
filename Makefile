.PHONY: help
# tips https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
# @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
init: ## Init project
	cp .env.example .env && \
	cp .env.testing.example .env.testing && \
	make build && \
	make install && \
	make migrate

build: ## Build the project containers
	UID=$$(id -u) GID=$$(id -g) docker-compose build --no-cache

run: ## Exec to Web container
	UID=$$(id -u) GID=$$(id -g) docker-compose run --rm php bash
up: down ## Start all containers
	UID=$$(id -u) GID=$$(id -g) docker-compose up -d
down: ## Down all containers
	UID=$$(id -u) GID=$$(id -g) docker-compose down --remove-orphans

install: ## Install composer packages when app init
	UID=$$(id -u) GID=$$(id -g) docker-compose run --rm php composer install

migrate: ## Run app migrations
	UID=$$(id -u) GID=$$(id -g) docker-compose run --rm php php artisan migrate

migrate-down: ## Rollback app migrations
	UID=$$(id -u) GID=$$(id -g) docker-compose run --rm php php artisan migrate:rollback

logs-php: ## Runtime STDout for Php Container
	docker-compose logs php -f
logs-nginx: ## Runtime STDout for Nginx Container
	docker-compose logs nginx -f
logs: ## Runtime STDout for All Containers
	docker-compose logs php nginx pgsql -f
test: ## Command for run tests in container
	UID=$$(id -u) GID=$$(id -g) docker-compose run --rm php php artisan test
