# Makefile for simplifying Docker commands for the Rails project

# Variables
DOCKER_COMPOSE_DEV = docker-compose -f docker-compose.yml
DOCKER_COMPOSE_PROD = docker-compose -f docker-compose-prod.yml

# Help message
help:
	@echo "Available commands:"
	@echo "  setup-dev                 - Setup development environment"
	@echo "  setup-prod                - Setup production environment, including database creation and migration"
	@echo "  run-dev                   - Run development environment"
	@echo "  run-prod                  - Run production environment"
	@echo "  stop-dev                 - Stop Development environment"
	@echo "  stop-prod                 - Stop production environment"
	@echo "  clean                     - Remove stopped containers, preserve the volume"
	@echo "  force-clean                     - Remove stopped containers and unused volumes"

# Setup development environment
setup-dev:
	$(DOCKER_COMPOSE_DEV) build
	$(DOCKER_COMPOSE_DEV) run web rails db:create db:migrate db:seed
	@echo "Development environment is ready."

# Setup production environment
setup-prod:
	$(DOCKER_COMPOSE_PROD) build
	$(DOCKER_COMPOSE_PROD) run web rails db:create db:migrate db:seed
	@echo "Production environment is ready."

# Run development environment
run-dev:
	$(DOCKER_COMPOSE_DEV) up
	@echo "Development environment is running."

# Run production environment
run-prod:
	$(DOCKER_COMPOSE_PROD) up -d
	@echo "Production environment is running at http://localhost:80"

# Stop Development environment
stop-dev:
	$(DOCKER_COMPOSE_DEV) down
	@echo "Development environment stopped."

# Stop production environment
stop-prod:
	$(DOCKER_COMPOSE_PROD) down
	@echo "Production environment stopped."

# Clean up stopped containers and unused volumes
clean:
	$(DOCKER_COMPOSE_DEV) down --remove-orphans
	$(DOCKER_COMPOSE_PROD) down --remove-orphans
	@echo "Cleaned up."

# Force Clean up stopped containers and delete unused volumes
force-clean:
	$(DOCKER_COMPOSE_DEV) down --volumes --remove-orphans
	$(DOCKER_COMPOSE_PROD) down --volumes --remove-orphans
	@echo "Cleaned up."

# Default target
default: help
