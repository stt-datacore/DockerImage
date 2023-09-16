FROM datacore/pm2-discord as development
RUN apk add python3 build-base sqlite
RUN mkdir /app
WORKDIR /app
COPY --from=source package.json package-lock.json .
RUN npm install
COPY --from=source . .
RUN npm run build
CMD npm run start

FROM development as production
CMD pm2-runtime --name server start npm -- start