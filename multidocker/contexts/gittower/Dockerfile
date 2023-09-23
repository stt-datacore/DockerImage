ARG ALPINE_VERSION
FROM alpine:latest
RUN apk add docker docker-compose git bash openssh-client openssh
RUN echo "*/2 * * * * /app/runjobs" > ./crontab.tmp
RUN crontab ./crontab.tmp
RUN mkdir /app
RUN mkdir ~/.ssh
WORKDIR /app
COPY . .
COPY ./.env .
RUN source .env && ssh-keyscan -t rsa $CONTAINER_HOST > ~/.ssh/known_hosts
CMD ./gittower
