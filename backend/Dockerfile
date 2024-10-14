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

# Install the dependencies.
RUN mix deps.get

# Compile the project.
RUN mix do compile

EXPOSE 4000

RUN chmod +x /app/entrypoint.sh

# DOS2UNIX
CMD ["/app/entrypoint.sh"]