# >---------------------------------[ Inherited Resources ]---------------------------------<

@current_recipe = "inherited_resources"
@before_configs["inherited_resources"].call if @before_configs["inherited_resources"]
say_recipe 'Inherited Resources'


@configs[@current_recipe] = config

gem 'inherited_resources'
gem 'has_scope'
gem 'responders'
