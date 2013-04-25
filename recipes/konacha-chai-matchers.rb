# >---------------------------------[ Konacha Chai Matchers ]---------------------------------<

@current_recipe = "konacha-chai-matchers"
@before_configs["konacha-chai-matchers"].call if @before_configs["konacha-chai-matchers"]
say_recipe 'Konacha Chai Matchers'


@configs[@current_recipe] = config

gem 'konacha-chai-matchers', :group => [:development, :test]
