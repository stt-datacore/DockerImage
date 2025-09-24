ARG NODE_VERSION
ARG ALPINE_VERSION
FROM node:22-alpine
RUN apk add build-base python3 git rsync
WORKDIR /app
# Sentry requires the github sha
RUN git clone https://github.com/stt-datacore/website.git .git --bare --depth 1
COPY --from=source package.json yarn.lock ./
RUN yarn install
RUN npx update-browserslist-db@latest
COPY --from=source . .

CMD yarn run build && rsync -ru --delete-after /app/public/ /sitebuild/
