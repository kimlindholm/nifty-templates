# >---------------------------------[ Arcane ]---------------------------------<

@current_recipe = "arcane"
@before_configs["arcane"].call if @before_configs["arcane"]
say_recipe 'Arcane'


@configs[@current_recipe] = config

gem 'arcane', '~> 1.1.0'

initializer "arcane.rb", <<-RUBY
ApplicationController.send :include, Arcane
RUBY

after_bundler do
  generate 'arcane:install'
end
