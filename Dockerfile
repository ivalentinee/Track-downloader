FROM elixir:1.5.1

RUN mkdir /app
WORKDIR /app
ADD . /app

ENV PATH="/root/.mix/escripts:${PATH}" MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

RUN mix escript.build && \
    mix escript.install --force
