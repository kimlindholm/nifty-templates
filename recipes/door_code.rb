# >---------------------------------[ Door Code ]---------------------------------<

@current_recipe = "door_code"
@before_configs["door_code"].call if @before_configs["door_code"]
say_recipe 'Door Code'


config = {}

if preference_exists? :doorcode
  config['doorcode'] = preference :doorcode
  say_wizard "Using door code #{config['doorcode']} that was set in preferences."
else
  config['doorcode'] = ask_wizard("3-6 digit PIN code to restrict access to your app:")
end

@configs[@current_recipe] = config

text_to_add = <<-RUBY
  config.middleware.use DoorCode::RestrictedAccess, code: '#{config['doorcode']}'
RUBY

gem 'door_code', group: :production

production_path = "config/environments/production.rb"

if File.exist?(production_path)
  append_to_block_in_file(production_path,
                          "\n#{text_to_add}",
                          "::Application.configure do",
                          "end")
else
  say_error "production.rb not found, Door Code setup failed"
end
