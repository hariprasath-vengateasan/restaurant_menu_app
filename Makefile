# Makefile for Restaurant Menu App

# Variables
IMAGE_NAME = restaurant_menu_app
DOCKER_COMPOSE_DEV = docker-compose -f docker-compose.yml
DOCKER_COMPOSE_PROD = docker-compose -f docker-compose-prod.yml

# Help message
help:
	@echo "Restaurant Menu App Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  setup-dev                         Setup development environment"
	@echo "  first-time-setup-prod             First Time Setup in production environment"
	@echo "  setup-prod                        Setup production environment"
	@echo "  run-dev                           Run development environment"
	@echo "  run-prod                          Run production environment"
	@echo "  stop-prod                         Stop production environment"
	@echo "  clean                             Remove stopped containers and unused volumes"
	@echo "  help                              Show this help message"

# Setup development environment
setup-dev:
	$(DOCKER_COMPOSE_DEV) build
	$(DOCKER_COMPOSE_DEV) run web rails db:create db:migrate
	@echo "Development environment is ready."

# First Time Production setup
first-time-setup-prod:
	$(DOCKER_COMPOSE_PROD) build
	$(DOCKER_COMPOSE_PROD) run web bundle install
	$(DOCKER_COMPOSE_PROD) run web rails db:create db:migrate
	@echo "First-time production environment setup is complete."

# Setup production environment
setup-prod:
	$(DOCKER_COMPOSE_PROD) build
	$(DOCKER_COMPOSE_PROD) run web rails db:migrate
	@echo "Production environment is ready."

# Run development environment
run-dev:
	$(DOCKER_COMPOSE_DEV) up -d
	@echo "Development environment is running at http://localhost:3000"

# Run production environment
run-prod:
	$(DOCKER_COMPOSE_PROD) up -d --build
	@echo "Production environment is running."

# Stop production environment
stop-prod:
	$(DOCKER_COMPOSE_PROD) down
	@echo "Production environment stopped."

# Clean up stopped containers, but preserve the database volume
clean:
	$(DOCKER_COMPOSE_DEV) down
	$(DOCKER_COMPOSE_PROD) down
	@echo "Containers stopped and removed. Database volume preserved."

# Default target
default: help
