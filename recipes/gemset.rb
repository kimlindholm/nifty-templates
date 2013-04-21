# >----------------------------------[ Gemset ]----------------------------------<

@current_recipe = "gemset"
@before_configs["gemset"].call if @before_configs["gemset"]
say_recipe 'Gemset'

config = {}

if preference_exists? :gemset
  config['gemset'] = preference :gemset unless config.key?('gemset')
else
  config['gemset'] = ask_wizard("Specify an existing gemset (or leave blank):") unless config.key?('gemset')
end

@configs[@current_recipe] = config

pow_config = <<-SH
if [ -f "$rvm_path/scripts/rvm" ] && [ -f ".rvmrc" ]; then
  source "$rvm_path/scripts/rvm"
  source ".rvmrc"
fi
SH

unless config['gemset'].blank?
  create_file ".rvmrc", :force => true do
    "rvm use #{config['gemset']}"
  end

  create_file ".powrc", pow_config if recipe?("pow")
end
