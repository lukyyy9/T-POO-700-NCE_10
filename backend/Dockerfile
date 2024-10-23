# Use an official Elixir runtime as a parent image.
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
RUN mix local.hex --force

# Install rebar (required for certain dependencies).
RUN mix local.rebar --force

# Install the dependencies.
RUN mix deps.get

# Compile the project.
RUN mix do compile

# Create a directory for test results
RUN mkdir -p /app/test-results

EXPOSE 4000

# Modify entrypoint script to handle both production and test environments
RUN chmod +x /app/entrypoint.sh

# Use a shell form of CMD to allow for environment variable substitution
CMD ["/bin/sh"]