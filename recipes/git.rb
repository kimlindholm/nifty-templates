# >----------------------------------[ Git ]----------------------------------<

@current_recipe = "git"
@before_configs["git"].call if @before_configs["git"]
say_recipe 'Git'


@configs[@current_recipe] = config

after_everything do
  git :init
  git :add => '.'
  git :commit => '-m "Initial import"'
end
