# >---------------------------------[ Guard Jasmine ]---------------------------------<

@current_recipe = "guard-jasmine"
@before_configs["guard-jasmine"].call if @before_configs["guard-jasmine"]
say_recipe 'Guard Jasmine'


@configs[@current_recipe] = config

if recipe?("jasminerice") || recipe?("jasmine")
  gem 'guard-jasmine', :group => [:development, :test]

  after_bundler do
    run 'bundle exec guard init jasmine'
    gsub_file 'Guardfile',
              'guard :jasmine do',
              'guard :jasmine, server_env: :test do'
  end
else
  say_error "Jasminerice or Jasmine not found, skipping"
end
