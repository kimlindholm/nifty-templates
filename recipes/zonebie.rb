# >---------------------------------[ Zonebie ]---------------------------------<

@current_recipe = "zonebie"
@before_configs["zonebie"].call if @before_configs["zonebie"]
say_recipe 'Zonebie'


@configs[@current_recipe] = config

gem 'zonebie', group: :test

after_bundler do
  spec_helper_path = "spec/spec_helper.rb"
  text_to_add_each_run = "Zonebie.set_random_timezone"

  if File.exist?(spec_helper_path)
    if File.readlines(spec_helper_path).grep(/Spork.each_run do/).any?
      append_to_block_in_file(spec_helper_path,
                              text_to_add_each_run,
                              "Spork.each_run do",
                              "end")
    else
      append_file spec_helper_path, "\n#{text_to_add_each_run}"
    end
  else
    say_error "spec_helper.rb not found, Zonebie setup failed"
  end
end
