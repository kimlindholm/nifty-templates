# >---------------------------------[ Guard RSpec ]---------------------------------<

@current_recipe = "guard-rspec"
@before_configs["guard-rspec"].call if @before_configs["guard-rspec"]
say_recipe 'Guard RSpec'


@configs[@current_recipe] = config

if recipe?("rspec")
  gem 'guard-rspec', group: [:development, :test]

  after_bundler do
    if recipe?("guard-spork") && !File.exist?("Guardfile")
      say_error "Invoke Guard Spork recipe first. Guard RSpec is NOT" +
                " properly configured."
    else
      run 'bundle exec guard init rspec'
    end
  end
else
  say_error "RSpec not found, skipping"
end
