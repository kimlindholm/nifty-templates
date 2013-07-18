# >----------------------------------[ Cleanup ]----------------------------------<

@current_recipe = "cleanup"
@before_configs["cleanup"].call if @before_configs["cleanup"]
say_recipe 'Cleanup'


@configs[@current_recipe] = config

%w{
  README.rdoc
  public/robots.txt
}.each { |file| remove_file file }

# Gemfile: remove commented lines and replace multiple blank lines with one
gsub_file 'Gemfile', /#.*\n/, ""
gsub_file 'Gemfile', /^[\s]*$\n/, "\n"
gsub_file 'Gemfile', /\n\ngem/, "\ngem"
gsub_file 'Gemfile', /^gem 'rails'/, "\ngem 'rails'"

# config/routes.rb: remove commented lines and replace multiple blank lines with one
gsub_file 'config/routes.rb', /  #.*\n/, ""
gsub_file 'config/routes.rb', /^[\s]*$\n/, "\n"
