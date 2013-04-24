# >---------------------------------[ Guard Konacha ]---------------------------------<

@current_recipe = "guard-konacha"
@before_configs["guard-konacha"].call if @before_configs["guard-konacha"]
say_recipe 'Guard Konacha'


@configs[@current_recipe] = config

# To use Poltergeist, edit Guardfile as follows:
#
# require 'capybara/poltergeist'
# guard :konacha, :driver => :poltergeist do
# end

gem 'guard-konacha', :group => [:development, :test]

after_bundler do
  run 'bundle exec guard init konacha'
end
