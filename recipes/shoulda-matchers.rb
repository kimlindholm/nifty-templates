# >---------------------------------[ shoulda-matchers ]---------------------------------<

@current_recipe = "shoulda-matchers"
@before_configs["shoulda-matchers"].call if @before_configs["shoulda-matchers"]
say_recipe 'shoulda-matchers'


@configs[@current_recipe] = config

if recipe?("rspec")
  gem 'shoulda-matchers', group: :test
else
  say_error "RSpec not found, skipping"
end
