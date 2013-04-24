# >---------------------------------[ Guard Annotate ]---------------------------------<

@current_recipe = "guard-annotate"
@before_configs["guard-annotate"].call if @before_configs["guard-annotate"]
say_recipe 'Guard Annotate'


@configs[@current_recipe] = config

gem 'guard-annotate', group: :development

before_end do
  run 'bundle exec guard init annotate'

  inject_into_file "Guardfile", after: "guard 'annotate'" do
    ", show_indexes: true"
  end
end
