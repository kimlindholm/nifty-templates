# >---------------------------------[ Rails Footnotes ]---------------------------------<

@current_recipe = "rails-footnotes"
@before_configs["rails-footnotes"].call if @before_configs["rails-footnotes"]
say_recipe 'Rails Footnotes'


@configs[@current_recipe] = config

gem 'rails-footnotes', group: :development

after_bundler do
  generate 'rails_footnotes:install'
end
