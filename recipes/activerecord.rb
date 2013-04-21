# >-----------------------------[ ActiveRecord ]------------------------------<

@current_recipe = "activerecord"
@before_configs["activerecord"].call if @before_configs["activerecord"]
say_recipe 'ActiveRecord'

config = {}

if preference_exists? :database
  config['database'] = preference :database
else
  config['database'] = multiple_choice("Which database are you using?", [["MySQL", "mysql"], ["Oracle", "oracle"], ["PostgreSQL", "postgresql"], ["SQLite", "sqlite3"], ["Frontbase", "frontbase"], ["IBM DB", "ibm_db"]]) if true && true unless config.key?('database')
end

if preference_exists? :create_database
  config['auto_create'] = preference :create_database
else
  config['auto_create'] = yes_wizard?("Automatically create database with default configuration?") if true && true unless config.key?('auto_create')
end

@configs[@current_recipe] = config

if config['database']
  say_wizard "Configuring '#{config['database']}' database settings..."
  old_gem = gem_for_database
  @options = @options.dup.merge(:database => config['database'])
  gsub_file 'Gemfile', "gem '#{old_gem}'", "gem '#{gem_for_database}'"
  template "config/databases/#{@options[:database]}.yml", "config/database.yml.new"
  run 'mv config/database.yml.new config/database.yml'
end

after_bundler do
  rake "db:create:all" if config['auto_create']
end
