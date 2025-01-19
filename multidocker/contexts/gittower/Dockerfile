ARG ALPINE_VERSION
# FROM alpine:${ALPINE_VERSION}
FROM alpine:latest
RUN apk add docker git bash docker-compose
RUN echo "*/5 * * * * /app/runjobs" > crontab
RUN crontab ./crontab
RUN mkdir /app
WORKDIR /app
COPY . .
CMD ./gittower
