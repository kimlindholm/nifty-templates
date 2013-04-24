# >---------------------------------[ Guard YARD ]---------------------------------<

@current_recipe = "guard-yard"
@before_configs["guard-yard"].call if @before_configs["guard-yard"]
say_recipe 'Guard YARD'


@configs[@current_recipe] = config

gem 'guard-yard', group: :development

append_file ".gitignore", ".yardoc/\n"

before_end do
  run 'bundle exec guard init yard'

  inject_into_file "Guardfile", after: "guard 'yard'" do
    ", port: '8000'"
  end
end
