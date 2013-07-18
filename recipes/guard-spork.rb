# >---------------------------------[ Guard Spork ]---------------------------------<

@current_recipe = "guard-spork"
@before_configs["guard-spork"].call if @before_configs["guard-spork"]
say_recipe 'Guard Spork'


@configs[@current_recipe] = config

if recipe?("rspec")
  gem 'rb-inotify', require: false, group: [:development, :test]
  gem 'rb-fsevent', require: false, group: [:development, :test]
  gem 'rb-fchange', require: false, group: [:development, :test]
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard-spork', group: :test

  after_bundler do
    if File.exist?(".rspec")
      append_file ".rspec", "--drb"
    else
      say_warning "File .rspec not found, skipping. Hint: invoke RSpec" +
                  " recipe first if you use it with Spork"
    end

    run 'bundle exec guard init spork'

    spec_helper_path = "spec/spec_helper.rb"
    if File.exist?(spec_helper_path)
      # Step 1: capture contents of spec_helper.rb
      spec_helper_original_content = File.read(spec_helper_path)
      create_file spec_helper_path, "", :force => true

      # Step 2: add Spork blocks to empty spec_helper.rb
      run 'spork --bootstrap'

      # Step 3: indent original content and move it inside Spork.prefork block
      append_to_block_in_file(spec_helper_path,
                              spec_helper_original_content.gsub(/\n/, "\n  "),
                              "Spork.prefork do",
                              "end")
    else
      say_error "spec_helper.rb not found, Spork setup failed"
    end
  end
else
  say_error "RSpec not found, skipping"
end
