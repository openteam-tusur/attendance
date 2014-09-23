RedisUserConnector.connect :url => Settings['redis_user_connector.url']

require Rails.root.join('app', 'models', 'auth_client', 'user.rb')
