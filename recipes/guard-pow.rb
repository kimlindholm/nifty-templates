# >---------------------------------[ Guard Pow ]---------------------------------<

@current_recipe = "guard-pow"
@before_configs["guard-pow"].call if @before_configs["guard-pow"]
say_recipe 'Guard Pow'


@configs[@current_recipe] = config

gem 'guard-pow', group: :development

after_bundler do
  run 'bundle exec guard init pow'
end
