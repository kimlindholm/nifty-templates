# >----------------------------------[ Gitignore ]----------------------------------<

@current_recipe = "gitignore"
@before_configs["gitignore"].call if @before_configs["gitignore"]
say_recipe 'Gitignore'


@configs[@current_recipe] = config

create_file ".gitignore", :force => true do
".bundle
db/*.sqlite3*
log/*.log
*.log
/tmp/
doc/
*.swp
*~
.project
.DS_Store
"
end
