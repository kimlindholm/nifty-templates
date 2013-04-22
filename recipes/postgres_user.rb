# >----------------------------------[ Postgres user ]----------------------------------<

@current_recipe = "postgres_user"
@before_configs["postgres_user"].call if @before_configs["postgres_user"]
say_recipe 'Postgres user'


@configs[@current_recipe] = config

if recipe?("activerecord")
  if @configs.key?("activerecord") && @configs["activerecord"].key?('database')
    @chosen_database = @configs["activerecord"]['database'];
    if @chosen_database == "postgresql"
      begin
        say_wizard "Creating PostgreSQL user '#{app_name}'"
        run "createuser #{app_name} --no-superuser --createdb --no-createrole"
      rescue StandardError
        say_error "Unable to create PostgreSQL user"
      end
    else
      say_warning "Database '#{@chosen_database}' was chosen, skipping " +
                  "PostgreSQL user creation."
    end
  else
    say_error "Database not chosen, skipping PostgreSQL user creation. " +
              "Hint: invoke ActiveRecord recipe first"
  end
else
  say_error "ActiveRecord recipe not found, skipping PostgreSQL user creation"
end
