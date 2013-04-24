# >---------------------------------[ Konacha ]---------------------------------<

@current_recipe = "konacha"
@before_configs["konacha"].call if @before_configs["konacha"]
say_recipe 'Konacha'


@configs[@current_recipe] = config

# To use Poltergeist, uncomment the lines below. You also need to have
# PhantomJS installed. E.g. with Homebrew: 'brew install phantomjs'

# gem 'poltergeist', :group => [:development, :test]
gem 'selenium-webdriver', :group => [:development, :test]
gem 'konacha', :group => [:development, :test]

create_file "config/initializers/konacha.rb", <<-RUBY
if defined?(Konacha)
  # require 'capybara/poltergeist'

  Konacha.configure do |config|
    config.spec_dir    = "spec/javascripts"
    # config.driver      = :poltergeist
    config.stylesheets = %w(application)
  end
end
RUBY

create_file "spec/javascripts/spec_helper.js.coffee", <<-COFFEE
# set the Mocha test interface
# see http://visionmedia.github.com/mocha/#interfaces
# mocha.ui "bdd"

# ignore the following globals during leak detection
# mocha.globals ["YUI"]

# or, ignore all leaks
# mocha.ignoreLeaks()

# set slow test timeout in ms
# mocha.timeout 5

# Show stack trace on failing assertion.
# chai.Assertion.includeStack = true
COFFEE
