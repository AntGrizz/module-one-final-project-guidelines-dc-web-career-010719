require 'pry'
require 'tty-font'
require 'pastel'


class PlannerCLI


#Greeting method and calls the menu
def greeting
  pastel = Pastel.new
  font = TTY::Font.new(:starwars)
  puts pastel.bright_cyan(font.write("Plan-it' 'Fest!"))
  puts "\n\nWe've got SIX big months ahead of us, it's festival season baby!!!!\n\n"
  menu
end


#Intial menu when entering the command line
def menu
  prompt = TTY::Prompt.new
  @choice = prompt.select("Choose from the options below:") do |menu|
    menu.enum '.'
    menu.choice "Instructions", 1
    menu.choice "View Festivals", 2
    menu.choice "Add Festival(s) to Planner", 3
    menu.choice "Search for a Schedule", 4
    menu.choice "View All Schedules", 5
    menu.choice "Count by Festival", 6
    menu.choice "Exit", 7
  end
  @choice
end

def instructions
   puts "
                       ----------------------------------------------------------------------------------------------------
                               -  Type your choose from one of the menu options below:
                                               1. Help - Instructions

                                               2. View festivals
                                                a. Shows all available festivals and relevant information

                                               3. Add festival(s) to planner
                                                a. Provide key user information and choose the festivals you wish to attend.
                                                b. To exit at any point type '7'
                                                c. Prints out the users schedule

                                               4. Search for a schedule
                                                 a. By name (first & last) and location (City, State) search for a given schedule

                                               5. View the all schedules
                                                a. Prints out all schedules from the group

                                                6. Count by Festival
                                                  a. By festival prints out the total number of attendees

                                                7. Exit

                               -  You may make multiple selections until you are finished.
                               -  If you're having issues exiting this app, please press '7' or choose 'Exit' from the menu.
                               -  You may reference README.md for further instruction.

                       ----------------------------------------------------------------------------------------------------
   "
  end



#Loops through menu items
def main_menu_loop
  loop do
    # binding.pry
    case input = @choice
      when 1
        self.instructions
        self.menu
      when 2
        self.return_all_festivals
        self.menu
      when 3
        self.add_festivals_to_planner
      when 4
        puts "\n\n"
        user = self.create_or_find_user
        self.return_schedule(user)
      when 5
        self.return_all_schedules
      when 6
        self.count_all_festivals
      when 7
        puts "\nPut the camera down and enjoy yourself!\n\n"
        return
    end
  end
end

  #Puts out the all festivals and their information
  def return_all_festivals
    puts "\n\n-----------------------------------------------------------------------------------------------------\n\n"
    Festival.all.each_with_index.map do |festival, index|
      puts "#{index + 1}. Festival: #{festival.name} | |Cost: #{festival.cost}| Start Date: #{festival.start_date} | End Date: #{festival.end_date} | Location: #{festival.location}"
    end
  end

  #Loops through and creates festival schedule and puts it out when the user exits the loop
  def add_festivals_to_planner
     attendee = self.create_or_find_user
    loop do
    puts "Which festival do you want to attend?\n   To exit at any time type 6\n\n"
      festival = gets.chomp #Lollapalooza
      all_festivals = Festival.all.map {|festival| festival.name}
     # binding.pry
      if all_festivals.include?(festival)
        add_festival = self.find_festival(festival)
        Planner.create(user: attendee, festival: add_festival)
      elsif 6
        # binding.pry
        puts "Exiting..."
        puts "\n-----------------------------------------------------------------------------------------------------\n\n"
        puts "It's LIT!!!!\n"
        return_schedule(attendee)
        return
      else
        puts "We're not interested in #{festival}."
        end
      end
    end

    #If a user if found return the matching object, if not
    #create a new user
    def create_or_find_user
      user_hash = {}
      puts "\nFirst, we need a little information.\n\n"
      puts "What's your first name?\n\n"
      user_hash[:first_name] = gets.chomp
      puts "What's your last name?\n\n"
      user_hash[:last_name] = gets.chomp
      puts "What's your location? (format: City, State)\n\n"
      user_hash[:location] = gets.chomp
      new_user = User.find_or_create_by(user_hash)
      new_user
    end

    #Find the festival object from a festival name string
    def find_festival(festival)
      festival = Festival.all.find_by(name: festival)
      festival
    end

    #Return the festival schedule from a name string
    def return_schedule(user_hash)
      plans = Planner.all.select do |schedule|
        user_hash[:first_name] == schedule.user.first_name && user_hash[:last_name] == schedule.user.last_name
      end
        puts "\n\n"
        puts "#{user_hash[:first_name]} #{user_hash[:last_name]}'s Schedule:\n\n"
        plans.each_with_index.map do |event, index|
          puts "#{index + 1}. Festival: #{event.festival.name} | Dates: #{event.festival.start_date} - #{event.festival.end_date} "
        end
        puts "\n\n"
        self.menu
    end

    def return_all_schedules
      Planner.all.each_with_index.map do |event, index|
        puts "#{index + 1}. Attendee: #{event.user.name} | Festival: #{event.festival.name} | Dates: #{event.festival.start_date} - #{event.festival.end_date} "
      end
      puts "\n\n"
    end

    def count_all_festivals
      count = 0
      festival_count = []
      all_festivals = Festival.all.map {|festival| festival.name}
      Planner.all.each do |f|
        if !all_festivals.include? f.festival.name
          festival_count << "#{f.festival.name}: #{count = 1}"
        else
          festival_count << "#{f.festival.name}: #{count += 1}"
          puts festival_count.each_with_index.map { |f,i| "#{i + 1}. f"}
          binding.pry
        end
      end
    end

end
