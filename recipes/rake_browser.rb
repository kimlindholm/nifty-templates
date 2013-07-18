# >----------------------------------[ Rake - browser ]----------------------------------<

@current_recipe = "rake_browser"
@before_configs["rake_browser"].call if @before_configs["rake_browser"]
say_recipe 'Rake - browser'


@configs[@current_recipe] = config

rakefile("browser.rake") do <<-TASK
namespace :app do
  desc "Open all project tabs in default browser on OS X"
  task :browser do
    puts "Opening browser tabs..."
    system "open http://#{app_name}.dev/" +
               " http://#{app_name}.dev/coverage" +
               " http://#{app_name}.dev/brakeman" +
               " http://#{app_name}.dev:3500" +
               " http://#{app_name}.dev/metrics" +
               " http://#{app_name}.dev/performance.html" +
               " http://doc.dev:8000/docs/frames/"
  end
end
TASK
end
