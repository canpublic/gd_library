FROM bitwalker/alpine-elixir-phoenix:1.10.3

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

CMD mix phx.server