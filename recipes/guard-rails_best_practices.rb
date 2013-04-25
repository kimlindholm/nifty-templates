# >---------------------------------[ Guard Rails Best Practices ]---------------------------------<

@current_recipe = "guard-rails_best_practices"
@before_configs["guard-rails_best_practices"].call if @before_configs["guard-rails_best_practices"]
say_recipe 'Guard Rails Best Practices'


@configs[@current_recipe] = config

gem 'sexp_processor', '>= 3.0', group: :development
gem 'guard-rails_best_practices', group: :development

after_bundler do
  run 'rails_best_practices -g'
  run 'bundle exec guard init rails_best_practices'

  append_to_block_in_file("Guardfile",
                          "watch('config/rails_best_practices.yml')",
                          "guard 'rails_best_practices' do",
                          "end")

  gsub_file "Guardfile",
            "guard 'rails_best_practices' do",
            "guard 'rails_best_practices', exclude: '/config/,/db/' do"
end
