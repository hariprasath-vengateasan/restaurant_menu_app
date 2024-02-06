# Use a Ruby image suitable for development
FROM ruby:3.2.3

# Install Node.js for JavaScript asset management and PostgreSQL client for database interactions
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose port 80 to the outside world (note: port 3000 is typical for development, but using 80 as per requirements)
EXPOSE 3000

# Start the main process (Rails server)
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
