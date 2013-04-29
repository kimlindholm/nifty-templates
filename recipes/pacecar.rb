# >---------------------------------[ Pacecar ]---------------------------------<

@current_recipe = "pacecar"
@before_configs["pacecar"].call if @before_configs["pacecar"]
say_recipe 'Pacecar'


@configs[@current_recipe] = config

gem 'pacecar'
