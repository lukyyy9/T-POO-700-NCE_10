# T-POO-700-NCE_10

## Table of contents

- [Installation](#installation)
  - [Backend installation](#backend-installation)
  - [Frontend installation](#frontend-installation)
- [Running the project](#running-the-project)
- [Useful Postgres commands](#useful-postgres-commands)
- [Used commands to init the project (only for reference)](#used-commands-to-init-the-project-only-for-reference)

## Installation

### Backend installation

- Install [Docker](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)

- Install [Erlang](https://erlang.org/download/otp_win64_27.1.exe)

- Install [Elixir](https://objects.githubusercontent.com/github-production-release-asset-2e65be/1234714/228b2629-2ae4-49a0-a085-75c4c4af46d3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20241007%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241007T085513Z&X-Amz-Expires=300&X-Amz-Signature=f4bd4495bd681f467d1598acd01f61b9655084da7a951dae8eea8fef8637437d&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Delixir-otp-27.exe&response-content-type=application%2Foctet-stream)

- Start your Postgres container `docker run --name postgres-container -e POSTGRES_PASSWORD=pwd -p 5432:5432 -d postgres:latest`

- *If needed, edit Postgre credentials in `config/dev.exs` and `config/test.exs`*

- Install the dependencies `mix deps.get`

- Create and migrate the database `mix ecto.setup`

### Frontend installation

- Install [Node.js](https://nodejs.org/en/download/)

- Install the dependencies `npm install`

## Running the project

- Start your Postgres container `docker run --name postgres-container -e POSTGRES_PASSWORD=pwd -p 5432:5432 -d postgres:latest`

- In the backend folder, run `mix phx.server`

- In the frontend folder, run `npm run dev`

- Open your browser and go to `http://localhost:80`

## Deployment

### Server deployment

To deploy the project to the server (frontend, backend and database), simply commit your changes and push them to the `main` branch. The project will be automatically deployed to the AWS EC2 using the deployment pipeline.

### Application deployment

First, you have to install [Android Studio](https://r5---sn-5hne6nzd.gvt1.com/edgedl/android/studio/install/2024.1.2.12/android-studio-2024.1.2.12-windows.exe?cms_redirect=yes&met=1729501824,&mh=q1&mip=163.5.23.73&mm=28&mn=sn-5hne6nzd&ms=nvh&mt=1729501463&mv=m&mvi=5&pl=27&rmhost=r2---sn-5hne6nzd.gvt1.com&rms=nvh,nvh&shardbypass=sd&smhost=r2---sn-5hne6nsy.gvt1.com).
To build the APK, run the following commands in the frontend folder:

- `npx npm run build && npx cap copy`
- `npx cap sync --inline`
- `npx cap open android`

Then, in Android Studio, build the APK by clicking on Build > Build Bundle(s) / APK(s) > Build APK(s).
The APK will be generated in the `frontend\android\app\build\outputs\apk\debug` folder.

## Troubleshooting

- If you encounter an error with some pending migrations, run `mix ecto.reset`. If that doesn't work, delete the project directory, clone it again and run the installation steps.

## Useful Postgres commands

- Enter Postgres container in CLI mode :
  - `docker exec -it postgres-container bash`
  - `psql -h localhost -U postgres`
- Connect to the timemanager database `\c timemanager_dev`
- List all tables `\dt`
- List all columns of a table `\d <table_name>`

You can also run SQL queries directly in the Postgres container, e.g. `SELECT * FROM users;`

## Used commands to init the project (only for reference)

- Start Postgres `docker run --name postgres-container -e POSTGRES_PASSWORD=pwd -p 5432:5432 -d postgres:latest`

- Install Hex `mix local.hex`

- Install Phoenix application generator `mix archive.install hex phx_new`

- Run init command `mix phx.new T-POO-700-NCE_10 --app timemanager --module Timemanager --no-html`

- Create the contexts :
  - `mix phx.gen.json UserContext User users username:string email:string`
  - `mix phx.gen.json WorkingTimeContext WorkingTime workingtime start:naive_datetime end:naive_datetime user_id:references:users`
  - `mix phx.gen.json ClockContext Clock clocks status:boolean time:naive_datetime user_id:references:users`
