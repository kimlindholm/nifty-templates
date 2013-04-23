# >---------------------------------[ HAML ]----------------------------------<

@current_recipe = "haml"
@before_configs["haml"].call if @before_configs["haml"]
say_recipe 'HAML'


@configs[@current_recipe] = config

gem 'haml', '>= 3.0.0'
gem 'haml-rails'
