# >---------------------------------[ Heroku San ]---------------------------------<

@current_recipe = "heroku_san"
@before_configs["heroku_san"].call if @before_configs["heroku_san"]
say_recipe 'Heroku San'


@configs[@current_recipe] = config

heroku_production = <<-YAML
production:
  app: HEROKU_NAME
  config:
    BUNDLE_WITHOUT: "development:test"
YAML

heroku_staging = <<-YAML
staging:
  app: STAGING_NAME
  config: &default
    BUNDLE_WITHOUT: "development:test"
YAML

if recipe?("heroku")
  gem 'heroku', group: :development
  gem 'heroku_san', group: :development

  config_path = "config/heroku.yml"

  after_everything do
    if @configs.key?("heroku") && @configs["heroku"].key?('heroku_name')
      create_file config_path, heroku_production
      gsub_file config_path,
                'HEROKU_NAME',
                @configs["heroku"]['heroku_name']

      if @configs["heroku"].key?('staging_name')
        append_file config_path, "\n#{heroku_staging}"
        gsub_file config_path,
                  'STAGING_NAME',
                  @configs["heroku"]['staging_name']
      end

      if recipe?("git")
        git :add => 'config/heroku.yml'
        git :commit => '-m "Added Heroku San configuration"'
      end
    else
      say_error "Heroku recipe must be invoked first, setup failed"
    end
  end
else
  say_error "Heroku not found, skipping"
end
