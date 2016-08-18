Laulik
======

A songbook generator.

Prereq
------
Start the docker machine:

    docker-machine start default

Running
-------
Build the Docker container and then build the `voluja.yml` project.

    ./scripts/build.sh && ./scripts/run.sh

Access at port 80 of the docker machine IP.

    http://192.168.99.100/

Deploying
---------
Upload image with:

    ./scripts/upload.sh
