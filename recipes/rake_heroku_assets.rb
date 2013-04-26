# >----------------------------------[ Rake - Heroku assets ]----------------------------------<

@current_recipe = "rake_heroku_assets"
@before_configs["rake_heroku_assets"].call if @before_configs["rake_heroku_assets"]
say_recipe 'Rake - Heroku assets'


# This rake task gets you started with deploying assets to Heroku. Once you
# have configured Amazon S3 or Rackspace, you can change to using Asset Sync
# or a similar gem.

@configs[@current_recipe] = config

rakefile_contents = <<-TASK
namespace :heroku do
  desc "Precompile assets and push to Heroku #{@configs["heroku"]['staging'] ? 'staging ' : ''}server"
  task :assets do
    Rake::Task['assets:precompile'].execute('RAILS_ENV=production')
    system "git add public/assets/"
    system "git commit -m 'Precompiled assets for Heroku (rake heroku:assets)' public/assets/"
    system "git push #{@configs["heroku"]['staging'] ? 'staging' : 'heroku'} master"
  end
end
TASK

if recipe?("git") && recipe?("heroku")
  rakefile "heroku_assets.rake", rakefile_contents
else
  say_error "Both Git and Heroku need to be present, skipping"
end
