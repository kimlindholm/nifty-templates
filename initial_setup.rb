# >----------------------------[ Initial Setup ]------------------------------<

unless File.exist?('config/initializers/generators.rb')
  initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
end
RUBY
end

@template_path ||= File.dirname(__FILE__)
@recipes ||= {}

def recipes; @recipes end
def recipe?(name); @recipes.include?(name) end
def apply_recipes(recipes); recipes.each {|recipe| apply "#{@template_path}/recipes/#{recipe}.rb"} end

def preference_exists?(key); !@preferences.nil? && @preferences.key?(key) end
def preference(key); @preferences ||= {}; @preferences[key] end
def prefer?(key, value); preference_exists?(key) && @preferences[key].eql?(value) end

def create_random_token; rand(36**128).to_s(36) end
def create_random_number; 100 + rand(900) end
def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
def say_wizard(text); say_custom(@current_recipe || 'wizard', text) end
def say_warning(text); say "\033[1m\033[33m" + (@current_recipe || 'warning').rjust(10) + "\033[0m\033[33m" + "  #{text}" + "\033[0m" end
def say_error(text); say "\033[1m\033[31m" + (@current_recipe || 'error').rjust(10) + "\033[0m\033[31m" + "  #{text}" + "\033[0m" end

def ask_wizard(question)
  ask "\033[1m\033[30m\033[46m" + (@current_recipe || "prompt").rjust(10) + "\033[0m\033[36m" + "  #{question}\033[0m"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end

def no_wizard?(question); !yes_wizard?(question) end

def multiple_choice(question, choices)
  say_custom('question', question)
  values = {}
  choices.each_with_index do |choice,i|
    values[(i + 1).to_s] = choice[1]
    say_custom (i + 1).to_s + ')', choice[0]
  end
  answer = ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

# Modified version of gem() which places gems inside a group if one is found
# in Gemfile. This opinionated method forces single quotes.
#
# Gem group with the exact same name must already exist in the Gemfile,
# otherwise we'll fall back to default behavior. As a result, groups
# [:development, :test] and [:test, :development] are not considered equal.
#
# Input:
#   gem 'some_gem', '>= 1.2', group: :development
#   gem "another_gem", :group => :development
#
# Gemfile with the original version:
#   gem "some_gem", ">= 1.2", :group => :development
#   gem "another_gem", :group => :development
#
# Gemfile with this version:
#   group :development do
#     gem 'some_gem', '>= 1.2'
#     gem 'another_gem'
#   end
def gem(*args)
  options = args.extract_options!
  name, version = args

  # Set the message to be shown in logs. Uses the git repo if one is given,
  # otherwise use name (version).
  parts, message = [ name.inspect ], name
  if version ||= options.delete(:version)
    parts   << version.inspect
    message << " (#{version})"
  end
  message = options[:git] if options[:git]

  log :gemfile, message

  parts_without_group = parts.clone
  options.each do |option, value|
    str = "#{option}: #{value.inspect}"
    parts << str
    parts_without_group << str unless option == :group
  end

  in_root do
    if options.key?(:group)
      # remove brackets if any and prepend colon if missing
      group = options[:group].inspect.scan(/[[^\[\]]]/).join.to_sym

      group_definition = "group #{group} do"
      str = "gem #{parts_without_group.join(", ")}"
      return if append_to_gem_group(group_definition, str.gsub(/\"/, '\''))
    end

    str = "gem #{parts.join(", ")}"
    str = "  " + str if @in_group
    str = "\n" + str
    append_file "Gemfile", str.gsub(/\"/, '\'')
  end
end

# Appends a new line to gem group inside Gemfile. Returns true if gem group
# exists, otherwise false is returned. Gem group definition must be an exact
# match.
#
# Example of usage:
#   append_to_gem_group "group :development, :test do", "gem 'rspec-rails'"
def append_to_gem_group(gem_group_definition, new_line)
  append_to_block_in_file "Gemfile", new_line, gem_group_definition, "end"
end

# Appends a new line before the end of a block in the specified file. Note
# that only innermost blocks are found, not blocks that contain other blocks.
#
# E.g. input "end" will match "\nend\n" and "\n end\n" but not
# "This will end\nthe method" or "\nend this here and append\n".
def append_to_block_in_file(filename, new_line, start_string, end_string)
  original_block =
      File.read(filename)[/#{start_string}(.*?)\n(\s*)#{end_string}$/m]
  return false if original_block.nil? || original_block.empty?

  modified_block = append_line_before_tag(original_block, new_line, end_string)
  gsub_file filename, original_block, modified_block
  return true
end

# Appends a line before the end tag and returns the modified string while
# preserving the original indentation
def append_line_before_tag(string, new_line, tag)
  tag_with_leading_space = string[/(\s*)#{tag}$/m]
  tag_with_one_newline = tag_with_leading_space.sub(/(\n)+/, "\n")
  string = "#{string.chomp(tag)}  #{new_line.chomp}#{tag_with_one_newline}"
end

@current_recipe = nil
@configs = {}

@after_blocks = []
def after_bundler(&block); @after_blocks << [@current_recipe, block]; end
@after_everything_blocks = []
def after_everything(&block); @after_everything_blocks << [@current_recipe, block]; end
@before_end_blocks = []
def before_end(&block); @before_end_blocks << [@current_recipe, block]; end
@before_configs = {}
def before_config(&block); @before_configs[@current_recipe] = block; end

# >-----------------------------[ Run Bundler ]-------------------------------<

def apply_after_hooks
  @current_recipe = nil
  say_wizard "Running Bundler install. This will take a while."
  run 'bundle install'
  say_wizard "Running after Bundler callbacks."
  @after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

  @current_recipe = nil
  say_wizard "Running before end callbacks."
  @before_end_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

  @current_recipe = nil
  say_wizard "Running after everything callbacks."
  @after_everything_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}
end
