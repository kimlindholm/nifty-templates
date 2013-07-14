# >---------------------------------[ Unicorn ]---------------------------------<

@current_recipe = "unicorn"
@before_configs["unicorn"].call if @before_configs["unicorn"]
say_recipe 'Unicorn'


config = {}

if preference_exists? :unicorn_workers
  config['unicorn_workers'] = preference :unicorn_workers
  say_wizard "Using #{config['unicorn_workers']} Unicorn worker processes " +
             "as set in preferences."
else
  config['unicorn_workers'] = 3
  say_wizard "Using default #{config['unicorn_workers']} Unicorn worker " +
             "processes."
end

@configs[@current_recipe] = config

gem 'unicorn', '~> 4.5.0'

# If you can't see logs on Heroku, try uncommenting these lines:
# run 'mkdir -p vendor/plugins/rails_log_stdout'
# run 'touch vendor/plugins/rails_log_stdout/keep_me'

create_file "Procfile", <<-RUBY
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
RUBY

create_file "config/unicorn.rb", <<-RUBY
worker_processes #{config['unicorn_workers']}
timeout 30

# For Heroku
preload_app true
logger Logger.new($stdout)

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end

  sleep 1
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)

    # Set DB reaping frequency and limit the connection pool
    # (1-2 recommended by Heroku Dev Center).
    # See https://devcenter.heroku.com/articles/concurrency-and-database-connections
    config = Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']              = ENV['DB_POOL'] || 2

    ActiveRecord::Base.establish_connection(config)
    Rails.logger.info("Connected to ActiveRecord (reaping every " +
                      "\#{config['reaping_frequency']} sec, pool size " +
                      "\#{config['pool']})")
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end
end
RUBY
