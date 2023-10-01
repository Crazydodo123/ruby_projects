require_relative "names"
require_relative "dictionary"

class AiPlayer
    attr_reader :name

    def initialize(players)
        @name = NAMES.sample
        until players.none? { |player| player.name == @name}
            @name = NAMES.sample
        end
        @name += " (AI)"
    end

    def guess(fragment, length)
        puts "It's #{@name}'s turn to choose a character"
        if fragment.length == 0
            choice = DICTIONARY.sample[0]
        else
            available_words = DICTIONARY.select { |word, i| word.start_with?(fragment) }
            losing_words = available_words.select { |word, i| word.length == fragment.length + 1}
            safe_words = available_words.select { |word, i| losing_words.none? { |w, x| word.start_with?(w) } }
            unsafe_words = safe_words.select { |word, i| (word.length - fragment.length) % length == 1 }
            winning_words = safe_words.select { |word, i| unsafe_words.none? { |w, x| word.start_with?(w) } }

            if winning_words.length != 0
                choice = winning_words.sample[fragment.length]
            elsif safe_words.length != 0
                choice = safe_words.sample[fragment.length]
            else
                choice = available_words.sample[fragment.length]
            end
        end

        puts choice
        return choice
    end

    def alert_invalid_guess(fragment)
        if fragment.length == 0
            return DICTIONARY.sample[0]
        end

        available_words = DICTIONARY.select { |word, i| word.start_with?(fragment) }
        losing_words = available_words.select { |word, i| word.length == fragment.length + 1}
        safe_words = available_words.select { |word, i| losing_words.none? { |w, x| word.start_with?(w) } }
        unsafe_words = safe_words.select { |word, i| (word.length - fragment.length) % length == 1 }
        winning_words = safe_words.select { |word, i| unsafe_words.none? { |w, x| word.start_with?(w) } }

        if winning_words.length != 0
            winning_words.sample[fragment.length]
        elsif safe_words.length != 0
            safe_words.sample[fragment.length]
        else
            available_words.sample[fragment.length]
        end
    end
end