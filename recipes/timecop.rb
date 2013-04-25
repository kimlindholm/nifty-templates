# >---------------------------------[ Timecop ]---------------------------------<

@current_recipe = "timecop"
@before_configs["timecop"].call if @before_configs["timecop"]
say_recipe 'Timecop'


@configs[@current_recipe] = config

gem 'timecop', group: :test

after_bundler do
  spec_helper_path = "spec/spec_helper.rb"
  text_to_add = "Timecop.return"

  if File.exist?(spec_helper_path)
    if File.readlines(spec_helper_path).grep(/Spork.each_run do/).any?
      append_to_block_in_file(spec_helper_path,
                              text_to_add,
                              "Spork.each_run do",
                              "end")
    else
      append_file spec_helper_path, "\n#{text_to_add}"
    end
  else
    say_error "spec_helper.rb not found, Timecop setup failed"
  end
end
