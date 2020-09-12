class Category

    attr_reader :category

    @@all = []

    def initialize(category)
        @category = category
        @@all << self
    end

    def self.all
        @@all
    end
end
