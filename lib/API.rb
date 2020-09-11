class API

    BASE_URL = "http://api.eventful.com/json/"
    # surl = "http://api.eventful.com/json/categories/list?"

    def fetch_events(keyword, location, num, page = "1")
        #build the URL string
        event_type_split = keyword.split(" ")
        event_type = event_type_split.join("+")
        loc_split = location.split(" ")
        loc = loc_split.join("+")
        url = BASE_URL + 'events/search?app_key=' + API_KEY + "&keywords=#{event_type}" + "&location=#{loc}" + "&page_size=#{num}" + "&page_number=#{page}"
        #make http request
        uri = URI.parse(url)
        body = uri.read
        resp = Net::HTTP.get_response(uri)
        data = JSON.parse(resp.body)
       # binding.pry
        
        # Iterate data, pull out relevent info to push into events class
        data_array = data["events"]
        
        data_array['event'].each do |e|
            Events.new(e["city_name"], e["venue_name"], e["title"], e['description'], e['url'], e["start_time"])
        end  
        
        returned_results = data["total_items"]
    end

    def fetch_categories
        # API call to fetch categories
    end
end

