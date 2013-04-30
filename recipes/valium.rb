# >---------------------------------[ Valium ]---------------------------------<

@current_recipe = "valium"
@before_configs["valium"].call if @before_configs["valium"]
say_recipe 'Valium'


@configs[@current_recipe] = config

gem 'valium'
