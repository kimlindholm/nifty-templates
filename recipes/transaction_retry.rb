# >----------------------------------[ transaction_retry ]----------------------------------<

@current_recipe = "transaction_retry"
@before_configs["transaction_retry"].call if @before_configs["transaction_retry"]
say_recipe 'transaction_retry'


@configs[@current_recipe] = config

if recipe?("activerecord")
  if @configs.key?("activerecord") && @configs["activerecord"].key?('database')
    @chosen_database = @configs["activerecord"]['database'];
    if @chosen_database.in? %W(mysql postgresql sqlite3)
      gem 'transaction_retry'
    else
      say_warning "Database '#{@chosen_database}' was chosen, skipping as " +
                  "transaction_retry only supports MySQL, PostgreSQL and " +
                  "SQLite."
    end
  else
    say_error "Database not chosen, skipping. Hint: invoke ActiveRecord " +
              "recipe first"
  end
else
  say_error "ActiveRecord recipe not found, skipping setup"
end
