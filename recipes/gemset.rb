# >----------------------------------[ Gemset ]----------------------------------<

@current_recipe = "gemset"
@before_configs["gemset"].call if @before_configs["gemset"]
say_recipe 'Gemset'

config = {}

if preference_exists? :ruby_version
  config['ruby_version'] = preference :ruby_version unless config.key?('ruby_version')
else
  config['ruby_version'] = ask_wizard("Specify an existing Ruby version (or leave blank):") unless config.key?('ruby_version')
end

if preference_exists? :gemset
  config['gemset'] = preference :gemset unless config.key?('gemset')
else
  config['gemset'] = ask_wizard("Specify an existing gemset (or leave blank):") unless config.key?('gemset')
end

@configs[@current_recipe] = config

pow_config = <<-SH
if [ -f "$rvm_path/scripts/rvm" ] && [ -f ".ruby-version" ] && [ -f ".ruby-gemset" ] ; then
  source "$rvm_path/scripts/rvm"
  rvm use `cat .ruby-version`@`cat .ruby-gemset`
fi
SH

if config['ruby_version'].present? && config['gemset'].present?
  create_file ".ruby-version", force: true do
    config['ruby_version']
  end
  
  create_file ".ruby-gemset", force: true do
    config['gemset']
  end

  create_file ".powrc", pow_config if recipe?("pow")
end
