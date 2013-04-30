# >---------------------------------[ Memoist ]---------------------------------<

@current_recipe = "memoist"
@before_configs["memoist"].call if @before_configs["memoist"]
say_recipe 'Memoist'


@configs[@current_recipe] = config

gem 'memoist'
