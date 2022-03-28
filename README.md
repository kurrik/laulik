# Laulik

A songbook generator.

## Prereq
Install Docker Desktop.

Install `gcloud`.

Run `gcloud auth configure-docker`.

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

Build the test project by watching for changes to yaml files:

    goat

Note, needs `goat` which you can install with:

    go install github.com/yosssi/goat@latest

### Shell access
Get a shell in the docker container with:

    ./scripts/run.sh shell

## Deploying
Deploy to prod with:

    ./scripts/deploy.sh

Upload locally-built image (this isn't generally needed!):

    ./scripts/upload.sh
