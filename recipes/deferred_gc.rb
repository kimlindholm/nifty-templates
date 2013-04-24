# >---------------------------------[ Deferred GC ]---------------------------------<

@current_recipe = "deferred_gc"
@before_configs["deferred_gc"].call if @before_configs["deferred_gc"]
say_recipe 'Deferred GC'


@configs[@current_recipe] = config

# See: https://makandracards.com/makandra/950-speed-up-rspec-by-deferring-garbage-collection

deferred_garbage_collection = <<-RUBY
class DeferredGarbageCollection

  DEFERRED_GC_THRESHOLD = (ENV['DEFER_GC'] || 10.0).to_f

  @@last_gc_run = Time.now

  def self.start
    GC.disable if DEFERRED_GC_THRESHOLD > 0
  end

  def self.reconsider
    if DEFERRED_GC_THRESHOLD > 0 && Time.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @@last_gc_run = Time.now
    end
  end

end
RUBY

text_to_add_configure = <<-RUBY
    config.before(:all) { DeferredGarbageCollection.start }
    config.after(:all) { DeferredGarbageCollection.reconsider }
RUBY

if recipe?("rspec")
  create_file "spec/support/deferred_garbage_collection.rb",
              deferred_garbage_collection

  after_bundler do
    spec_helper_path = "spec/spec_helper.rb"

    if File.exist?(spec_helper_path)
      append_to_block_in_file(spec_helper_path,
                              "\n#{text_to_add_configure}",
                              "RSpec.configure do |config|",
                              "end")
    else
      say_error "spec_helper.rb not found, Deferred GC setup failed"
    end
  end
else
  say_error "RSpec not found, skipping"
end
