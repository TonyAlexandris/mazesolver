require "byebug"

rows_in_maze = 0
File.readlines(ARGV[0]).each {|line| rows_in_maze += 1}
maze_grid = Array.new(rows_in_maze) {Array.new} 
File.readlines(ARGV[0]).each_with_index do |line, i|
    line.chomp.each_char {|char| maze_grid[i] << char}
end

class Maze
    attr_accessor :maze_grid, :position_index, :x, :y, :position, :move_sequence, :dead_ends, :total_moves
    attr_reader :start_position, :end_x, :end_y, :end_index, :start_x, :start_y, :start_index
    def initialize(maze_grid)
        @maze_grid = maze_grid
        @position_index = []
        @maze_grid.each_with_index do |row, row_i|
            row.each_with_index do |space, column_i|
                if space == "S"
                    @position_index << row_i
                    @position_index << column_i
                end
            end
        end

        @x = position_index[1]
        @y = position_index[0]
        @position = maze_grid[y][x]
        @start_index = []
        @maze_grid.each_with_index do |row, row_i|
            row.each_with_index do |space, column_i|
                if space == "S"
                    @start_index << row_i
                    @start_index << column_i
                end
            end
        end        
        @start_x = start_index[1]
        @start_y = start_index[0]
        @end_index = []
        maze_grid.each_with_index do |row, row_i|
            row.each_with_index do |space, column_i|
                if space == "E"
                    @end_index << row_i
                    @end_index << column_i
                end
            end
        end
        @end_x = @end_index[1]
        @end_y = @end_index[0]
        @end = maze_grid[end_y][end_x]
        @move_sequence = []
        @dead_ends = []
        @total_moves = 0
    end

    def print_maze
        @maze_grid.each do |row| 
            print row
            puts
        end
    end

    def print_position
        puts @position
        puts x.to_s + " " + y.to_s
    end


    def valid_position?(position)
        return false if position == "*" || position == "X"
        #return false if @dead_ends.include?(position_index)
        return false if position == "D"
        true
    end



    def move
        moved = false
        right = maze_grid[y][x + 1]
        left = maze_grid[y][x - 1]
        up = maze_grid[y + 1][x]
        down = maze_grid[y - 1][x]
        if x < @end_x && valid_position?(right)
            @x += 1
            maze_grid[y][x] = "X"
            moved = true
        elsif x > @end_x && valid_position?(left)
            @x -= 1
            maze_grid[y][x] = "X"
            moved = true
        else
            if y < @end_y && valid_position?(up)
                @y += 1
                maze_grid[y][x] = "X"
                moved = true
            elsif y > @end_y && valid_position?(down)
                @y -= 1
                maze_grid[y][x] = "X"
                moved = true
            end
        end
        if moved == false && (!valid_position?(left) || !valid_position?(right))
            if valid_position?(down)
                @y -= 1
                maze_grid[y][x] = "X"
                moved = true
            end
            if valid_position?(up) && moved == false
                @y += 1
                maze_grid[y][x] = "X"
                moved = true
            end
        end 
        if moved == false && (!valid_position?(up) || !valid_position?(down))
            if valid_position?(left)
                @x -= 1 
                maze_grid[y][x] = "X"
                moved = true
            end
            if valid_position?(right) && moved == false
                @x += 1 
                maze_grid[y][x] = "X"
                moved = true
            end
        end
        if !valid_position?(right) && !valid_position?(left) && !valid_position?(down) && !valid_position?(up)
                #@dead_ends << @position_index
                if  x == @start_x && @y == @start_y
                    return false
                end
                maze_grid[y][x] = "D"
                @total_moves = 0
                self.restart
                #total_moves = 0
        end          
    end

    def solve
        right = maze_grid[y][x + 1]
        left = maze_grid[y][x - 1]
        up = maze_grid[y + 1][x]
        down = maze_grid[y - 1][x]
        while @x != @end_x || @y != @end_y
            current_x = position_index[1]
            current_y = position_index[0]
            self.move
            #if !valid_position?(right) && !valid_position?(left) && !valid_position?(down) && !valid_position?(up)
            #    #@dead_ends << @position_index
            #    maze_grid[y][x] = "D"
            #    self.restart
            #    total_moves = 0
            #end
            if self.move == false
                puts "No solution"
                return self.print_maze
            end
            @total_moves += 1
        end
        maze_grid[y][x] = "E"
        self.print_maze
        @total_moves -= 1
        puts @total_moves.to_s
    end
    
    def restart
        maze_grid.each_with_index {|row, y| row.each_with_index {|space, x| maze_grid[y][x] = " " if space == "X"}}
        @x = start_x
        @y = start_y
    end
end

a = Maze.new(maze_grid)
#debugger
a.solve


