# >---------------------------------[ Rack::Bug ]---------------------------------<

@current_recipe = "rack-bug"
@before_configs["rack-bug"].call if @before_configs["rack-bug"]
say_recipe 'Rack::Bug'


@configs[@current_recipe] = config

text_to_add_first = <<-RUBY
require "rack/bug"
RUBY

text_to_add_configure = <<-RUBY
  config.middleware.use "Rack::Bug",
      ip_masks: [IPAddr.new("127.0.0.1")],
      secret_key: "#{create_random_token}"
RUBY

gem 'rack-bug', git: 'https://github.com/brynary/rack-bug.git',
                group: :development,
                branch: 'rails3'

development_path = "config/environments/development.rb"

if File.exist?(development_path)
  prepend_file development_path, "#{text_to_add_first}\n"

  append_to_block_in_file(development_path,
                          "\n#{text_to_add_configure}\n",
                          "::Application.configure do",
                          "end")
else
  say_error "development.rb not found, Rack::Bug setup failed"
end
