# >---------------------------------[ RSpec ]---------------------------------<

@current_recipe = "rspec"
@before_configs["rspec"].call if @before_configs["rspec"]
say_recipe 'RSpec'


@configs[@current_recipe] = config

gem 'rspec-rails', '>= 2.12.0', :group => [:development, :test]

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "  g.test_framework = :rspec\n"
end

after_bundler do
  generate 'rspec:install'
end
