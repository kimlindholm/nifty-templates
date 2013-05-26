# >---------------------------------------------------------------------------<
#   This template is a modified version of code generated by RailsWizard.
#   See http://railswizard.org for more recipes.
# >---------------------------------------------------------------------------<

@template_path = File.dirname(__FILE__)
apply "#{@template_path}/initial_setup.rb"

# Set default values or leave empty to be prompted
@preferences = {
  database: "postgresql", # "postgresql", "oracle", "mysql", "ibm_db" etc.
  create_database: true,
  gemset: "ruby-2.0.0-p0@rails3.2",
  unicorn_workers: 3,
  heroku_name: "#{app_name}-#{create_random_number}",
  heroku_ruby_version: "2.0.0",
  heroku_staging: false,
  doorcode: "12345"
}

@recipes = [
  # Common
  "cleanup", "gem_groups", "gemset", "activerecord", "postgres_user",
  "pow", "unicorn", "gitignore", "git",

  # Automation
  "guard-bundler", "guard-pow", "guard-mozrepl", "guard-annotate",
  "guard-yard",

  # Performance and security
  "guard-brakeman", "strong_parameters", "bullet", "rails_indexes",
  "rails-footnotes", "oink",

  # Testing
  "rspec", "guard-spork", "guard-rspec", "deferred_gc", "konacha",
  "guard-konacha", "better_errors", "factory_girl_rails", "timecop",
  "zonebie", "fakeweb",

  # Matchers
  "shoulda-matchers", "email_spec", "api_matchers", "delayed_job_matcher",
  "konacha-chai-matchers",

  # Code quality
  "guard-rails_best_practices", "guard-jslint-on-rails", "simplecov",

  # Deployment
  "turbo-sprockets-rails3", "closure-compiler", "heroku", "heroku_san",

  # Miscellaneous
  "settingslogic", "figaro", "nifty-generators", "faker", "rails-erd",
  "growl", "request-log-analyzer", "transaction_retry", "sextant",
  "quiet_assets",

  # Rack middleware
  "rack-mini-profiler", "rack-bug", "door_code", "rack-throttle",

  # Rake tasks
  "rake_browser", "rake_metrics", "rake_performance", "rake_heroku_assets"
]

apply_recipes @recipes

# Run bundler and callbacks
apply_after_hooks
