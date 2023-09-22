ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
RUN apk add docker git bash
RUN echo */30 * * * * ./runjobs > crontab
RUN crontab ./crontab
RUN mkdir /app
WORKDIR /app
COPY . .
CMD ./gittower
