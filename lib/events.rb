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

end
