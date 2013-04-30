# >---------------------------------[ Turbolinks ]---------------------------------<

@current_recipe = "turbolinks"
@before_configs["turbolinks"].call if @before_configs["turbolinks"]
say_recipe 'Turbolinks'


@configs[@current_recipe] = config

text_to_add = <<-COFFEE
//= require turbolinks
COFFEE

gem 'turbolinks'

application_js_path = "app/assets/javascripts/application.js"

if File.exist?(application_js_path)
  unless File.readlines(application_js_path).grep(text_to_add).any?
    append_file(application_js_path, text_to_add)
  end
else
  say_error "application.js not found, Turbolinks setup failed"
end
