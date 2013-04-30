# >---------------------------------[ Tries ]---------------------------------<

@current_recipe = "tries"
@before_configs["tries"].call if @before_configs["tries"]
say_recipe 'Tries'


@configs[@current_recipe] = config

gem 'tries'
