# >---------------------------------[ Pundit ]---------------------------------<

@current_recipe = "pundit"
@before_configs["pundit"].call if @before_configs["pundit"]
say_recipe 'Pundit'


@configs[@current_recipe] = config

text_to_add_app_controller = <<-RUBY
  # Ensure that you haven't forgotten authorization
  include Pundit
  after_filter :verify_authorized, except: :index
RUBY

text_to_add_prefork = <<-RUBY
  require 'pundit/rspec'
RUBY

gem 'pundit'

after_bundler do
  generate 'pundit:install'

  app_controller_path = "app/controllers/application_controller.rb"

  if File.exist?(app_controller_path)
    grep_results = File.readlines(app_controller_path)
        .grep(/class ApplicationController.*$/)
    if grep_results.any?
      inject_into_file app_controller_path, after: grep_results.first do
        "#{text_to_add_app_controller}\n"
      end
    end
  else
    say_error "application_controller.rb not found, Pundit setup failed"
  end

  spec_helper_path = "spec/spec_helper.rb"

  if File.exist?(spec_helper_path)
    run 'mkdir -p spec/policies'

    if File.readlines(spec_helper_path).grep(/Spork.prefork do/).any?
      inject_into_file spec_helper_path, after: "require 'rspec/autorun'\n" do
        text_to_add_prefork
      end
    end
  else
    say_error "spec_helper.rb not found, Pundit setup failed"
  end
end
