# >---------------------------------[ SecureHeaders ]---------------------------------<

@current_recipe = "secure_headers"
@before_configs["secure_headers"].call if @before_configs["secure_headers"]
say_recipe 'SecureHeaders'


@configs[@current_recipe] = config

text_to_add_app_controller = <<-RUBY
  ensure_security_headers
RUBY

gem 'secure_headers'

initializer "secure_headers.rb", <<-RUBY
unless Rails.env.in?(%w[development test])
  ::SecureHeaders::Configuration.configure do |config|
    config.hsts = {max_age: 99, include_subdomains: true}
    config.x_frame_options = 'DENY'
    config.x_content_type_options = "nosniff"
    config.x_xss_protection = {value: 1, mode: false}
    config.csp = {
      enforce: true,
      default_src: "https://* inline eval",
      # report_uri: '//example.com/uri-directive',
      img_src: "https://* data: *.example.com *.cloudfront.net",
      frame_src: "https://* http://*.twimg.com http://itunes.apple.com",
      connect_src: "self",
      font_src: "data: *.example.com *.cloudfront.net themes.googleusercontent.com",
      style_src: "inline *.example.com *.cloudfront.net fonts.googleapis.com",
      script_src: "inline eval *.example.com *.cloudfront.net *.newrelic.com"
  }
  end
end
RUBY

app_controller_path = "app/controllers/application_controller.rb"

if File.exist?(app_controller_path)
  grep_results = File.readlines(app_controller_path)
      .grep(/class ApplicationController.*$/)
  if grep_results.any?
    inject_into_file app_controller_path, after: grep_results.first do
      text_to_add_app_controller
    end
  end
else
  say_error "application_controller.rb not found, SecureHeaders setup failed"
end
