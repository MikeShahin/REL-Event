class CLI

    def run
        Events.clear_all
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
        puts "If you would like to search for an event, enter 1"
        puts "If you would like to see a list of the types of events you can find using this app, enter 2\n\n"
        input = gets.strip.to_s
        if (input == "1")
            fetch_event
        elsif (input == "2")
            fetch_cat
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
        args = []
        
        puts "what type of event are you looking for?"
        event_type = gets.strip.to_s
        
        puts "Where should the events be? (enter a city, state, zip code, or country)"
        event_location = gets.strip.to_s
        
        puts "How many events would you like to see?"
        results_num = gets.strip
        
        args.push(event_type, event_location, results_num)
        
        API.new.fetch_events(event_type, event_location, results_num)
        
        puts ("\nFound " + (API.returned_results) + " results! Showing you "  + (Events.all.count).to_s + " results\n").light_blue
        list_events
        
        @args = args
    end

    def list_events
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
    
    def options_after_results
        puts "1. Get " + @args[2].to_s + " more result(s)."
        puts "2. Start over"
        puts "3. Exit" 
    end
    
    def more_results
        page = 1
        i = @args[2].to_i
        s = @args[2].to_i
        options_after_results
        input = gets.strip
        if (API.returned_results.to_i > @args[2].to_i)   
            while (input == "1") && (API.returned_results.to_i > @args[2].to_i)
                i += @args[2].to_i
                page += 1
                Events.clear_all
                if (page == API.page_count.to_i)
                    API.new.fetch_events(@args[0], @args[1], @args[2], page)
                    list_events
                    after_final_results
                else
                    API.new.fetch_events(@args[0], @args[1], @args[2], page)
                    list_events
                    puts ("\nShowing " + (i + 1 - s).to_s + "-" + i.to_s + " of " + API.returned_results + " result(s)\n").light_blue
                    options_after_results
                    input = gets.strip  
                end
            end
        end
        if (input == "2")
            Events.clear_all
            run
        elsif (input == "3")
            exit
        else puts "Sorry, either there are no more results or you spelled something wrong, re-check and enter either 2, or 3"
            more_results
        end
    end

    def after_final_results
        puts "These are all of the results, would you like to start over?"
        puts "Enter 1 to restart the program, 2 to exit"
        user = gets.strip
        if (user == "1")
            run
        elsif (user == "2")
            exit
        else
            puts "Sorry, can you please repeat that?"
        end
    end
        
    def self.reboot
        puts "Rebooting...".red.bold
        sleep(1)
        CLI.new.run
    end
end