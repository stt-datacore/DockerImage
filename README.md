# stt-datacore

Currently used to construct a single Docker image that runs all components of DataCore on the production server.

This works by Docker Hub building an image under alexcpu's namespace. Watchtower, running on the server, periodically checks for a newer image and replaces the running container if needed.

There is a Docker Compose implementation of Datacore. It allows for the enitre suite of services to be deployed within Docker containers but also allows for deployment of subsets thereof.

## Installation and Deployment

After installing Docker Compose download the latest version of DockerImage using
```
git clone https://github.com/stt-datacore/DockerImage.git
```
Then the single docker image can be built by running `docker build -t datacore .` in the base directory. Followed by `docker run datacore`. To run the Compose 
implementation enter the multidocker directory and run `docker-compose --profile <profile> up --build -d` where the profile is one of the options below.

* all - Deploy the entire stack.
* fullstack - Deploy all the services needed to run the website locally. 
* asset-server - Deploy just the website and the asset server.
* site-server - Deploy just the website and the site server.
* website - Deploy the website only.
* rsync - Deploy the rsync server used to inspect logs and data held by the volumes on the stack.
* bot - Deploy all the services needed to run the Discord bot. (untested)
* monitoring - Deploy monitoring services. (untested)
* gittower - Deploy the gittower tool used to restart services when their source repository is changed. (untested)
