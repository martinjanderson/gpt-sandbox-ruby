# Use the official Ruby base image on Debian
FROM ruby:latest

# Set environment variables
ENV LANG C.UTF-8
ENV APP_HOME /app
ENV BUNDLE_PATH /bundle/vendor

# Install necessary packages and libraries
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    git

# Create the application directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock $APP_HOME/

# Install gems
RUN bundle install --jobs 20 --retry 5 --path=$BUNDLE_PATH

# Copy the application code
COPY . $APP_HOME/

# Expose the port for the web server
EXPOSE 9292

# Start the web server
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"]
