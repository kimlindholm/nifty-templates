# >---------------------------------[ Strong Parameters ]---------------------------------<

@current_recipe = "strong_parameters"
@before_configs["strong_parameters"].call if @before_configs["strong_parameters"]
say_recipe 'Strong Parameters'


@configs[@current_recipe] = config

gem 'strong_parameters'
