FROM datacore/pm2-discord as development
RUN apt-get install -y python3 sqlite
RUN mkdir /app
WORKDIR /app
COPY --from=source package.json package-lock.json ./
RUN npm install
COPY --from=source . .
RUN npm run build
CMD npm run start

FROM development as production
RUN pm2 set pm2-discord-webhook:process_name site-server
CMD pm2-runtime --name server start npm -- start