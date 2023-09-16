FROM alpine
RUN apk add docker git
RUN echo */30 * * * * ./runjobs > crontab
RUN crontab ./crontab
RUN mkdir /app
WORKDIR /app
COPY . .
CMD gittower
