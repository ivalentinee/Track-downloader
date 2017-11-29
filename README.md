# Track Downloader

## Building app
```sh
$ docker build -t track_downloader .
```

## Running app
```sh
$ docker run --rm -it -v $(pwd):/app track_downloader downloader list.txt
```
