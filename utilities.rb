# >---------------------------------------------------------------------------<
#   Utilities with potential to make development more productive and fun.
#   Applying this template to an existing project:
#
#     rake rails:template LOCATION=<path>/nifty-templates/utilities.rb
#
#   Run 'bundle install' if you get error "Could not find gem..."
# >---------------------------------------------------------------------------<

@template_path = File.dirname(__FILE__)
apply "#{@template_path}/initial_setup.rb"

# Set default values or leave empty to be prompted
@preferences = {}

@recipes = [
  # Code maintainability
  "inherited_resources", "draper", "pundit", "squeel", "pacecar",
  "link_to_action",

  # Performance and security
  "valium", "oj", "memoist", "turbolinks", "cache_digests",
  "multi_fetch_fragments", "bust_rails_etags", "negative-captcha",

  # Miscellaneous
  "marginalia", "tries",

  # Commit to repository
  "git"
]

apply_recipes @recipes

# Run bundler and callbacks
apply_after_hooks
