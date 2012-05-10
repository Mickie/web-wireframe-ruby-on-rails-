Twitter.configure do |config|
  config.consumer_key = ENV["FANZO_TWITTER_CONSUMER_KEY"]
  config.consumer_secret = ENV["FANZO_TWITTER_CONSUMER_SECRET"]
end