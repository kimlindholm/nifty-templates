# >---------------------------------[ Figaro ]---------------------------------<

@current_recipe = "figaro"
@before_configs["figaro"].call if @before_configs["figaro"]
say_recipe 'Figaro'


@configs[@current_recipe] = config

gem 'figaro'

after_bundler do
  generate 'figaro:install'
end
