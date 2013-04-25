# >---------------------------------[ Nifty Generators ]---------------------------------<

@current_recipe = "nifty-generators"
@before_configs["nifty-generators"].call if @before_configs["nifty-generators"]
say_recipe 'Nifty Generators'


@configs[@current_recipe] = config

gem 'nifty-generators', group: :development
