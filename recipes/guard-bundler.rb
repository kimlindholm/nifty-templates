# >---------------------------------[ Guard Bundler ]---------------------------------<

@current_recipe = "guard-bundler"
@before_configs["guard-bundler"].call if @before_configs["guard-bundler"]
say_recipe 'Guard Bundler'


@configs[@current_recipe] = config

gem 'guard-bundler', group: :development

after_bundler do
  run 'bundle exec guard init bundler'
end
