# >----------------------------------[ Gem groups ]----------------------------------<

@current_recipe = "gem_groups"
@before_configs["gem_groups"].call if @before_configs["gem_groups"]
say_recipe 'Gem groups'


@configs[@current_recipe] = config

gem_group :development do end
gem_group :development, :production do end
gem_group :development, :test do end
gem_group :production do end
gem_group :test do end
