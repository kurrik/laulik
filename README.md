# Laulik

A songbook generator.

## Prereq
Install Docker Desktop.

## Running
### Build
Build the docker container:

    ./scripts/build.sh

### Run server

    ./scripts/run.sh server

Access at port 8080:

    http://localhost:8080/

### Build laulik
Build a single project:

    ./scripts/run.sh laulik voluja

### Shell access
Get a shell in the docker container with:

    ./scripts/run.sh shell

## Deploying
Upload image with:

    ./scripts/upload.sh
