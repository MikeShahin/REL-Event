class CLI

    def run
        opening
        opening_menu
        fetch_event
        list_events
        more_results
        reboot
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
        sleep(1)
        puts "If you would like to search for an event, enter 1"
        puts "If you would like to see a list of the types of events you can find using this app, enter 2\n\n"
        # gets.strip
    end
    
    
    def fetch_event
        args = []
        
        puts "what type of event are you looking for?"
        event_type = gets.strip.to_s
        
        puts "Where should the events be?"
        event_location = gets.strip.to_s
        
        puts "How many events would you like to see?"
        results_num = gets.strip
        
        args.push(event_type)
        args.push(event_location)
        args.push(results_num)
        
        API.new.fetch_events(event_type, event_location, results_num)
        # API.new.fetch_events("concert", "san francisco")
        @args = args
    end
    
    def more_results
        page = 1

        puts "1. Get " + (Events.all.count).to_s + " more results."
        puts "2. Start over"
        puts "3. Exit" 
        input = gets.strip

        while (input == "1")
            page += 1
            Events.clear_all
            API.new.fetch_events(@args[0], @args[1], @args[2], page)
            list_events
            puts "1. Get " + (Events.all.count).to_s + " more results."
            puts "2. Start over"
            puts "3. Exit"
            input = gets.strip   
        end
        if (input == "2")
           Events.clear_all
            run
        elsif (input == "3")
            exit
        else puts "Sorry, please choose 1, 2, or 3"
            more_results
        end
    end
    
    def list_events

        if (Events.all.count == 0)
            puts "Sorry, no events were found"
        # puts "Found " + API.fetch_events.returned_results + " results!"
        else puts "Showing " + (Events.all.count).to_s + " results"
        Events.all.each do |e|
            puts "#########################################################################"
            puts "/////////////////////////////////////////////////////////////////////////"
            puts "______[  " + e.title.green.bold + "  ]______  "
            puts "/////////////////////////////////////////////////////////////////////////"
            # puts "*************************************************************************"
            puts "When: ".red + e.date.split(" ")[0] + " at: ".red + e.date.split(" ")[1]
            puts "Where: ".red + e.venue_name + ", " + e.city_name
            if (e.description != nil)
                puts "What: ".red + e.description
                puts "More info at: ".red + e.url.cyan
            else puts ("Sorry, there is no description for this event, but get more information at:")
                 puts e.url.cyan
            end
            puts "#########################################################################\n\n"
        end
        end
    end
    
    # binding.pry
    
    def reboot
        puts "thanks for checking us out, press enter to start over or ctrl+c to exit"
        Events.clear_all
        gets.strip
        CLI.new.run
    end

end