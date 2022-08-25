class Tree
  attr_reader :root

  def initialize(arr)
    arr = arr.sort.uniq
    last_idx = arr.length - 1
    @root = build_tree(arr, 0, last_idx)
  end
  
  def build_tree(arr, start, end_tree)
    if(start > end_tree) 
      return nil
    end
    mid = (start + end_tree) / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr, start, mid-1)
    root.right = build_tree(arr, mid+1, end_tree)

    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(val)
    current_node = @root
    inserted = false

    if (@root == nil)
      new_node = Node.new(val)
      @root = new_node
      return
    end

    while (!inserted)
      if val < current_node.value && current_node.left == nil
        new_node = Node.new(val)
        current_node.left = new_node
        inserted = true
      elsif val < current_node.value && current_node.left != nil
        current_node = current_node.left
      elsif val >= current_node.value && current_node.right == nil
        new_node = Node.new(val)
        current_node.right = new_node
        inserted = true
      elsif val >= current_node.value && current_node.right != nil
        current_node = current_node.right
      end
    end
  end
  
  def minValueNode(node)
    current = node
    while current && current.left != nil
      current = current.left
    end
    return current
  end

  def delete(current_node = @root, val)
    if (@root == nil)
      return
    end

    if val < current_node.value
      current_node.left = delete(current_node.left, val)
    elsif val > current_node.value
      current_node.right = delete(current_node.right, val)
    
    # if key is same as root's key, then This is the node
    # to be deleted
    else
      if current_node.left == nil && current_node.right == nil
        return nil
      elsif current_node.left == nil 
        return current_node.right
      elsif current_node.right == nil
        return current_node.left
      end

      temp = minValueNode(current_node.right)
      current_node.setValue(temp.value)
      current_node.right = delete(current_node.right, temp.value)
    end

    return current_node
  end

  def find(val)
    current_node = @root
    found = false

    if (@root == nil)
      return nil
    end

    while (!found)
      if val < current_node.value && current_node.left == nil
        return nil
      elsif val < current_node.value && current_node.left != nil
        current_node = current_node.left
      elsif val > current_node.value && current_node.right == nil
        return nil
      elsif val > current_node.value && current_node.right != nil
        current_node = current_node.right
      elsif val == current_node.value
        return current_node
      end
    end

    return nil
  end

  def level_order()
    queue = Array.new()

    if block_given?
      if @root == nil
        return 
      end

      queue.push(@root)

      while queue.size != 0
        current = queue[0]
        yield current

        if current.left != nil
          queue.push(current.left)
        end
        if current.right != nil
          queue.push(current.right)
        end
        queue.shift(1)
      end
    else
      values = Array.new()
      queue.push(@root)

      while queue.size != 0
        current = queue[0]
        values.push(current.value)

        if current.left != nil
          queue.push(current.left)
        end
        if current.right != nil
          queue.push(current.right)
        end

        queue.shift(1)
      end
      return values
    end
  end

  def inorder(node=@root, &block)
    if (node == nil)
      return;
    end

    if block_given?
      inorder(node.left, &block)
      block.call(node)
      inorder(node.right, &block)
    else
      inorder(node.left, &block)
      print "#{node.value} "
      inorder(node.right, &block)
    end
  end

  def preorder(node=@root, &block)
    if (node == nil)
      return;
    end

    if block_given?
      block.call(node)
      preorder(node.left, &block)
      preorder(node.right, &block)
    else
      print "#{node.value} "
      preorder(node.left, &block)
      preorder(node.right, &block)
    end
  end

  def postorder(node=@root, &block)
    if (node == nil)
      return;
    end

    if block_given?
      postorder(node.left, &block)
      postorder(node.right, &block)
      block.call(node)
    else
      postorder(node.left, &block)
      postorder(node.right, &block)
      print "#{node.value} "
    end
  end

  def height( height = 0, root)
    if (root == nil)
      return height
    end
    left_max_height = height( height + 1, root.left)
    right_max_height = height( height + 1, root.right)
    if right_max_height > left_max_height 
      return right_max_height
    else
      return left_max_height
    end
  end

  def depth(node)
    if (@root == nil || node == nil)
      return nil
    end
    current_node = @root
    found = false
    depth = 0
    val = node.value

    while (!found)
      if val < current_node.value && current_node.left == nil
        return nil
      elsif val < current_node.value && current_node.left != nil
        current_node = current_node.left
      elsif val > current_node.value && current_node.right == nil
        return nil
      elsif val > current_node.value && current_node.right != nil
        current_node = current_node.right
      elsif val == current_node.value
        break
      end
      depth += 1
    end

    return depth
  end

  def balanced?()
    if @root == nil
      return true
    end
    if @root.left == nil && @root.right == nil
      return true
    end

    left_height = height(@root.left)
    right_height = height(@root.right)

    diff = (left_height - right_height).abs()
    if diff > 1
      return false
    end

    return true
  end

  def rebalance()
    arr = Array.new()
    inorder() {|node| arr.push(node.value)}
    arr = arr.sort.uniq
    last_idx = arr.length - 1
    @root = build_tree(arr, 0, last_idx)
  end
end

class Node
  attr_reader :value
  attr_accessor :left
  attr_accessor :right

  def initialize(value = nil, left_node = nil, right_node = nil)
    @left = left_node
    @right = right_node
    @value = value
  end

  def setValue(value)
    @value = value
  end
end

#initiailize tree
array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)
tree.pretty_print()

# │           ┌── 6345
# │       ┌── 324
# │   ┌── 67
# │   │   │   ┌── 23
# │   │   └── 9
# └── 8
#     │       ┌── 7
#     │   ┌── 5
#     └── 4
#         │   ┌── 3
#         └── 1

#insert
tree.insert(2)
tree.pretty_print()

tree.insert(10)
tree.pretty_print()

#delete
tree.delete(10)
tree.pretty_print()

tree.delete(67)
tree.pretty_print()

#find
puts "found #{tree.find(9).value}"

#level order
tree.level_order { |node| puts "this node stores #{node.value}" }
print "breadth-first order: "
p tree.level_order

array2 = [0, 1, 7, 4, 23, 12, 11, 8, 2, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree2 = Tree.new(array2)
tree2.pretty_print()

print "printing values inorder: "
tree2.inorder { |node| print "#{node.value} " }
puts 

print "if no block is given, print values: "
tree2.inorder
puts 

print "printing values preorder: "
tree2.preorder { |node| print "#{node.value} " }
puts 

print "printing values postorder: "
tree2.postorder { |node| print "#{node.value} " }
puts 

puts tree.depth(tree.root.right.left.right)

tree.pretty_print
puts tree.height(tree.root.right)

tree.delete(324)
tree.delete(9)
puts tree.balanced?
puts tree2.balanced?

puts "tree before rebalancing: "
tree.pretty_print()
puts "tree after rebalancing: "
tree.rebalance()
tree.pretty_print()
puts tree.balanced?