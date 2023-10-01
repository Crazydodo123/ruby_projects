require_relative "dictionary"
require_relative "player"
require_relative "aiplayer"

class Game
    attr_accessor :fragment, :players

    def initialize(n_players, n_ai = 0)
        @players = []
        (1..n_players).each do |i|
            @players << Player.new(i)
        end
        n_ai.times { @players << AiPlayer.new(@players) }
        @fragment = ""
        @dictionary = Hash.new
        DICTIONARY.each { |word| @dictionary[word] = nil }
        @current_player = @players[0]
        @losses = Hash.new(0)
    end

    def next_player!
        new_player_idx = (@players.index(@current_player) + 1) % @players.length
        @current_player = @players[new_player_idx]
    end

    def previous_player
        new_player_idx = (@players.index(@current_player) - 1) % @players.length
        @players[new_player_idx]
    end
    
    def valid_play?(str)
        alpha = ("a".."z").to_a
        if str.length != 1
            puts "Not a character"
            false
        elsif !alpha.include?(str)
            puts "Not a letter of the alphabet"
            false
        elsif !@dictionary.any? { |word| word[0].start_with?(@fragment + str)}
            puts "Cannot form a valid word"
            false
        else
            true
        end
    end

    def length
        @players.length
    end

    def take_turn(player)
        puts "Current fragment is #{@fragment}..."
        wrong_tries = 5
        guess = player.guess(@fragment, self.length)
        until valid_play?(guess)
            wrong_tries -= 1
            raise if wrong_tries == 0
            puts "Please try again, #{wrong_tries} attempts remaining"
            guess = player.alert_invalid_guess(@fragment, self.length)
        end
        @fragment += guess
    end

    def record(player)
        "GHOST"[0..@losses[player] - 1] if @losses[player] != 0
    end

    def play_round
        begin
            until @dictionary.include?(@fragment)
                take_turn(@current_player)
                next_player!
                puts
            end
            puts "#{self.previous_player.name} lost the round, #{@fragment} was a valid word :("
        rescue
            next_player!
            puts "#{self.previous_player.name} lost the round, 0 attempts remaining :("
        end
        @losses[self.previous_player] += 1
        @fragment = ""
    end

    def display_standings
        @players.each { |player| puts "#{player.name}: #{record(player)}" }
    end
    
    def run
        @round = 1
        until @players.length == 1
            puts "------------------------"
            puts "        ROUND #{@round}"
            puts "------------------------"
            @current_player = @players[(@round - 1) % @players.length]
            self.play_round
            @players.reject! do |player|
                if @losses[player] >= 5
                    puts
                    if @players.length - 1 == 1
                        puts "#{player.name} has been eliminated"
                    else
                        puts "#{player.name} has been eliminated, #{@players.length - 1} players remaining"
                    end
                    puts
                    true
                end
            end
            if @players.length != 1
                puts "-------SCOREBOARD-------"
                display_standings
                @round += 1
            end
        end
        puts
        puts "#{@current_player.name.upcase} WINS!!!!!"
    end
end

if $PROGRAM_NAME == __FILE__
    game = Game.new(1, 1)
  
    game.run
end