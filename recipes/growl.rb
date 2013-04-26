# >---------------------------------[ Growl ]---------------------------------<

@current_recipe = "growl"
@before_configs["growl"].call if @before_configs["growl"]
say_recipe 'Growl'


@configs[@current_recipe] = config

gem 'growl', '1.0.3', group: :test
