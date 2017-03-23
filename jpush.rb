require 'sinatra'
require 'jpush'

app_key = 'JPUSH_APP_KEY'
master_secret = 'JPUSH_MASTER_SECRET'
jpush = JPush::Client.new(app_key, master_secret)

get '/' do
  pusher = jpush.pusher
  push_payload = JPush::Push::PushPayload.new(
    platform: 'all',
    audience: 'all',
    notification: 'hello jpush',
    message: 'hello world'
  )
  pusher.push(push_payload)
  'Hello'
end

get '/aliases' do
  logger.info "aliases #{jpush.aliases}"
  "aliases #{jpush.aliases}"
end

get '/push/:alias' do
  user_alias = params[:alias]
  logger.info "Push to: #{user_alias}"
  pusher = jpush.pusher
  audience = JPush::Push::Audience.new.set_alias(user_alias)
  push_payload = JPush::Push::PushPayload.new(
    platform: 'all',
    audience: audience,
    notification: "hello #{user_alias}",
    message: 'hello world'
  )
  pusher.push(push_payload)
end

