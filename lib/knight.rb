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
    @root = Knight.new(start, finish)

    gerar_children(root, finish)

    gerar_graph(root, finish)

    end_node = check_child(root, finish)

    # p end_node.parent.parent

    parent = find_parent(end_node)

    count(parent)
  end

  def find_parent(node, order = [])
    order << node
    return order if node.parent.nil?

    find_parent(node.parent, order)
  end

  def count(arr, i = -1)
    until arr.empty?
      i += 1
      p arr.pop
    end

    if i == 1
      puts "Your Knight took #{i} move."
    else
      puts "Your Knight took #{i} moves."
    end
  end

  def gerar_children(node, finish, queue = [])
    return nil if node.nil?

    return if node.position == finish

    queue += node.adj_list[0][1..]

    if node.adj_list[0][1..].include?(finish)
      node.children << Knight.new(finish, finish, node)
    else
      node.children << Knight.new(queue.shift, finish, node) until queue.empty?
    end

    node
  end

  def gerar_graph(node, finish, queue = [])
    queue += node.children
    # p queue[0]
    gerar_children(queue.shift, finish) until queue.empty?
    node
  end

  def check_child(node, finish, queue = [], visited = [])
    return if node.nil?

    return node if node.position == finish

    return if visited.include?(node)

    visited << node

    queue += node.children unless node.children.nil?
    check_child(queue.shift, finish, queue, visited)

    # p node
  end
end

class Knight
  attr_accessor :position, :children, :parent, :visited

  def initialize(position, finish, parent = nil, children = [])
    return nil if position.nil?

    @visited = false

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
    "(Knight position: #{@position})"
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

# t = Board.new([3,3], [3,3])

# t = Board.new([3,3], [4,5])

t = Board.new([3, 3], [3, 3])
