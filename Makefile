# Makefile for Restaurant Menu App

# Variables
IMAGE_NAME = restaurant_menu_app
DOCKER_COMPOSE_DEV = docker-compose -f docker-compose.yml
DOCKER_COMPOSE_PROD = docker-compose -f docker-compose-prod.yml
DOCKER_DEV = docker run --rm -v "$(PWD):/app" -w /app -e RAILS_ENV=development
DOCKER_PROD = docker run -d -p 80:80 --name $(IMAGE_NAME) $(IMAGE_NAME):latest

# Help message
help:
	@echo "Restaurant Menu App Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  setup-dev       Setup development environment"
	@echo "  setup-prod      Setup production environment"
	@echo "  run-dev         Run development environment"
	@echo "  run-prod        Run production environment"
	@echo "  stop-prod       Stop production environment"
	@echo "  clean           Remove stopped containers and unused volumes"
	@echo "  help            Show this help message"

# Setup development environment
setup-dev:
	$(DOCKER_COMPOSE_DEV) build
	$(DOCKER_COMPOSE_DEV) run web rails db:create db:migrate
	@echo "Development environment is ready."

# Setup production environment
setup-prod:
	docker build -t $(IMAGE_NAME):latest -f Dockerfile.prod .
	@echo "Production environment is ready."

# Run development environment
run-dev:
	cd restaurant_menu_app && $(DOCKER_COMPOSE_DEV) up -d
	@echo "Development environment is running at http://localhost:3000"

# Run production environment
run-prod:
	$(DOCKER_PROD)
	@echo "Production environment is running at http://localhost:80"

# Stop production environment
stop-prod:
	docker stop $(IMAGE_NAME)
	@echo "Production environment stopped."

# Clean up stopped containers and unused volumes
clean:
	docker-compose -f docker-compose.yml down -v
	docker-compose -f docker-compose-prod.yml down -v
	@echo "Containers and volumes cleaned up."

# Default target
default: help
