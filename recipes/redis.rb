# >---------------------------------[ Redis ]---------------------------------<

@current_recipe = "redis"
@before_configs["redis"].call if @before_configs["redis"]
say_recipe 'Redis'


@configs[@current_recipe] = config

gem 'redis-rails'

say_wizard "Generating Redis initializer..."

initializer "redis.rb", <<-RUBY
options = {}

# Uncomment to use a 3rd party service, e.g. Redis Cloud
# if ENV['REDISCLOUD_URL']
#   uri = URI.parse(ENV['REDISCLOUD_URL'])
#   options = { host: uri.host, port: uri.port, password: uri.password }
# end

REDIS = Redis.new(options)
RUBY
