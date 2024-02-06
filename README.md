# Restaurant Menu App

Welcome to the Restaurant Menu App, a comprehensive solution for managing your restaurant's menu digitally. This application is built with Ruby on Rails and is dockerized for easy development and deployment.

## Prerequisites

Before you begin, make sure you have the following prerequisites installed on your system:

1. **Docker and Docker Compose**: You'll need Docker and Docker Compose to run the application. If you don't have them installed, you can download and install them from the official Docker website:
   - [Docker Installation](https://docs.docker.com/get-docker/)
   - [Docker Compose Installation](https://docs.docker.com/compose/install/)

2. **Git**: You'll need Git to clone the project repository. If you don't have Git installed, you can download and install it from the official Git website:
   - [Git Installation](https://git-scm.com/downloads)

## Getting Started

### Cloning the Repository

1. Open your terminal or command prompt.

2. Clone the Restaurant Menu App repository to your local machine using the following command:
   ```sh
   git clone git@github.com:hariprasath-vengateasan/restaurant_menu_app.git
   ```

3. Navigate to the project directory:
   ```sh
   cd restaurant_menu_app
   ```

### Setup and Deployment Options

You have two options for setting up and deploying the Restaurant Menu App:

1. **Using the Makefile (Automated)**

   For those who prefer a streamlined and automated way to manage the development and production environments, we have provided a Makefile. The Makefile simplifies common tasks and commands for setting up and running the Restaurant Menu App.

   **Prerequisites**: Before using the Makefile, ensure you have Docker and Docker Compose installed on your system.

   **Available Commands**:

   - `make setup-dev`: Sets up the development environment.
   - `first-time-setup-prod`: First Time Setup in production environment.
   - `make setup-prod`: Sets up the production environment.
   - `make run-dev`: Runs the development environment.
   - `make run-prod`: Runs the production environment.
   - `make stop-prod`: Stops the production environment.
   - `make clean`: Cleans up stopped containers and unused volumes.

   To use the Makefile, open your terminal in the project directory and run the desired command using the `make` command, for example:

   ```bash
   make setup-dev
   ```

2. **Using Docker Direct Commands (Manual)**
  ### Setup for Development Environment

   1. **Build the Docker Containers**

      After cloning the repository, navigate to the project directory and build the Docker containers using Docker Compose:
      ```sh
      docker-compose -f docker-compose.yml build
      ```

   2. **Database Setup**

      Set up the database with the following commands:
      ```sh
      docker-compose run web rails db:create db:migrate
      ```

   3. **Start the Application**

      Start the application by running:
      ```sh
      docker-compose up -d
      ```

      The application should now be running on [http://localhost:3000](http://localhost:3000).

   ### Setup for Production Environment

   For production deployment, we use a slightly different Dockerfile (`Dockerfile.prod`), optimized for production:

   1. **Build the Docker Image**

      Build the Docker image using the production Dockerfile:
      ```sh
      docker build -t restaurant_menu_app:latest -f Dockerfile.prod .
      ```

   2. **Run the Container**

      Run your container by specifying the production environment:
      ```sh
      docker run -d -p 80:80 --name restaurant_menu_app restaurant_menu_app:latest
      ```

      Your application should now be accessible on port 80 of your host machine.

## Further Documentation and Roadmap

For detailed implementation, development practices, and the roadmap of the Restaurant Menu App, please refer to our comprehensive guide hosted on Notion at [Notion Link](https://hariprasath98.notion.site/Foaps-Restuarant-Menu-App-faa8f795ca374d3582e90237988badd4).