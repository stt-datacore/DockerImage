ARG ALPINE_VERSION
ARG NODE_VERSION
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}
 
RUN npm install pm2 -g
RUN pm2 install pm2-discord-webhook

# Don't forward stdout - too spammy
RUN pm2 set pm2-discord-webhook:log false

# Do forward stderr - useful
RUN pm2 set pm2-discord-webhook:error true

# Send messages when service starts or restarts
RUN pm2 set pm2-discord-webhook:start true
RUN pm2 set pm2-discord-webhook:online true
RUN pm2 set pm2-discord-webhook:stop true
RUN pm2 set pm2-discord-webhook:restart true

# Set destinations for webhooks (URLs sourced from env)
ARG PM2_INFO_URL
RUN pm2 set pm2-discord-webhook:webhook_url_logs $PM2_INFO_URL
ARG PM2_ERROR_URL
RUN pm2 set pm2-discord-webhook:webhook_url_errors $PM2_ERROR_URL