# >---------------------------------[ Request-log-analyzer ]---------------------------------<

@current_recipe = "request-log-analyzer"
@before_configs["request-log-analyzer"].call if @before_configs["request-log-analyzer"]
say_recipe 'Request-log-analyzer'


@configs[@current_recipe] = config

gem 'request-log-analyzer', group: :development

after_bundler do
  run 'request-log-analyzer install rails'
end
