# frozen_string_literal: true

require 'pry-byebug'
# criar um grafo
# vortices
# edges

class Board
  attr_accessor :board, :waiting_list, :root, :start, :finish, :ajd_list

  def initialize(start, finish)
    # @board = Array.new(8) { Array.new(8, 0) }
    # @start = asking_start
    # @finish = asking_end

    @root = gerar_tree(start, finish)

    p knight_trevails(@root, finish)

    # p @root.adj_list

    # @root.ajd_list_child(finish)
    # p @root.children
    # p @root
  end

  def knight_trevails(node, finish, queue = [], result = [])
    

    
   
    return if node.nil?

    return if result.include? node.position

    #p node.position

    result << node.position

    return result if node.position == finish
    queue += node.children unless node.children.nil?

    #p queue[0]
    p queue.include?(finish)

    knight_trevails(queue.shift, finish, queue, result, used) until queue.empty?

    node
  end

  def gerar_tree(start, finish, repeated = [], queue = [])

    node = Knight.new(start, finish)
    return nil if node.nil?
    return node if node.position == finish
    return nil if repeated.include?(node.position)

    repeated << start

    return node.position if finish == node.position

       

    queue += node.adj_list[0][1...].compact unless node.adj_list[0][1...].nil?


    #p queue

    if queue.include?(finish) 
      node.children << gerar_tree(finish, finish) 
    else
        node.children << gerar_tree(queue.shift, finish, repeated) until queue.empty?
    end
    

    # p repeated

    node
  end

  def insert_knight(height, width)
    @board[height][width] = Knight.new(height, width)
  end

  def asking_start
    puts 'where do you want to start?'
    input = gets.chomp.split('').map(&:to_i).reject(&:zero?)
    insert_knight(input[0], input[-1])
    input
  end

  def asking_end
    puts 'where do you want to end?'
    input = gets.chomp.split('').map(&:to_i).reject(&:zero?)
  end
end

class Knight
  attr_accessor :position, :children, :parent

  def initialize(position, finish, children = [])
    return nil if position.nil?

    @position = position
    movimentos(position[0], @position[-1])
    @children = children
    @parent = parent
    @adj_list = generate_array(position, finish)
  end

  def insert_child(_queue = [])
    @children = adj_list[0][1...]

    @children
  end

  def parent
    @parent.nil? ? nil : @parent
  end

  attr_reader :children, :adj_list, :position, :moves

  def adj_list_first
    @adj_list[0]
  end

  def adj_list_printer(i = 0)
    until i == adj_list.size
      adj_list[i][0]
      i += 1
    end
  end

  def generate_array(position, finish, queue = [], list = [], ajd_list = [])
    return if position.nil?
    return if list.include?(position)

    @moves = movimentos(position[0], position[-1])
    list << position
    queue += moves
    ajd_list << ((moves << position).reverse!)
    generate_array(queue.shift, finish, queue, list, ajd_list) until queue.empty?
    # p ajd_list.size
    ajd_list
  end

  def inspect
    "(Knight position: #{@position}, children: #{@children}, parent: #{@parent})"
  end

  def movimentos(height, width)
    @move_1 = moves_valid?(height + 2, width - 1)
    @move_2 = moves_valid?(height + 1, width + 2)
    @move_3 = moves_valid?(height + 1, width - 2)
    @move_4 = moves_valid?(height - 2, width + 1)
    @move_5 = moves_valid?(height - 2, width - 1)
    @move_6 = moves_valid?(height + 2, width + 1)
    @move_7 = moves_valid?(height - 1, width + 2)
    @move_8 = moves_valid?(height - 1, width - 2)
    moves = [@move_1, @move_2, @move_3, @move_4, @move_5, @move_6, @move_7, @move_8]
    @moves = moves
  end

  def moves_valid?(height, width)
    return nil if height > 7 || height.negative?
    return nil if width > 7 || width.negative?

    [height, width]
  end
end

 #t = Board.new([3,3], [3,3])

# t = Board.new([3,3], [4,5])

t = Board.new([3, 3], [4, 3])
