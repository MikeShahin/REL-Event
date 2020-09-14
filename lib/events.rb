class Events
    attr_reader :city_name, :venue_name, :title, :description, :url, :date, :total_result

    @@all = []

    def initialize(city_name, venue_name, title, description, url, date)
        @city_name = city_name
        @venue_name = venue_name
        @title = title
        @description = description
        @url = url
        @date = date
        @@all << self
    end

    def self.all
        @@all
    end

    def self.clear_all
        @@all.clear
    end

    def self.list_events
        x = 0
        Events.all.each do |e|
            x += 1
            puts "#########################################################################"
            puts "/////////////////////////////////////////////////////////////////////////"
            puts "______[  #{x}. #{e.title.green.bold}  ]______  "
            puts "/////////////////////////////////////////////////////////////////////////"
            puts "When: ".red + e.date.split(" ")[0] + " at: ".red + e.date.split(" ")[1]
            puts "Where: ".red + e.venue_name + ", " + e.city_name
            puts "#########################################################################\n\n"
        end
    end
end
