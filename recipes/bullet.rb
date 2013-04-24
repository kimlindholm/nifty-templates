# >---------------------------------[ Bullet ]---------------------------------<

@current_recipe = "bullet"
@before_configs["bullet"].call if @before_configs["bullet"]
say_recipe 'Bullet'


@configs[@current_recipe] = config

gem 'bullet', group: :development

create_file "config/initializers/bullet.rb", <<-RUBY
if defined? Bullet
  Bullet.enable = true
  Bullet.alert = true
  Bullet.bullet_logger = true
  # Bullet.growl = true
  # Bullet.rails_logger = true
  # Bullet.airbrake = true
  # Bullet.disable_browser_cache = true
end
RUBY
