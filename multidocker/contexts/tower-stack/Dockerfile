ARG ALPINE_VERSION
FROM alpine:latest
RUN apk add git bash docker docker-compose
RUN echo "*/15 * * * * /app/runjobs" > ./crontab.tmp
RUN chmod 0644 ./crontab.tmp
RUN crontab ./crontab.tmp
RUN mkdir /app
WORKDIR /app
COPY . .
COPY ./.env .
