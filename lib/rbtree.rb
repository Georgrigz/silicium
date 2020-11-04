class RB
  class Node
    public
    attr_accessor :color,:left,:right,:parent,:data

    def initialize(_data,_color)
      @data = _data
      @color = _color
    end
  end

  private
  @root

  def initialize;  end

  def left_rotate(node_x)
    node_y = node_x.right
    node_x.right = node_y.left
    if node_y.left != nil
      node_y.left.parent = node_x
    end
    if node_y != nil
      node_y.parent = node_x.parent
    end

    if node_x.parent == nil
      @root = node_y
    elsif node_x == node_x.parent.left
      node_x.parent.left = node_y
    else
      node_x.parent.right = node_y
    end
    node_y.left = node_x
    if node_x != nil
      node_x.parent = node_y
    end
  end

  def right_rotate(node_y)
    node_x = node_y.left
    node_y.left = node_x.right
    if node_x.right != nil
      node_x.right.parent = node_y
    end
    if node_x != nil
      node_x.parent = node_y.parent
    end

    if node_y.parent == nil
      @root = node_x
    end

    if node_y == node_y.parent.right
      node_y.parent.right = node_x
    end
    if node_y == node_y.parent.left
      node_y.parent.left = node_x
    end
    node_x.right = node_y
    if node_y != nil
      node_x.parent = node_x
    end
  end

  def in_order_display(current)
    if current != nil
      in_order_display current.left
      puts "#{current.data} "
      in_order_display current.right
    end
  end

  public
  def display_tree
    if @root == nil
      puts "Nothing in the tree!"
    else
      in_order_display @root
    end

  end

  def find(key)
    temp = @root
    while true
      if temp == nil
        return nil
      end
      if key == temp.data
        return temp
      end
      if key > temp.data
        temp = temp.right
      elsif key < temp.data
        temp = temp.left
      end
    end

  end

  def insert_fix_up(item)
    while item != @root && item.parent.color == :red
      if item.parent == item.parent.parent.left
        y = item.parent.parent.right
        if y!= nil && y.color == :red
          item.parent.color = :black
          y.color = :black
          item.parent.parent.color = :red
          item = item.parent.parent
        else
          if item == item.parent.right
            item = item.parent
            left_rotate item
          end
          item.parent.color = :black
          item.parent.parent.color = :red
          right_rotate item.parent.parent
        end
      else
        x = nil
        x = item.parent.parent.left
        if x!=nil && x.color == :black
          item.parent.color = :red
          x.color = :red
          item.parent.parent.color = :black
          item = item.parent.parent
        else
          if item == item.parent.left
            item = item.parent
            right_rotate item
          end
          item.parent.color = :black
          item.parent.parent.color = :red
          left_rotate item.parent.parent
        end
      end
      @root.color = :black
    end
  end

  def insert(item)
    new_item = Node.new(item,:black)
    if @root == nil
      @root = new_item
      @root.color = :black
      return
    end
    y = nil
    x = @root
    while x!=nil
      y = x
      if new_item.data < x.data
        x = x.left
      else
        x = x.right
      end
    end
    new_item.parent = y
    if y == nil
      @root = new_item
    elsif new_item.data < y.data
      y.left = new_item
    else
      y.right = new_item
    end
    new_item.left = nil
    new_item.right = nil
    new_item.color = :red
    insert_fix_up new_item
  end

  def delete_fix_up(x)
    while x != nil && x != @root && x.color == :black
      if x == x.parent.left
        w = x.parent.right
        if w.color == :red
          w.color = :black
          x.parent.color = :red
          left_rotate x.parent
          w = x.parent.right
        end
        if w.left.color == :black && w.right.color == :black
          w.color = :red
          x = x.parent
        elsif w.right.color == :black
          w.left.color = :black
          w.color = :red
          right_rotate w
          w = x.parent.right
        end
        w.color = x.parent.color; #case 4
        x.parent.color = :black; #case 4
        left_rotate x.parent
        x = @root
      else
        w = x.parent.left
        if w.color == :red
          w.color = :black
          x.parent.color = :red
          left_rotate x.parent
          w = x.parent.left
        end

        if w.right.color == :black && w.left.color == :black
          w.color = :red
          x = x.parent
        elsif w.left.color == :black
          w.right.color = :black
          w.color = :red
          right_rotate w
          w = x.parent.left
        end
        w.color = x.parent.color
        x.parent.color = :black
        left_rotate x.parent
        x = @root
      end
    end
  end
  def minimum(x)
    while x.left.left != nil
      x = x.left
    end
    if x.left.right != nil
      x = x.left.right
    end
    return x
  end
  def tree_successor(x)
    if x.left != nil
      return minimum x
    else
      y = x.parent
      while y != nil && x==y.right
        x = y
        y = y.parent
      end
      return y
    end
  end

  def delete(key)
    item = find key
    x = nil
    y = nil
    if item == nil
      return
    end

    if item.left == nil || item.right == nil
      y = item
    else
      y = tree_successor item
    end

    if y.left != nil
      x = y.left
    else
      x = y.right
    end

    if x != nil
      x.parent = y
    end
    if y.parent == nil
      @root = x
    elsif y == y.parent.left
      y.parent.left = x
    else
      y.parent.right = x
    end

    if y != item
      item.data = y.data
    end

    if y.color == :black
      delete_fix_up x
    end
  end
end

set = RB.new
set.insert 1
set.insert 2
set.insert 3
set.insert 9
#
set.delete 2
set.delete 9
set.delete 3

set.display_tree