# >---------------------------------[ Fakeweb ]---------------------------------<

@current_recipe = "fakeweb"
@before_configs["fakeweb"].call if @before_configs["fakeweb"]
say_recipe 'Fakeweb'


@configs[@current_recipe] = config

gem 'fakeweb', group: :test

after_bundler do
  spec_helper_path = "spec/spec_helper.rb"
  text_to_add_first = "FakeWeb.allow_net_connect = false"
  text_to_add_each_run = "FakeWeb.clean_registry"

  if File.exist?(spec_helper_path)
    if File.readlines(spec_helper_path).grep(/Spork.prefork do/).any? &&
       File.readlines(spec_helper_path).grep(/Spork.each_run do/).any?
      inject_into_file spec_helper_path, before: "Spork.prefork do" do
        "#{text_to_add_first}\n\n"
      end

      append_to_block_in_file(spec_helper_path,
                              text_to_add_each_run,
                              "Spork.each_run do",
                              "end")
    else
      append_file spec_helper_path, "\n#{text_to_add_first}" +
                                    "\n#{text_to_add_each_run}"
    end
  else
    say_error "spec_helper.rb not found, Fakeweb setup failed"
  end
end
