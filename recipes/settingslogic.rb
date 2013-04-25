# >-----------------------------[ Settingslogic ]-----------------------------<

@current_recipe = "settingslogic"
@before_configs["settingslogic"].call if @before_configs["settingslogic"]
say_recipe 'Settingslogic'


@configs[@current_recipe] = config

gem 'settingslogic'

create_file "app/models/settings.rb", <<-RUBY
class Settings < Settingslogic
  source "#\{Rails.root\}/config/config.yml"
  namespace Rails.env
end
RUBY

say_wizard "Generating config/config.yml..."

create_file "config/config.yml", <<-YAML
defaults: &defaults
  cool:
    saweet: nested settings
  neat_setting: 24
  awesome_setting: <%= "Did you know 5 + 5 = #{5 + 5}?" %>

development:
  <<: *defaults
  neat_setting: 800

test:
  <<: *defaults

production:
  <<: *defaults
YAML
