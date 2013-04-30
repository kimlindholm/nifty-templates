# >---------------------------------[ Oj ]---------------------------------<

@current_recipe = "oj"
@before_configs["oj"].call if @before_configs["oj"]
say_recipe 'Oj'


@configs[@current_recipe] = config

gem 'oj'
