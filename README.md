# GDLibrary

## System Requirements

  * [Docker](https://docs.docker.com/get-docker/)
  * [docker-compose](https://docs.docker.com/compose/install/)

## Stack

  * Elixir 1.10
  * Phoenix 1.5
  * PostgreSQL 12

## Setup

  * `docker-compose build`
  * `docker-compose run web mix deps.get`
  * `docker-compose run web mix ecto.create`
  * `docker-compose run web mix ecto.migrate`
  * `docker-compose run web mix run priv/repo/seeds.exs`

## Run Tests

  * `docker-compose run -e MIX_ENV=test web mix ecto.create`
  * `docker-compose run -e MIX_ENV=test web mix ecto.migrate`
  * `docker-compose run -e MIX_ENV=test web mix test`

## Run Server

  * `docker-compose up`
  * access at `http://localhost:4000`

## Tips

  * access and explore psql database via host by using details in `.env` but port `5433`. (this is how you'll know what book titles are requestable!)
  * relevant tests are at `test/gd_library_web/controllers/book_request_controller_test.exs`

## Notes

### Assumptions

  * because the spec used `GET /request`, `POST /request`, etc (instead of `/book` or `/books` or `/books/:id/request`), the resource we're interacting with via these endpoints in this API is a "book request" (or a "hold") not a "book" itself. however, this means returning an `"id"` value of "ID of the book" is odd! i genuinely wasn't sure which compromise was better here, so i made a change and returned the `book_requests.id` under `"id"` while augmenting with `book_requests.requested_book_id` under `"requested_book_id"`.
  * multiple book copies per book title
  * "available" means "book copy successfully held for the user, ready for pickup"
  * requesting a book merely is requesting a hold (and not guaranteeing one!). you haven't yet received the book.
  * deleting a request implies releasing a hold (if applicable), not returning a book (or anything else). in fact, you can't "undo" (delete) a request if you already have the book
  * book title must be exact (if there are > 1 or 0 results, you get an error)
  * the same email can be used multiple times but only once per book
  * one library location :)

### Tradeoffs

  * controller tests only. no time!
  * didn't bother with nice full text searching. book title must be exact.
  * eschewing authors first_name and last_name for full_name allows us to accurately represent all international authors' names, but we won't easily be able to "sort by last name" as you might expect in a US context
  * duplication of `book_requests.requested_book_id` and `book_requests.held_book_copy_id` leaves us currently open to the possibility of a copy of the "wrong" book being doled out, but i'm not sure if this matters to the user or the business inherently.
  * "email" is enough for now. we won't be bothering with full users or accounts tables.

### One Last Thing

  * Thanks!
