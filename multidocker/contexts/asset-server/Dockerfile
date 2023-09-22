FROM node:16-alpine
RUN apk add bash python3 build-base
RUN mkdir /app
WORKDIR /app
RUN echo */30 * * * * /app/exec.sh > crontab
RUN crontab ./crontab
COPY --from=source package.json package-lock.json ./
RUN npm install
COPY --from=source . .
RUN npm run build
CMD ./exec.sh && crond -f -l 8