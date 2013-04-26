# >----------------------------------[ Rake - performance ]----------------------------------<

@current_recipe = "rake_performance"
@before_configs["rake_performance"].call if @before_configs["rake_performance"]
say_recipe 'Rake - performance'


@configs[@current_recipe] = config

append_file ".gitignore", "public/performance.html\n"

rakefile("performance.rake") do <<-TASK
namespace :app do
  desc "Alias for rla:report:html"
  task :performance do
    Rake::Task['rla:report:html'].execute
  end
end
TASK
end
