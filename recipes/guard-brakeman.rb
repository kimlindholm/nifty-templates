# >---------------------------------[ Guard Brakeman ]---------------------------------<

@current_recipe = "guard-brakeman"
@before_configs["guard-brakeman"].call if @before_configs["guard-brakeman"]
say_recipe 'Guard Brakeman'


@configs[@current_recipe] = config

gem 'guard-brakeman', group: :development

run 'mkdir -p public/brakeman'
append_file ".gitignore", "public/brakeman/\n"

after_bundler do
  run 'bundle exec guard init brakeman'

  inject_into_file "Guardfile", after: "guard 'brakeman'" do
    ", output_files: ['public/brakeman/index.html'], chatty: true"
  end
end
