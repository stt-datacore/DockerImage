FROM node:18-alpine
RUN apk add bash python3 build-base
RUN mkdir /utils
WORKDIR /utils
COPY --from=utils package.json package-lock.json ./
RUN npm install
COPY --from=utils . .
RUN npm run build
RUN mkdir /utils
WORKDIR /utils
COPY --from=utils2 package.json package-lock.json ./
RUN npm install
COPY --from=utils2 . .
RUN mkdir /app
WORKDIR /app
RUN echo */30 * * * * /app/exec.sh > crontab
RUN echo 40 5,17 * * * /util/util.sh >> crontab
RUN crontab ./crontab
COPY --from=source package.json package-lock.json ./
RUN npm install
COPY --from=source . .
RUN npm run build
CMD crond -f -l 8