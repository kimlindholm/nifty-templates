# >---------------------------------[ Turbo Sprockets ]---------------------------------<

@current_recipe = "turbo-sprockets-rails3"
@before_configs["turbo-sprockets-rails3"].call if @before_configs["turbo-sprockets-rails3"]
say_recipe 'Turbo Sprockets'


@configs[@current_recipe] = config

gem 'turbo-sprockets-rails3', group: :assets
