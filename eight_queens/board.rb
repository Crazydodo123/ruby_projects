require "byebug"

class Board
    def initialize
        @solutions = []
        @grids = Hash.new { |h, k| h[k] = Array.new(8) {[]} }
        @grids[0] = Array.new(8) { Array.new(8) {" "} }
    end

    def print(num)
        @grids[num].each { |row| p row }
        puts
    end

    def check_st(ri, ci, grid)
        (0..7).each do |i|
            grid[ri][i] = "X" if  grid[ri][i] == " "
            grid[i][ci] = "X" if  grid[i][ci] == " "
        end
    end

    def check_dia(ri, ci, grid)
        (0..7).each do |i|
            grid[i][ci - ri + i] = "X" if (0..7).include?(ci - ri + i) && grid[i][ci - ri + i] == " " 
            grid[i][ri + ci - i] = "X" if (0..7).include?(ri + ci - i) && grid[i][ri + ci - i] == " "
        end
    end

    def solution(grid)
        solution = []
        grid.each do |row|
            row.map! do |el|
                if el == "X"
                    " "
                else
                    el
                end
            end

            solution << row[0..-1]
        end
        @solutions << solution
    end

    def [](index)
        @solutions[index].each { |row| p row }
        puts
    end

    def eight_queens(queens)
        queens += 1

        (0..7).each do |ri|
            next if ri < queens - 1 || ri >= queens
            ri = queens - 1
            (0..7).each do |ci|
                p "Testing [#{ri}, #{ci}]" if queens == 1
                if @grids[queens - 1][ri][ci] == " "
                    @grids[queens - 1].each_with_index { |row, i| @grids[queens][i] = row[0..-1] }
                    @grids[queens][ri][ci] = "Q"

                    check_st(ri, ci, @grids[queens])
                    check_dia(ri, ci, @grids[queens])

                    if queens == 8
                        self.solution(@grids[queens])
                        p "#{@solutions.length} solution(s) found"
                    end
                    self.eight_queens(queens)

                end
            end
        end
    end



end

b = Board.new
b.print(0)
b.eight_queens(0)
(0..91).each { |i| b[i]}