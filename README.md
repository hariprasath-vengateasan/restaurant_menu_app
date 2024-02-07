# Dockerized Rails Restaurant Menu Application Guide

## Getting Started

### Cloning the Repository

Begin by obtaining a copy of the project:

1. Open a terminal or command prompt.
2. Clone the Restaurant Menu Application repository:
   ```sh
   git clone git@github.com:hariprasath-vengateasn/restaurant_menu_app.git
   ```
3. Navigate into the project folder:
   ```sh
   cd restaurant_menu_app
   ```

### Setup and Deployment

The setup and deployment of your Rails application can be approached in two ways using Docker:

1. **Automated with Makefile**

   For convenience and automation, we provide a Makefile that simplifies the setup and management of development and production environments.

   **Prerequisites**: Ensure Docker and Docker Compose are installed on your system.

   **Commands Overview**:

   - `make setup-dev`: Initializes the development environment.
   - `make setup-prod`: Prepares the production environment, including database setup.
   - `make run-dev`: Starts the development server.
   - `make run-prod`: Launches the production server in detached mode.
   - `make stop-dev`: Stops the development server.
   - `make stop-prod`: Halts the production server.
   - `make clean`: Cleans up stopped containers while preserving volumes.
   - `make force-clean`: Removes both stopped containers and unused volumes for a thorough cleanup.

   To utilize the Makefile, simply type `make <command>` in the terminal within the project directory. For example:

   ```bash
   make setup-dev
   ```

2. **Manual Setup Using Docker Commands**

   If you prefer a more hands-on approach, direct Docker commands are available for both development and production environments.

   **Development Environment Setup**:

   - **Build Docker Containers**: In the project directory, execute:
     ```sh
     docker-compose -f docker-compose.yml build
     ```
   - **Database Initialization**: Prepare your database with:
     ```sh
     docker-compose run web rails db:create db:migrate
     ```
   - **Start the Application**: Launch your application using:
     ```sh
     docker-compose up
     ```
     The application should now be accessible at [http://localhost:3000](http://localhost:3000).

   **Production Environment Setup**:

   Tailored for production, follow these instructions for deployment:

   - **Build Docker Image**: Create the Docker image with the production Dockerfile:
     ```sh
     docker build -t restaurant_menu_app:latest -f Dockerfile.prod .
     ```
   - **Run the Container**: Deploy the container with production specifications:
     ```sh
     docker run -d -p 80:4000 --name restaurant_menu_app restaurant_menu_app:latest
     ```
     Your application is now available on the host machine's port 80.

## Additional Documentation and Resources

For an in-depth look at development practices, deployment strategies, and the application's roadmap, please consult our detailed documentation available at [Documentation Link](https://hariprasath98.notion.site/Foaps-Restuarant-Menu-App-faa8f795ca374d3582e90237988badd4).

This guide aims to simplify the process of getting your Ruby on Rails Restaurant Menu Application up and running in Docker environments, from development through to production.