# >----------------------------------[ Rake - metrics ]----------------------------------<

@current_recipe = "rake_metrics"
@before_configs["rake_metrics"].call if @before_configs["rake_metrics"]
say_recipe 'Rake - metrics'


@configs[@current_recipe] = config

append_file ".gitignore", "public/metrics/\n"

rakefile("metrics.rake") do <<-TASK
namespace :app do
  desc "Create Rails Best Practices HTML report"
  task :metrics do
    puts "\033[1m\033[36mRunning Rails Best Practices...\033[0m"
    system "mkdir -p public/metrics"
    system "rails_best_practices -f html \
                                 --output-file public/metrics/index.html \
                                 -x '/config/,/db/'"
    puts "Report is now ready at http://#{app_name}.dev/metrics\n"
  end
end
TASK
end
