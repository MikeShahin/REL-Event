class API

    BASE_URL = "http://api.eventful.com/json/"

    def fetch_events(keyword, location, num, page = "1")
        event_type_split = keyword.split(" ")
        event_type = event_type_split.join("+")
        loc_split = location.split(" ")
        loc = loc_split.join("+")
        
        begin   
            url = BASE_URL + 'events/search?app_key=' + API_KEY + "&keywords=#{event_type}" + "&location=#{loc}" + "&page_size=#{num}" + "&page_number=#{page}&sort_order=date"
            # binding.pry
            uri = URI.parse(url)
            body = uri.read
            resp = Net::HTTP.get_response(uri)
            data = JSON.parse(resp.body)
            # binding.pry
        rescue JSON::ParserError => e  
          puts "ooof"
          CLI.reboot
        rescue URI::InvalidURIError
            puts "BAD URI ERROR"
            CLI.reboot
        end 
        
        if (data["total_items"] == "0")
            puts "Sorry, no results were found, lets try this thing again"
            CLI.reboot
        else
        data_array = data["events"]
        
        data_array['event'].each do |e|
            Events.new(e["city_name"], e["venue_name"], e["title"], e['description'], e['url'], e["start_time"])
            end  
        end
        @@returned_results = data["total_items"]
        @@page_count = data["page_count"]
    end

    def self.returned_results
        @@returned_results
    end

    def self.page_count
        @@page_count
    end

    # API call to fetch categories
    def fetch_categories
        c_url = BASE_URL + "categories/list?" + "app_key=" + API_KEY

        uri = URI.parse(c_url)
        body = uri.read
        resp = Net::HTTP.get_response(uri)
        data = JSON.parse(resp.body)

        categories = data["category"]
        # binding.pry
        categories.each do |c|
            Category.new(c["name"])
        end
    end
end

