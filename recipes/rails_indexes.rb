# >---------------------------------[ Rails Indexes ]---------------------------------<

@current_recipe = "rails_indexes"
@before_configs["rails_indexes"].call if @before_configs["rails_indexes"]
say_recipe 'Rails Indexes'


@configs[@current_recipe] = config

gem 'rails_indexes', github: 'warpc/rails_indexes', group: :development
