# Tracks Downloader

## Running elixir container
```sh
docker run -it --rm -v $(pwd):/app elixir:1.5.1 bash
```

## Building app
```sh
cd /app
mix local.hex --force && mix local.rebar --force && mix deps.get
MIX_ENV=prod mix escript.build
```

## Running app
```sh
./downloader list.txt
```
