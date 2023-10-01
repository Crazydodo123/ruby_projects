class Player
    def get_move
        puts "enter a position with coordinates seperated with a space like `4 7`"
        gets.chomp.split.map!(&:to_i)
    end
end
