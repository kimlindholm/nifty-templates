# >---------------------------------[ Factory Girl Rails ]---------------------------------<

@current_recipe = "factory_girl_rails"
@before_configs["factory_girl_rails"].call if @before_configs["factory_girl_rails"]
say_recipe 'Factory Girl Rails'


@configs[@current_recipe] = config

gem 'factory_girl_rails', group: :test
