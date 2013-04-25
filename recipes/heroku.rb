# >--------------------------------[ Heroku ]---------------------------------<

@current_recipe = "heroku"
@before_configs["heroku"].call if @before_configs["heroku"]
say_recipe 'Heroku'

config = {}

if preference_exists? :heroku_name
  config['create'] = true unless config.key?('create')
  config['domain'] = "" unless config.key?('domain')
  config['deploy'] = true if config['create'] && true unless config.key?('deploy')
  heroku_name = preference(:heroku_name).gsub('_','')
else
  config['create'] = yes_wizard?("Automatically create appname.herokuapp.com?") if true && true unless config.key?('create')
  config['domain'] = ask_wizard("Specify custom domain (or leave blank):") if config['create'] && true unless config.key?('domain')
  config['deploy'] = yes_wizard?("Deploy immediately?") if config['create'] && true unless config.key?('deploy')
  heroku_name = app_name.gsub('_','')
end

say_wizard "Using Heroku app name '#{heroku_name}'"

if preference_exists? :heroku_staging
  config['staging'] = preference :heroku_staging if config['create'] && true unless config.key?('staging')
else
  config['staging'] = yes_wizard?("Create staging app? (appname-staging.herokuapp.com)") if config['create'] && true unless config.key?('staging')
end

@configs[@current_recipe] = config

application_path = "config/application.rb"

# Skip connecting to the database while precompiling assets on Heroku
if File.exist?(application_path)
  if File.readlines(application_path).
      grep(/config.assets.initialize_on_precompile = true/).any?
    gsub_file application_path,
              "config.assets.initialize_on_precompile = true",
              "config.assets.initialize_on_precompile = false"
  else
    application "config.assets.initialize_on_precompile = false\n"
  end
else
  say_error "application.rb not found, Heroku setup failed"
end

# Declare Ruby version in Gemfile before gem 'rails' or gem "rails"
if preference_exists? :heroku_ruby_version
  grep_results = File.readlines("Gemfile").grep(/^gem (\'|\")rails(\'|\")/)
  if grep_results.any?
    inject_into_file "Gemfile", before: grep_results.first do
      "ruby '#{preference :heroku_ruby_version}'\n"
    end
  end
end

after_everything do
  if config['create']
    say_wizard "Creating Heroku app '#{heroku_name}.herokuapp.com'"
    while !system("heroku create #{heroku_name}")
      heroku_name = ask_wizard("What do you want to call your app? ")
    end
    config['heroku_name'] = heroku_name
  end

  if config['staging']
    config['staging_name'] = "#{config['heroku_name']}-staging"
    say_wizard "Creating staging Heroku app \'#{config['staging_name']}.herokuapp.com\'"
    while !system("heroku create #{config['staging_name']}")
      config['staging_name'] = ask_wizard("What do you want to call your staging app?")
    end

    git :remote => "rm heroku"
    git :remote => "add production git@heroku.com:#{config['heroku_name']}.git"
    git :remote => "add staging git@heroku.com:#{config['staging_name']}.git"
    say_wizard "Created branches 'production' and 'staging' for Heroku deploy."
  end

  unless config['domain'].blank?
    run "heroku addons:add custom_domains"
    run "heroku domains:add #{config['domain']}"
  end

  rake "assets:precompile RAILS_ENV=production"
  git :add => '.'
  git :commit => '-m "Precompiled assets for Heroku"'
  git :push => "#{config['staging'] ? 'staging' : 'heroku'} master" if config['deploy']
end
