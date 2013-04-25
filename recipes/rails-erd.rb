# >---------------------------------[ Rails ERD ]---------------------------------<

@current_recipe = "rails-erd"
@before_configs["rails-erd"].call if @before_configs["rails-erd"]
say_recipe 'Rails ERD'


@configs[@current_recipe] = config

gem 'rails-erd', group: :development
