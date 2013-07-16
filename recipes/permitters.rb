# >---------------------------------[ Permitters ]---------------------------------<

@current_recipe = "permitters"
@before_configs["permitters"].call if @before_configs["permitters"]
say_recipe 'Permitters'


@configs[@current_recipe] = config

gem 'permitters', '~> 0.0.1'

initializer "permitters.rb", <<-RUBY
ActionController::Base.send :include, ActionController::Permittance
RUBY

run 'mkdir -p app/permitters'
