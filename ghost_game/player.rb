class Player
    attr_reader :name

    def initialize(n)
        puts "Enter your name, Player #{n}"
        @name = gets.chomp.capitalize
    end

    def guess(x, y)
        puts "It's #{@name}'s turn to choose a character"
        gets.chomp.downcase
    end

    def alert_invalid_guess(x, y)
        gets.chomp.downcase
    end
end