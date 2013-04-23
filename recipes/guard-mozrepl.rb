# >---------------------------------[ Guard MozRepl ]---------------------------------<

@current_recipe = "guard-mozrepl"
@before_configs["guard-mozrepl"].call if @before_configs["guard-mozrepl"]
say_recipe 'Guard MozRepl'


@configs[@current_recipe] = config

gem 'guard-mozrepl', group: :development

text_to_add = <<-RUBY
  watch(%r{^app/assets/.+$})
RUBY

after_bundler do
  run 'bundle exec guard init mozrepl'

  inject_into_file "Guardfile", after: "guard 'mozrepl' do\n" do
    text_to_add
  end
end
