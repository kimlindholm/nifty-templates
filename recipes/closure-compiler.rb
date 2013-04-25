# >---------------------------------[ Closure Compiler ]---------------------------------<

@current_recipe = "closure-compiler"
@before_configs["closure-compiler"].call if @before_configs["closure-compiler"]
say_recipe 'Closure Compiler'


@configs[@current_recipe] = config

# Try including Closure Compiler if rake assets:precompile fails on Heroku
# http://stackoverflow.com/questions/7877180/ror-precompiling-assets-fail-while-rake-assetsprecompile-on-basically-empty-a

text_to_add = <<-RUBY
  config.assets.js_compressor = :closure
RUBY

gem 'closure-compiler', group: :production

production_path = "config/environments/production.rb"

if File.exist?(production_path)
  unless File.readlines(production_path).
      grep(/config.assets.js_compressor/).any?
    append_to_block_in_file(production_path,
                            "\n#{text_to_add}",
                            "::Application.configure do",
                            "end")
  end
else
  say_error "production.rb not found, Closure Compiler setup failed"
end
