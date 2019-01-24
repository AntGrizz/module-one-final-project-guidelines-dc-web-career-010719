require 'pry'

class PlannerCLI

def greeting
  puts "We've got 6 big months ahead of us, it's festival season baby!!!!\n\n"
  menu
end

def menu
  puts "What's your festival availabilty?\n\n"
  puts "1. Instructions"
  puts "2. View festivals"
  puts "3. Add festivals to planner"
  puts "4. View your schedule"
  puts "5. View the team schdeule"
  puts "6. Exit\n\n"
  main_menu_loop
end

def menu_no_loop
  puts "Choose from the options below:\n\n"
  puts "1. Instructions"
  puts "2. View festivals"
  puts "3. Add festivals to planner"
  puts "4. View your schedule"
  puts "5. View the team schdeule"
  puts "6. Exit\n\n"
end

def main_menu_loop
  cli = PlannerCLI.new
  loop do
    input = gets.chomp.downcase
    case input
    when "1" || "instructions"
      puts "keep looping"
    when "2" || "view festivals"
      cli.return_all_festivals
    when "3" || "add festivals to planner"
      cli.add_festivals_to_planner
    when "4" || "view your schedule"
      puts "\nWhat's your first name?\n\n"
      user_hash = {}
      user_hash[:first_name] = gets.chomp
      puts "\n\n"

      puts "What's your last name?\n\n"
      user_hash[:last_name] = gets.chomp
      puts "\n\n"
      
      cli.return_your_schedule(user_hash)
    when "5" || "view the team schedule"
      puts "keep looping"
    when "6" || "exit"
      puts "\nPut the camera down and enjoy yourself!\n\n"
      return
    else
      puts "Hmmm... 1-6, not #{input}, try again."
      end
    end
  end

  def return_all_festivals
    array = []
    Festival.all.each_with_index do |festival, index| array << "#{index + 1}. #{festival.name} | |Cost: #{festival.cost}| Start Date: #{festival.start_date} | End Date: #{festival.end_date} | Location: #{festival.location}"
    end
    puts "\n\n------------------"
    puts array
  end

  def add_festivals_to_planner
    cli = PlannerCLI.new
     attendee = cli.create_user
    loop do
    puts "Which festival do you want to attend?\n\n"
      festival = gets.chomp.to_s #Lollapalooza
      all_festivals = Festival.all.map {|festival| festival.name}
     # binding.pry
      if all_festivals.include?(festival)
        add_festival = cli.find_festival(festival)
        puts "Name your trip\n\n"
        trip_name = gets.chomp
        Planner.create(name: trip_name, user: attendee, festival: add_festival)
      elsif "Exit"
        puts "\nIt's LIT!!!!\n\n"
        cli.menu_no_loop
        return
      else
        puts "We're not interested in #{festival}."
        end
      end
    end


      def create_user
        user_hash = {}
        puts "\nFirst, we need a little information.\n\n"
        puts "What's your first name?\n\n"
        user_hash[:first_name] = gets.chomp.to_s
        puts "What's your last name?\n\n"
        user_hash[:last_name] = gets.chomp.to_s
        puts "What's your location? (format: City, State)\n\n"
        user_hash[:location] = gets.chomp.to_s
        new_user = User.find_or_create_by(user_hash)
        new_user
      end

      def find_festival(festival)
        festival = Festival.all.find_by(name: festival)
        festival
      end

      def return_your_schedule(user_hash)
        plans = Planner.all.select do |schedule|
          user_hash[:first_name] == schedule.user.first_name && user_hash[:last_name] == schedule.user.last_name
          # binding.pry
        end
        puts "\n\n"
        puts "#{user_hash[:first_name]} #{user_hash[:last_name]}'s Schedule:\n\n"
        plans.each_with_index.map do |event, index|
          puts "#{index + 1}. #{event.name} | Dates: #{event.festival.start_date} - #{event.festival.end_date} "
        end
        puts "\n\n--------------------------------------------------\n\n"
        menu_no_loop
      end


end
