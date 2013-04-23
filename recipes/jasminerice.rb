# >----------------------------------[ Jasminerice ]----------------------------------<

@current_recipe = "jasminerice"
@before_configs["jasminerice"].call if @before_configs["jasminerice"]
say_recipe 'Jasminerice'


@configs[@current_recipe] = config

gem 'jasminerice', group: [:development, :test]

# mock-ajax.js allows faking Ajax responses in your Jasmine tests
get "http://cloud.github.com/downloads/pivotal/jasmine-ajax/mock-ajax.js",
    "spec/javascripts/helpers/mock-ajax.js",
    force: true

after_bundler do
  generate 'jasminerice:install'
end
