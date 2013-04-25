# >---------------------------------[ SimpleCov ]---------------------------------<

@current_recipe = "simplecov"
@before_configs["simplecov"].call if @before_configs["simplecov"]
say_recipe 'SimpleCov'


@configs[@current_recipe] = config

gem 'simplecov', require: false, group: :test

append_file ".gitignore", "public/coverage/\n"

text_to_add_prefork = <<-RUBY
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.coverage_dir 'public/coverage'
    SimpleCov.start 'rails'
  end
RUBY

text_to_add_each_run = <<-RUBY
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.coverage_dir 'public/coverage'
    SimpleCov.start 'rails'
  end
RUBY

text_to_add_no_spork = <<-RUBY
require 'simplecov'
SimpleCov.start 'rails'
RUBY

after_bundler do
  spec_helper_path = "spec/spec_helper.rb"

  if File.exist?(spec_helper_path)
    if File.readlines(spec_helper_path).grep(/Spork.prefork do/).any? &&
       File.readlines(spec_helper_path).grep(/Spork.each_run do/).any?
      inject_into_file spec_helper_path, after: "Spork.prefork do\n" do
        "#{text_to_add_prefork}\n"
      end
      inject_into_file spec_helper_path, after: "Spork.each_run do\n" do
        "#{text_to_add_each_run}\n"
      end
    else
      inject_into_file spec_helper_path, after: "require 'rspec/autorun'\n" do
        "\n#{text_to_add_no_spork}"
      end
    end
  else
    say_error "spec_helper.rb not found, SimpleCov setup failed"
  end
end
