class CLI


    # Events.all[0].description
    #  Events.all[0].url

    def run
        Events.clear_all
        Category.clear_all
        opening
        opening_menu
        if (API.returned_results.to_i < @args[2].to_i)
            after_final_results
        else more_results
        end
        more_results
    end

    def opening
        puts "    __  ____ __                ______      __        ____         ______            __   ".red
        puts "   /  |/  (_) /_____  _____   /_  __/___  / /_____ _/ / /_  __   / ____/___  ____  / /   ".red
        puts "  / /|_/ / / //_/ _ \\/ ___/    / / / __ \\/ __/ __ `/ / / / / /  / /   / __ \\/ __ \\/ /    ".red
        puts " / /  / / / ,< /  __(__  )    / / / /_/ / /_/ /_/ / / / /_/ /  / /___/ /_/ / /_/ / /     ".yellow
        puts "/_/  /_/_/_/|_|\\___/____/    /_/  \\____/\\__/\\__,_/_/_/\\__, /   \\____/\\____/\\____/_/      ".yellow
        puts "              / ____/   _____  ____  / /______   /   /____/_  ____                       ".yellow
        puts "             / __/ | | / / _ \\/ __ \\/ __/ ___/  / /| | / __ \\/ __ \\                      ".yellow
        puts "            / /___ | |/ /  __/ / / / /_(__  )  / ___ |/ /_/ / /_/ /                      ".blue
        puts "           /_____/ |___/\\___/_/ /_/\\__/____/  /_/  |_/ .___/ .___/                       ".blue
        puts "                                                    /_/   /_/                            ".blue
        puts "\n      Welcome to Mike's totally cool, totally awesome event finding app!\n\n".magenta 
    end

    def opening_menu
        # sleep(1)
        puts "What should we do? Enter a number\n"
        puts "1. ".red + "If you would like to search for an event"
        puts "2. ".red + "If you would like to see a list of the types of events you can find using this app"
        puts "3. ".red + "if you would like to see your saved events\n\n"
        input = gets.strip.to_s
        case input
        when "1"
            fetch_event
        when "2"
            fetch_cat
        when "3"
            if (Saved_events.all.count == 0) && File.zero?("./Saved_events.txt")
                puts "sorry, you haven't saved any events yet\n\n".light_red
                # File.open("./Saved_events.txt").each do |l|
                #     puts l
                # end
                opening_menu
            else
                # puts "Here's the #{Saved_events.all.count} event(s) you have saved\n".light_blue
                # Saved_events.list_events
                # puts ""
                File.open("./Saved_events.txt").each do |l|
                    puts l
                end
                opening_menu
            end
        else
            puts "Sorry, please repeat that..."
            opening_menu
        end
    end
    
    def fetch_cat
        puts "Here are some examples of different categories you can search for:"
        API.new.fetch_categories
        list_cat
    end

    def list_cat
        i = 1
        Category.all.each do |c|
            puts "#{i}: ".green + c.category.gsub("&amp;", "and")
            i += 1
        end
        puts ""
        sleep(1)
        fetch_event
    end
    
    def fetch_event
        @args = []
        
        puts "what type of event are you looking for?"
        event_type = gets.strip.to_s
        
        puts "Where should the events be? (enter a city, state, zip code, or country)"
        event_location = gets.strip.to_s
        
        puts "How many events would you like to see?"
        results_num = gets.strip
        if (results_num.to_i > 250)
            puts "That's waaaaaay too many dude, best I can do is 250"
        end
        @args.push(event_type, event_location, results_num)
        
        if (event_type == "") && (event_location == "")
            puts "Sorry duderino, I can't do all the work for you, please give me something to work with!".red
            fetch_event
        elsif (results_num == "")
            puts "Sorry duderino, I can't do all the work for you, please give me something to work with!".red
            fetch_event
        else 
            API.new.fetch_events(event_type, event_location, results_num)
            puts "Finding you some events".blue
            puts ("\nFound #{API.returned_results} #{@args[0]} event(s) near #{@args[1]}! Currently displaying #{Events.all.count.to_s} result(s)\n").light_blue
        end
        Events.list_events
        # binding.pry
        @args
    end
    
    def options_after_results
        puts "If you would like more info about any of these events, enter (y/n)"
        input = gets.strip
        case input.downcase
        when "y"
            more_info
        when "n"
            puts "Ok, what should we do? Please enter the number for the following:"
            puts "1. Get #{@args[2].to_s} more result(s)."
            puts "2. Start over"
            puts "3. Exit" 
        else
            puts "What you entered is not valid you dunce"
            sleep(1)
            options_after_results
        end
    end
    
    def more_results
        @page = 1
        if (@args[2].to_i > 250)
            s = i = 250
        else s = i = @args[2].to_i
        end
        options_after_results
        input = gets.strip
        if (API.returned_results.to_i > @args[2].to_i)   
            while (input == "1") && (API.returned_results.to_i > @args[2].to_i)
                i += @args[2].to_i
                @page += 1
                Events.clear_all
                if (@page == API.page_count.to_i)
                    API.new.fetch_events(@args[0], @args[1], @args[2], @page)
                    Events.list_events
                    after_final_results
                else
                    API.new.fetch_events(@args[0], @args[1], @args[2], @page)
                    Events.list_events
                    puts ("\nShowing " + (i + 1 - s).to_s + "-" + i.to_s + " of " + API.returned_results + " result(s)\n").light_blue
                    options_after_results
                    input = gets.strip  
                end
            end
        end
        case input
        when "2"
            Events.clear_all
            run
        when "3"
            exit
        else puts "Sorry, either there are no more results or you spelled something wrong, re-check and enter either 2, or 3"
            more_results
        end
        @page
    end

    def more_info
        puts "Enter the event number you are interested in"
        input = gets.strip
        e = Events.all
        if (input.to_i > e.count) || (input.to_i <= 0)
            puts "Sorry, doesn't match, try again..."
            more_info
        elsif (e[input.to_i - 1].description != nil)
            puts "#########################################################################"
            puts "______[  " + input + ". #{e[input.to_i - 1].title.green.bold}  ]______  "
            puts "*************************************************************************"
            puts "What: ".red + e[input.to_i - 1].description
            puts "\nMore info at: ".red + e[input.to_i - 1].url.cyan
            puts "#########################################################################\n\n"
            puts ""
            puts "Would you like to save? (y/n)"
            input2 = gets.strip
            if input2.downcase == "y"
                Saved_events.new(e[input.to_i - 1].city_name, e[input.to_i - 1].venue_name, e[input.to_i - 1].title, e[input.to_i - 1].description, e[input.to_i - 1].url, e[input.to_i - 1].date)
                store_events
                # binding.pry
            end
        else 
            puts "#########################################################################"
            puts "______[  " + input + ". #{e[input.to_i - 1].title.green.bold}  ]______  "
            puts "*************************************************************************"
            puts ("Sorry, there is no description for this event, but get more information at:")
            puts e[input.to_i - 1].url.cyan
            puts "#########################################################################\n\n" 
            puts ""
            puts "Would you like to save? (y/n)"
            input2 = gets.strip
            if input2.downcase == "y"
                Saved_events.new(e[input.to_i - 1].city_name, e[input.to_i - 1].venue_name, e[input.to_i - 1].title, e[input.to_i - 1].description, e[input.to_i - 1].url, e[input.to_i - 1].date)
                store_events
                # binding.pry
            end
        end
        
        if (@page == API.page_count.to_i) || (@args[2].to_i > API.returned_results.to_i)
            after_final_results
        else 
            more_results
        end
    end

    def after_final_results
        puts "These are all of the results, what would you like to do? Would you like more info about any of these events, enter (y/n)"
            input = gets.strip
            if (input.downcase == "y")
                more_info
        else
        puts "Okay, then please enter:"
        puts "1. If you changed your mind and do want more info on an event"
        puts "2. to restart the program"
        puts "3. to exit"
        end

        user = gets.strip
        case user
        when "1"
            more_info
        when "2"
            run
        when "3"
            exit
        else
            puts "Sorry, can you please repeat that?"
            after_final_results
        end
    end
        
    def self.reboot
        puts "Rebooting...".red.bold
        sleep(1)
        CLI.new.run
    end

    def store_events
        File.open("./Saved_events.txt", "a") do |l|
          Saved_events.all.each do |e|
            l.puts "\r" + "#########################################################################"
            l.puts "\r" + "/////////////////////////////////////////////////////////////////////////"
            l.puts "\r" + "______[  #{e.title.green.bold}  ]______  "
            l.puts "\r" + "/////////////////////////////////////////////////////////////////////////"
            l.puts "\r" + "When: ".red + e.date.split(" ")[0] + " at: ".red + e.date.split(" ")[1]
            l.puts "\r" + "Where: ".red + e.venue_name if e.venue_name + ", " + e.city_name if e.city_name
            l.puts "\r" + "What: ".red + e.description if e.description 
            l.puts "\r" + "\nMore info at: ".red + e.url.cyan
            l.puts "\r" + "#########################################################################\n\n"
          end
        end
        Saved_events.clear_all
        binding.pry
    end
end