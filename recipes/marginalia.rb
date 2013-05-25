# >---------------------------------[ marginalia ]---------------------------------<

@current_recipe = "marginalia"
@before_configs["marginalia"].call if @before_configs["marginalia"]
say_recipe 'marginalia'


@configs[@current_recipe] = config

gem 'marginalia'

grep_results = File.readlines("config/application.rb")
               .grep(/require ('|")rails.+$/)
if grep_results.any?
  inject_into_file "config/application.rb", after: grep_results.first do
    "require \"marginalia/railtie\"\n"
  end
end
