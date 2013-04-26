# >---------------------------------[ Rack::MiniProfiler ]---------------------------------<

@current_recipe = "rack-mini-profiler"
@before_configs["rack-mini-profiler"].call if @before_configs["rack-mini-profiler"]
say_recipe 'Rack::MiniProfiler'


@configs[@current_recipe] = config

# NB: Couldn't switch Rack::MiniProfiler off in production which is risky
# because url parameter ?pp=env reveals the Rack environment. Thus including
# the gem in development and staging only.

gem 'rack-mini-profiler', group: :development

text_to_add = <<-RUBY
  before_filter :miniprofiler

private

  def miniprofiler
    # Add if needed: if !@current_user.nil? && @current_user.admin?
    if Rails.env.in?("development", "staging") && defined? Rack::MiniProfiler
      Rack::MiniProfiler.authorize_request
    end
  end
RUBY

append_to_block_in_file("app/controllers/application_controller.rb",
                        "\n#{text_to_add}",
                        "ActionController::Base",
                        "end")
