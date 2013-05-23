# >---------------------------------[ Quiet Assets ]---------------------------------<

@current_recipe = "quiet_assets"
@before_configs["quiet_assets"].call if @before_configs["quiet_assets"]
say_recipe 'Quiet Assets'


@configs[@current_recipe] = config

gem 'quiet_assets', group: :development
