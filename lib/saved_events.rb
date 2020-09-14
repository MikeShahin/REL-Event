class Saved_events
    attr_reader :city_name, :venue_name, :title, :description, :url, :date

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
        Saved_events.all.each do |e|
            x += 1
            puts "#########################################################################"
            puts "/////////////////////////////////////////////////////////////////////////"
            puts "______[  #{x}. #{e.title.green.bold}  ]______  "
            puts "/////////////////////////////////////////////////////////////////////////"
            puts "When: ".red + e.date.split(" ")[0] + " at: ".red + e.date.split(" ")[1]
            puts "Where: ".red + e.venue_name if e.venue_name + ", " + e.city_name if e.city_name
            puts "What: ".red + e.description if e.description 
            puts "\nMore info at: ".red + e.url.cyan
            puts "#########################################################################\n\n"
        end
    end
end