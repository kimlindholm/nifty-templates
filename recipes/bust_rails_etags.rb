# >---------------------------------[ Bust Rails Etags ]---------------------------------<

@current_recipe = "bust_rails_etags"
@before_configs["bust_rails_etags"].call if @before_configs["bust_rails_etags"]
say_recipe 'Bust Rails Etags'


@configs[@current_recipe] = config

gem 'heroku-api'
gem 'bust_rails_etags'

create_file "config/initializers/bust_http_cache.rb", <<-RUBY
require 'heroku-api'

# Add your credentials and uncomment:
# heroku = Heroku::API.new(:api_key => "YOUR_API_KEY")
# release_version = heroku.get_releases('YOUR_APP_NAME').body.last
#
# ENV["ETAG_VERSION_ID"] = release_version["name"]
RUBY
