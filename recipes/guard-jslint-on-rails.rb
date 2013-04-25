# >---------------------------------[ Guard JSLint on Rails ]---------------------------------<

@current_recipe = "guard-jslint-on-rails"
@before_configs["guard-jslint-on-rails"].call if @before_configs["guard-jslint-on-rails"]
say_recipe 'Guard JSLint on Rails'


@configs[@current_recipe] = config

gem 'guard-jslint-on-rails', group: :development

after_bundler do
  run 'bundle exec guard init jslint-on-rails'
end
