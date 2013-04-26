# >---------------------------------[ Sextant ]---------------------------------<

@current_recipe = "sextant"
@before_configs["sextant"].call if @before_configs["sextant"]
say_recipe 'Sextant'


@configs[@current_recipe] = config

gem 'sextant', group: :development
