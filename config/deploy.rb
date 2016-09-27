require 'openteam/capistrano/deploy'

set :db_remote_clean, true

set :slackistrano,
  channel: (Settings['slack.channel'] rescue ''),
  webhook: (Settings['slack.webhook'] rescue '')
