# Dockerfile.prod
FROM ruby:3.2.3

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --without development test

# Copy the rest of the application code to the container
COPY . .

# Expose port 3000 for the Rails application
EXPOSE 3000

# Precompile assets and run the Rails application in production mode
CMD ["rails", "assets:precompile", "db:migrate", "RAILS_ENV=production", "rails", "server", "-b", "0.0.0.0"]
