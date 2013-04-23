# >---------------------------------[ Unicorn_killer ]---------------------------------<

@current_recipe = "unicorn_killer"
@before_configs["unicorn_killer"].call if @before_configs["unicorn_killer"]
say_recipe 'Unicorn_killer'


@configs[@current_recipe] = config

text_to_add_after_fork = <<-RUBY
  GC.disable
RUBY

text_to_add_rack_config = <<-RUBY
# Unicorn self-process killer
require ::File.expand_path('../lib/unicorn/unicorn_killer',  __FILE__)
use UnicornKiller::MaxRequests, 10240 + Random.rand(10240)
use UnicornKiller::Oom, 96 * 1024 + Random.rand(32) * 1024

# Out-Of-Band GC
require 'unicorn/oob_gc'
use Unicorn::OobGC
RUBY

unicorn_killer = <<-RUBY
# https://gist.github.com/1258681
#
# your config.ru:
#   require 'unicorn_killer'
#   use UnicornKiller::MaxRequests, 1000
#   use UnicornKiller::Oom, 400 * 1024

module UnicornKiller
  module Kill
    def quit
      sec = (Time.now - @process_start).to_i
      warn "\#{self.class} send SIGQUIT (pid: \#{Process.pid})\\talive: \#{sec} sec"
      Process.kill :QUIT, Process.pid
    end
  end

  class Oom
    include Kill

    def initialize(app, memory_size= 512 * 1024, check_cycle = 16)
      @app = app
      @memory_size = memory_size
      @check_cycle = check_cycle
      @check_count = 0
    end

    def rss
      `ps -o rss= -p \#{Process.pid}`.to_i
    end

    def call(env)
      @process_start ||= Time.now
      if (@check_count += 1) % @check_cycle == 0
        @check_count = 0
        quit if rss > @memory_size
      end
      @app.call env
    end
  end

  class MaxRequests
    include Kill

    def initialize(app, max_requests = 1000)
      @app = app
      @max_requests = max_requests
    end

    def call(env)
      @process_start ||= Time.now
      quit if (@max_requests -= 1) == 0
      @app.call env
    end
  end
end
RUBY

if recipe?("unicorn") && File.exist?("config/unicorn.rb")
  rack_config_path = "config.ru"

  if File.exist?(rack_config_path)
    inject_into_file "config/unicorn.rb",
                     after: "after_fork do |server, worker|\n" do
      "#{text_to_add_after_fork}\n"
    end

    append_file rack_config_path, "\n#{text_to_add_rack_config}"
    create_file "lib/unicorn/unicorn_killer.rb", unicorn_killer
  else
    say_error "config.ru not found, Unicorn_killer setup failed"
  end
else
  say_error "Unicorn not found, skipping"
end
