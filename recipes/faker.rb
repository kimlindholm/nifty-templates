# >---------------------------------[ Faker ]---------------------------------<

@current_recipe = "faker"
@before_configs["faker"].call if @before_configs["faker"]
say_recipe 'Faker'


@configs[@current_recipe] = config

gem 'faker'
