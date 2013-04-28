# >---------------------------------[ Draper ]---------------------------------<

@current_recipe = "draper"
@before_configs["draper"].call if @before_configs["draper"]
say_recipe 'Draper'


@configs[@current_recipe] = config

gem 'draper'
