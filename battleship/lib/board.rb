require "byebug"

class Board
  attr_reader :size

  def initialize(n)
    @grid = Array.new(n) { Array.new(n) {:N} }
    @size = n * n
    @length = n
  end

  def [](position)
    @grid[position[0]][position[1]]
  end

  def []=(position, value)
    @grid[position[0]][position[1]] = value
  end

  def num_ships
    @grid.flatten.count(:S)
  end

  def attack(position)
    if self[position] == :S
      self[position] = :H
      puts "You sunk my battleship!"
      true
    else
      self[position] = :X
      false
    end
  end

  def place_random_ships
    ships_to_place = @size / 4

    until ships_to_place == 0
      position = [rand(@length), rand(@length)]
      if self[position] != :S
        self[position] = :S
        ships_to_place -= 1
      end
    end
  end

  def hidden_ships_grid
    @grid.map do |row|
      row.map do |x|
        if x == :S
          :N
        else
          x
        end
      end
    end
  end

  def self.print_grid(grid)
    grid.map! { |arr| arr.join(" ") }
    puts grid.join("\n")
  end

  def cheat
    Board::print_grid(@grid)
  end

  def print
    Board::print_grid(self.hidden_ships_grid)
  end
end
