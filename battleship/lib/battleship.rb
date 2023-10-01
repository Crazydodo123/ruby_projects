require_relative "board"
require_relative "player"

class Battleship
    attr_reader :board, :player

    def initialize(length)
        @player = Player.new
        @board = Board.new(length)
        @remaining_misses = @board.size / 2
    end

    def start_game
        @board.place_random_ships
        puts "There are #{@board.num_ships.to_s} hidden ships on the board."
        @board.print
    end

    def lose?
        if @remaining_misses <= 0
            puts "You lose"
            true
        else
            false
        end
    end

    def win?
        if @board.num_ships == 0
            puts "You win"
            true
        else
            false
        end
    end

    def game_over?
        self.lose? || self.win?
    end

    def turn
        @remaining_misses -= 1 if !@board.attack(@player.get_move)
        puts "There are #{@board.num_ships} remaining ships on the board."
        @board.print
        puts "Remaining misses: #{@remaining_misses}"
    end
end
