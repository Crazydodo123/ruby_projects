class Maze
    attr_accessor :current_pos, :final_pos

    def initialize(file)
        @maze = File.readlines(file).map { |row| row.chomp.split("") }
        @maze.each_with_index do |row, ri|
            row.each_with_index do |el, ci|
                @maze[ri][ci] = "0" if el == "S"
                @final_pos = [ri, ci] if el == "E"
            end
        end
    end

    def print
        @maze.each { |row| p row }
    end

    def step(num)
        positions = []
        @maze.each_with_index do |row, ri|
            row.each_with_index do |el, ci|
                positions << [ri, ci] if el == num.to_s
            end
        end

        positions.each do |pos|
            (-1..1).each do |row_m|
                (-1..1).each do |col_m|
                    if row_m.abs + col_m.abs == 1
                        ri, ci = pos
                        raise if @maze[ri + row_m][ci + col_m] == "E"
                        if @maze[ri + row_m][ci + col_m] == " "
                            @maze[ri + row_m][ci + col_m] = (num + 1).to_s
                        end
                    end
                end
            end
        end
    end

    def retrace(num)
        (-1..1).each do |row_m|
            (-1..1).each do |col_m|
                if row_m.abs + col_m.abs == 1
                    ri, ci = @final_pos
                    raise if @maze[ri + row_m][ci + col_m] == "0"
                    if @maze[ri + row_m][ci + col_m] == num.to_s
                        @maze[ri + row_m][ci + col_m] = "X"
                        @final_pos = [ri + row_m, ci + col_m]
                        return
                    end
                end
            end
        end
    end

    def run
        begin
            i = 0
            until @maze.flatten.none? { |el| el == " "}
                self.step(i)
                i += 1
            end
            self.step(i)
        rescue
            until i == 0
                self.retrace(i)
                i -= 1
            end
            @maze.map! do |row|
                row.map! do |el|
                    if el == "0"
                        "S"
                    elsif el.to_i != 0
                        " "
                    else
                        el
                    end
                end
            end
        end
    end

    def show_ans
        @maze.each { |row| puts row.join }
    end
end

m = Maze.new("maze1.txt")
puts
m.run
m.show_ans