pm2 install pm2-discord-webhook

# Don't forward stdout - too spammy
pm2 set pm2-discord-webhook:log false
# Do forward stderr - useful
pm2 set pm2-discord-webhook:error true
# Send messages when service starts or restarts
pm2 set pm2-discord-webhook:start true
pm2 set pm2-discord-webhook:online true
pm2 set pm2-discord-webhook:stop true
pm2 set pm2-discord-webhook:restart true
# Set destinations for webhooks (URLs sourced from env)
pm2 set pm2-discord-webhook:webhook_url_logs $PM2_INFO_URL
pm2 set pm2-discord-webhook:webhook_url_errors $PM2_ERROR_URL