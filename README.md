# Track Downloader

Look for explanation [here (in russian)](http://vemperor.github.io/programming/2017/11/23/downloading-track-list-from-soundcloud.html).

## Building app
```sh
$ docker build -t track_downloader .
```

## Running app
```sh
$ docker run --rm -it -v $(pwd):/app track_downloader downloader list.txt
```
