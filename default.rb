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
  gemset: "1.9.3-p194@rails3.2",
  unicorn_workers: 3
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
  "fakeweb",

  # Matchers
  "shoulda-matchers", "email_spec", "api_matchers", "delayed_job_matcher"
]

apply_recipes @recipes

# Run bundler and callbacks
apply_after_hooks
