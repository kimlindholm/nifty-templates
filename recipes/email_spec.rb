# >---------------------------------[ Email Spec ]---------------------------------<

@current_recipe = "email_spec"
@before_configs["email_spec"].call if @before_configs["email_spec"]
say_recipe 'Email Spec'


@configs[@current_recipe] = config

text_to_add_first = <<-RUBY
  require 'email_spec'
RUBY

text_to_add_configure = <<-RUBY
    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)
RUBY

if recipe?("rspec")
  gem 'email_spec', group: :test

  after_bundler do
    spec_helper_path = "spec/spec_helper.rb"

    if File.exist?(spec_helper_path)
      inject_into_file spec_helper_path, after: "require 'rspec/autorun'\n" do
        text_to_add_first
      end

      append_to_block_in_file(spec_helper_path,
                              "\n#{text_to_add_configure}",
                              "RSpec.configure do |config|",
                              "end")
    else
      say_error "spec_helper.rb not found, email_spec setup failed"
    end
  end
else
  say_error "RSpec not found, skipping"
end
