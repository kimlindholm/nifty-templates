# >---------------------------------[ Multi-fetch Fragments ]---------------------------------<

@current_recipe = "multi_fetch_fragments"
@before_configs["multi_fetch_fragments"].call if @before_configs["multi_fetch_fragments"]
say_recipe 'Multi-fetch Fragments'


@configs[@current_recipe] = config

gem 'multi_fetch_fragments'
