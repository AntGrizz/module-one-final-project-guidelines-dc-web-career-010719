require_relative '../config/environment.rb'


cli = PlannerCLI.new

cli.greeting
cli.main_menu_loop
