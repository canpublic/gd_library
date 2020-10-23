# GDLibrary

## System Requirements

  * [Docker](https://docs.docker.com/get-docker/)
  * [docker-compose](https://docs.docker.com/compose/install/)

## Setup

  * `docker-compose build`
  * `docker-compose run web mix deps.get`
  * `docker-compose run web mix ecto.create`

## Test

  * `docker-compose run -e MIX_ENV=test web mix test`
