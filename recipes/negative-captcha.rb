# >---------------------------------[ Negative Captcha ]---------------------------------<

@current_recipe = "negative-captcha"
@before_configs["negative-captcha"].call if @before_configs["negative-captcha"]
say_recipe 'Negative Captcha'


@configs[@current_recipe] = config

gem 'negative_captcha'
