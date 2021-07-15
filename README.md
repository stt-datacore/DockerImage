# stt-datacore

Currently used to construct a single Docker image that runs all components of DataCore on the production server.

This works by Docker Hub building an image under alexcpu's namespace. Watchtower, running on the server, periodically checks for a newer image and replaces the running container if needed.

Ideally it would be split into multiple Docker images/containers, one for each service. The currently unused `multidocker` folder contains a prototype of this. 
