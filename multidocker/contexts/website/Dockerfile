ARG NODE_VERSION
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}
RUN apk add build-base python3 git
WORKDIR /app
# Sentry requires the github sha
RUN git clone https://github.com/stt-datacore/website.git .git --bare --depth 1
COPY --from=source package.json yarn.lock ./
RUN yarn install
RUN npx update-browserslist-db@latest 
COPY --from=source . .
CMD yarn run build