# About This Project

`MapleBBS-3.10-itoc-EastTown` is a project frok from `MapleBBS-3.10-itoc`

## Supported Environment

* `Debian 13 (trixie)`

## Quick Start Guide

On your host machine:

```bash
docker build -t easttownbbs .
```

```bash
docker run --rm -p 2323:23 -p 8080:80 -it easttownbbs
```

Inside the docker:

```bash
./bootstrap.sh
```

On your host machine:

```bash
telnet 127.0.0.1 23
```

With your browser:

```
http://127.0.0.1:8080
```
