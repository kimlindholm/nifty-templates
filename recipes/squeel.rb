# >---------------------------------[ Squeel ]---------------------------------<

@current_recipe = "squeel"
@before_configs["squeel"].call if @before_configs["squeel"]
say_recipe 'Squeel'


@configs[@current_recipe] = config

gem 'squeel'
