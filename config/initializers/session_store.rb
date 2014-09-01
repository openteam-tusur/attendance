# Be sure to restart your server when you modify this file.

Attendance::Application.config.session_store :redis_store, :servers => Settings['session_store.url'], :domain => Settings['app.domain']
