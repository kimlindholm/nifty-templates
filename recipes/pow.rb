# >----------------------------------[ Pow ]----------------------------------<

@current_recipe = "pow"
@before_configs["pow"].call if @before_configs["pow"]
say_recipe 'Pow'


@configs[@current_recipe] = config

run "ln -s #{destination_root} ~/.pow/#{app_name}"
say_wizard "App is available at http://#{app_name}.dev/"
