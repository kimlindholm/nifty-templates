# >---------------------------------[ Delayed Job matcher ]---------------------------------<

@current_recipe = "delayed_job_matcher"
@before_configs["delayed_job_matcher"].call if @before_configs["delayed_job_matcher"]
say_recipe 'Delayed Job matcher'


@configs[@current_recipe] = config

text_to_add_configure = <<-RUBY
config.include DelayedJob::Matchers
RUBY

matcher = <<-RUBY
# https://gist.github.com/3186463

module DelayedJob
  module Matchers
    def enqueue_delayed_job(handler)
      DelayedJobMatcher.new handler
    end

    class DelayedJobMatcher
      def initialize(handler)
        @handler = handler
        @attributes = {}
        @priority = 0
        @failure_message = ''
      end

      def description
        "enqueue a \#{@handler} delayed job"
      end

      def failure_message
        @failure_message || <<-message.strip_heredoc
          Expected \#{@handler} to be enqueued as a delayed job. Try:
          Delayed::Job.enqueue \#{@handler}.new
        message
      end

      def matches?(subject)
        @subject = subject
        enqueued? && correct_attributes? && correct_priority?
      end

      def priority(priority)
        @priority = priority
        self
      end

      def with_attributes(attributes)
        @attributes = attributes
        self
      end

      private

      def correct_attributes?
        @attributes.each do |key, value|
          payload_object.send(key).should == value
        end
      end

      def correct_priority?
        if @priority == job.priority
          true
        else
          @failure_message = <<-message.strip_heredoc
            Expected priority to be \#{@priority} but was \#{job.priority}"
          message

          false
        end
      end

      def enqueued?
        payload_object.kind_of? @handler.constantize
      end

      def job
        Delayed::Job.last
      end

      def payload_object
        job.payload_object
      end
    end
  end
end
RUBY

if recipe?("rspec")
  run 'mkdir -p spec/support/matchers'
  create_file "spec/support/matchers/delayed_job_matcher.rb", matcher

  after_bundler do
    spec_helper_path = "spec/spec_helper.rb"

    if File.exist?(spec_helper_path)
      append_to_block_in_file(spec_helper_path,
                              text_to_add_configure,
                              "RSpec.configure do |config|",
                              "end")
    else
      say_error "spec_helper.rb not found, Delayed Job matcher setup failed"
    end
  end
else
  say_error "RSpec not found, skipping"
end
