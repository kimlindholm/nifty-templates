# >---------------------------------[ API Matchers ]---------------------------------<

@current_recipe = "api_matchers"
@before_configs["api_matchers"].call if @before_configs["api_matchers"]
say_recipe 'API Matchers'


@configs[@current_recipe] = config

text_to_add_configure = <<-RUBY
config.include APIMatchers::RSpecMatchers
RUBY

if recipe?("rspec")
  gem 'api_matchers', group: :test

  after_bundler do
    spec_helper_path = "spec/spec_helper.rb"

    if File.exist?(spec_helper_path)
      append_to_block_in_file(spec_helper_path,
                              text_to_add_configure,
                              "RSpec.configure do |config|",
                              "end")
    else
      say_error "spec_helper.rb not found, API Matchers setup failed"
    end
  end
else
  say_error "RSpec not found, skipping"
end
