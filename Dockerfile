FROM elixir:latest

RUN mkdir /data
WORKDIR /app

# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

COPY . .

RUN MIX_ENV=prod mix do deps.get, compile, release

ENTRYPOINT ["_build/prod/rel/line_server/bin/line_server"]
CMD ["foreground"]
