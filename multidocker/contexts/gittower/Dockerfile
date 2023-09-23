ARG ALPINE_VERSION
FROM alpine:$ALPINE_VERSION
RUN apk add docker docker-compose git bash
RUN echo "*/2 * * * * /app/runjobs" > ./crontab.tmp
RUN crontab ./crontab.tmp
RUN mkdir /app
WORKDIR /app
COPY . .
CMD ./gittower
