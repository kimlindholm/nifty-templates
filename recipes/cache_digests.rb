# >---------------------------------[ Cache Digests ]---------------------------------<

@current_recipe = "cache_digests"
@before_configs["cache_digests"].call if @before_configs["cache_digests"]
say_recipe 'Cache Digests'


@configs[@current_recipe] = config

gem 'cache_digests'
