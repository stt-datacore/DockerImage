ARG NODE_VERSION
ARG ALPINE_VERSION
FROM node:$NODE_VERSION-alpine$ALPINE_VERSION
RUN apk add build-base python3 git rsync
WORKDIR /app
# Sentry requires the github sha
RUN git clone https://github.com/stt-datacore/website.git .git --bare --depth 1
COPY --from=source package.json yarn.lock ./
RUN yarn install
RUN npx update-browserslist-db@latest 
COPY --from=source . .

ARG GATSBY_DATACORE_URL
RUN echo GATSBY_DATACORE_URL=$GATSBY_DATACORE_URL > .env
ARG GATSBY_ASSETS_URL
RUN echo GATSBY_ASSETS_URL=$GATSBY_ASSETS_URL >> .env
RUN cat .env && sleep 5s

CMD yarn run build && rsync -ru --delete-after /app/public/ /sitebuild/
