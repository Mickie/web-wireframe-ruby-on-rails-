# config/initializers/geocoder.rb
Geocoder.configure do |config|

  # geocoding service (see below for supported options):
  #config.lookup = :yahoo

  # to use an API key:
  #config.api_key = "..."

  # geocoding service request timeout, in seconds (default 3):
  config.timeout = 0.5

  # set default units to kilometers:
  #config.units = :km

  # caching (see below for details):
  if !Rails.env.development? && !Rails.env.test?
    uri = URI.parse(ENV["REDISTOGO_URL"])
    config.cache = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end
  #config.cache_prefix = "..."

end