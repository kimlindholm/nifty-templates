# >---------------------------------[ Oink ]---------------------------------<

@current_recipe = "oink"
@before_configs["oink"].call if @before_configs["oink"]
say_recipe 'Oink'


@configs[@current_recipe] = config

gem 'oink', '~> 0.9.3', group: :development

capitalized_name = app_name.titleize.gsub(/\s+/, '')

create_file "config/initializers/oink.rb", <<-RUBY
if Rails.env.development?
  require 'oink'

  #{capitalized_name}::Application.middleware.use Oink::Middleware, logger: Rails.logger
end
RUBY
