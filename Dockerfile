# Use the official Ruby image with version 3.2.2 as the base image
FROM ruby:3.1.4

# Set an environment variable for Rails to run in production mode
ENV RAILS_ENV production

# Install essential dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm

# Set up the working directory in the container
WORKDIR /app

# Install Rails dependencies first to leverage Docker cache
COPY Gemfile Gemfile.lock ./
RUN gem install bundler  -v '2.3.26' && bundle install --jobs 4 && rails turbo:install

# Copy the rest of the application's code to the container
COPY . .

# Precompile assets
ENV SECRET_KEY_BASE_DUMMY = 1
RUN bundle exec rake assets:precompile


# Expose the port your Rails app will listen on (assuming it's 3000)
EXPOSE 3000


# Start the Rails server when the container is run


CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]