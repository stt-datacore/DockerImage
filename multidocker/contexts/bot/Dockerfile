FROM datacore/pm2-discord AS development
RUN apt-get install -y sqlite3
RUN mkdir /app
WORKDIR /app
COPY --from=source package.json package-lock.json ./
RUN npm ci
COPY --from=source . .
RUN npm run build
RUN mkdir /data
COPY bot_config.json /data/
CMD npm run start

FROM development AS production
RUN pm2 set pm2-discord-webhook:process_name bot
CMD pm2-runtime --name bot start npm -- start