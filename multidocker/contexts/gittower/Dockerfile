ARG ALPINE_VERSION
FROM alpine:latest
RUN apk add docker docker-compose git bash
RUN docker-compose version && sleep 5s
RUN echo "*/2 * * * * /app/runjobs" > ./crontab.tmp
RUN crontab ./crontab.tmp
RUN mkdir /app
WORKDIR /app
COPY . .
CMD ./gittower
