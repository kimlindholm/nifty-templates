# >---------------------------------[ Rack::Throttle ]---------------------------------<

@current_recipe = "rack-throttle"
@before_configs["rack-throttle"].call if @before_configs["rack-throttle"]
say_recipe 'Rack::Throttle'


@configs[@current_recipe] = config

# NB: There was a problem getting Rack::Throttle and Rack::MiniProfiler to
# work simultaneously. As a workaround, you can load them in different
# environments, e.g. staging and production.

text_to_add_first = <<-RUBY
require "rack/throttle"
RUBY

text_to_add_configure = <<-RUBY
  config.middleware.use Rack::Deflater

  # Rate-limit incoming HTTP requests
  config.middleware.use Rack::Throttle::Daily,    max: 100000   # requests
  config.middleware.use Rack::Throttle::Hourly,   max: 10000    # requests
  config.middleware.use Rack::Throttle::Interval, min: 0.02     # seconds
  # Storing the rate-limiting counters on a Memcached server:
  # config.middleware.use Rack::Throttle::Interval,
  #                       cache: Memcached.new,
  #                       key_prefix: :throttle
RUBY

rack_throttle = <<-RUBY
if defined? Rack::Throttle
  class Rack::Throttle::Limiter
    def http_error(code, message = nil, headers = {})
      [code, {'Content-Type' => 'text/plain; charset=utf-8'}.merge(headers),
      [http_status(code) + (message.nil? ? "\\n" : " (\#{message})\\n")]]
    end
  end
end
RUBY

gem 'rack-throttle', group: :production

production_path = "config/environments/production.rb"

if File.exist?(production_path)
  prepend_file production_path, "#{text_to_add_first}\n"

  append_to_block_in_file(production_path,
                          "\n#{text_to_add_configure}\n",
                          "::Application.configure do",
                          "end")

  create_file "config/initializers/rack_throttle.rb", rack_throttle
else
  say_error "production.rb not found, Rack::Throttle setup failed"
end
