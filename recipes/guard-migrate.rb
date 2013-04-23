# >---------------------------------[ Guard Migrate ]---------------------------------<

@current_recipe = "guard-migrate"
@before_configs["guard-migrate"].call if @before_configs["guard-migrate"]
say_recipe 'Guard Migrate'


@configs[@current_recipe] = config

gem 'guard-migrate', group: :test

before_end do
  run 'bundle exec guard init migrate'
end
