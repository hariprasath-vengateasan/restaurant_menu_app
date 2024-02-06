# Use a Ruby image suitable for development
FROM ruby:3.2.3

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code to the container
COPY . .

# Expose port 80 for the Rails application
EXPOSE 80

# Start the Rails application in development mode
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]
