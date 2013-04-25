# >---------------------------------[ Better Errors ]---------------------------------<

@current_recipe = "better_errors"
@before_configs["better_errors"].call if @before_configs["better_errors"]
say_recipe 'Better Errors'


@configs[@current_recipe] = config

gem 'binding_of_caller', group: :development
gem 'better_errors', group: :development
