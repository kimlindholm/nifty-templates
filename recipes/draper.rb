# >---------------------------------[ Draper ]---------------------------------<

@current_recipe = "draper"
@before_configs["draper"].call if @before_configs["draper"]
say_recipe 'Draper'


@configs[@current_recipe] = config

text_to_add_prefork = <<-RUBY
  require 'draper/test/rspec_integration'
RUBY

gem 'draper'

after_bundler do
  spec_helper_path = "spec/spec_helper.rb"

  if File.exist?(spec_helper_path)
    if File.readlines(spec_helper_path).grep(/Spork.prefork do/).any?
      inject_into_file spec_helper_path, after: "require 'rspec/autorun'\n" do
        text_to_add_prefork
      end
    end
  else
    say_error "spec_helper.rb not found, Draper setup failed"
  end
end
