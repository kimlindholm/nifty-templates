# >---------------------------------[ link_to_action ]---------------------------------<

@current_recipe = "link_to_action"
@before_configs["link_to_action"].call if @before_configs["link_to_action"]
say_recipe 'link_to_action'


@configs[@current_recipe] = config

gem 'link_to_action'
