require 'natural_language/common'
=begin
= NaturalLanguage::ParseTree
Abstract Class of Parse tree
=end

class NaturalLanguage
  class ParseTree

    PRE  = 0
    IN   = 1
    POST = 2

    ROOT = '__ROOT__'
    TOP  = '__TOP__'

    ACTIVE  = 0
    INACTIVE = 1

    class UndefinedMethodCall < Exception ; end

    attr_reader :parent
    attr_accessor :state

    @@viewer = nil 
    def initialize() 
      @parent = ROOT
      @state  = ACTIVE
      @@viewer = TreeViewer.new unless @@viewer
      raise DisableConstruction
    end

    def active?
      @state == ACTIVE
    end

    def inactive?
      @state == INACTIVE
    end

    def active
      @state = ACTIVE
    end

    def inactive
      @state = INACTIVE
    end

    def root?
      @parent === ROOT
    end

    def top?
      @parent === TOP
    end

    def to_top
      @parent = TOP
    end

    def leaf?
      (num_of_children == 0 )
    end

    def most_left?
      raise UndefinedMethodCall
    end

    def most_right?
      raise UndefinedMethodCall
    end

    def == (_arg)
      raise UndefinedMethodCall
    end

    def === (_arg)
      self.object_id == _arg.object_id
    end

    def each_child(&proc)
      raise UndefinedMethodCall
    end

    def each_left_child(&proc)
      raise UndefinedMethodCall
    end

    def each_right_child(&proc)
      raise UndefinedMethodCall
    end

    def most_left_child(&proc)
      raise UndefinedMethodCall
    end

    def most_right_child(&proc)
      raise UndefinedMethodCall
    end

    def most_left_ancestor
      raise UndefinedMethodCall
    end

    def most_right_ancestor
      raise UndefinedMethodCall
    end
    
    def grandparent
      return nil if parent.is_root? || parent.is_top?
      _parent = parent.parent
      return nil if _parent.is_root? || _parent.is_top? 
      return _parent.parent
    end

    def num_of_children
      raise UndefinedMethodCall
    end

    def depth(_root=nil)
      return 0 if root? || top? || (self === _root)
      return @parent.depth(_root) + 1
    end

    def add(_child)
      raise UndefinedMethodCall
    end

    def delete(_child)
      raise UndefinedMethodCall
    end

    def _depth_first_traverse(_order=PRE, &proc)
      yield(self) if _order == PRE

      self.each_left_child do |_ch|
	_ch._depth_first_traverse(_order, &proc)
      end
      yield(self) if _order == IN
      self.each_right_child do |_ch|
	_ch._depth_first_traverse(_order, &proc)
      end
      yield(self) if _order == POST
    end
    protected :_depth_first_traverse

    def depth_first_traverse(&proc)
      pre_order(&proc)
    end 

    def pre_order(&proc)
      _depth_first_traverse(PRE, &proc)
    end

    def in_order(&proc)
      _depth_first_traverse(IN, &proc)
    end

    def post_order(&proc)
      _depth_first_traverse(POST, &proc)
    end

    def show(_os=$stdout)
      @@viewer.draw(self, _os)
    end

    def to_s
      raise UndefinedMethodCall
    end
    
  end
end

class NaturalLanguage
  class ParseTree
    class TreeViewer
      class Coordinate
	attr_accessor :x, :y
	def initialize(_x=0, _y=0)
	  @x = _x
	  @y = _y 
	end
	def to_s
	  return "(%s,%s)" % [@x, @y]
	end
      end

      BLANK = ' '
      HORIZONTAL_LINE = '---'
      VERTICAL_LINE   = ' | '
      

      def initialize()
	@length = Hash.new
	@canvas = []
	@max_depth = 0
	@coodinates = Hash.new
	@max_width = 0 
      end

      def clear
	@length.clear
	@canvas.clear
	@max_depth = 0
	@max_width = 0 
	@coodinates.clear
      end

      def get_xs_of_both_sides(_node)

	xl = nil
	xr = nil 
	l = _node.most_left_child
	r = _node.most_right_child

	xl = @coordinates[l.object_id].x if l 
	xr = @coordinates[r.object_id].x if r 

	if xl == nil || xr == nil
	  @coordinates[_node.object_id].x 
	end
	

	if _node.kind_of?(DependencyStructure)
	  return _node.offset * 2 , xr if xl == nil 
	  return xl, _node.offset * 2  if xr == nil 
	  return xl, xr
	end

	#if _node.kind_of?(PhraseStructure)
	  return xr - (_node.num_of_children * 2), xr if xl == nil 
	  return xl, xl + (_node.num_of_children * 2) if xr == nil 
	  return xl, xr
	#end
      end

      def none_leaf_coodinate(_node)
	s, e = get_xs_of_both_sides(_node)
	if _node.kind_of?(DependencyStructure)
	  return s unless _node.most_left_child
	  return e unless _node.most_right_child
	  return s + ((e - s) / 2 )
	end
	#if _node.kind_of?(PhraseStructure)
	  return e unless _node.most_left_child
	  return s unless _node.most_right_child
	  return s + ((e - s) / 2 )
	#end

      end


      def fill(_pen=' ')
	(0 .. @max_width).each do |x|
	  (0 .. @max_depth).each do |y|
	    d = @max_depth - y 
	    @canvas[x][d] = _pen * (@length[y] + 2) unless @canvas[x][d]
	  end
	end
      end


      def get_x(_node)
	if _node.kind_of?(DependencyStructure)
	  @max_width += 2
	  return _node.offset * 2 
	end
	#if _node.kind_of?(PhraseStructure)
	  if _node.leaf?
	    i = @max_width 
	    @max_width += 2
	    return i 
	  else
	    return  none_leaf_coodinate(_node)
	  end
	#end


      end

      def draw(_tree, _os=$stdout)
	clear
	@max_depth = 0 
	@max_width = 0 
	@length = Hash.new(0)

	@coordinates = Hash.new()
	
	_tree.post_order do |_node|

	  next if _node.offset < 0

	  @coordinates[_node.object_id] = Coordinate.new unless @coordinates[_node.object_id]
	  @coordinates[_node.object_id].x = get_x(_node)
	  d = _node.depth
	  @coordinates[_node.object_id].y = d
	  l = _node.to_s.size
	  @length[d] = l  if @length[d] < l
	  @max_depth = d if d > @max_depth
	end

	@canvas = Array.new(@max_width)

	(0 .. @max_width).each{|i| @canvas[i] = Array.new(@max_depth) } 
	
	_tree.post_order do |_node|
	  next if _node.offset < 0
	  i = @coordinates[_node.object_id].x
	  j = @max_depth - @coordinates[_node.object_id].y
	  d = @coordinates[_node.object_id].y
	  l = @length[d]
	  _stem  = '-+'
	  _edge = ' ' * (l - _node.to_s.size)
	  _edge = '-' * (l - _node.to_s.size) unless _node.leaf?
	  _pic = "%s%s%s" % [_edge, _node, _stem] 
	  # puts "(%s,%s) = [%s] %s" % [i, j, _pic, @canvas.size]
	  @canvas[i][j] = _pic
	  next if _node.leaf?
	  
	  s, e = get_xs_of_both_sides(_node)
	  # puts "--> %s,%s <-- %s,%s" % [s, e, _node, j ]
	  t = j - 1
	  (s .. e).each do |x| 
	    next if @canvas[x][t]
	    _edge = ' |'
	    _edge = ' +' if x == i 
	    l = @length[d + 1]
	    _pic = "%s%s" % [' ' * l, _edge]
	    # puts "(%s,%s) = [%s]" % [x,t, _pic]

	    @canvas[x][t] = _pic 
	  end
	end
	fill(' ')
	(0 .. @max_width).each do |i| 
	  (0 .. @max_depth).each do |j|
	    _os.print @canvas[i][j]
	  end
	  _os.puts
	end
      end

    end
  end
end

class NaturalLanguage
  class ParseTree
    class PhraseStructure < ParseTree
      class Index
	attr_accessor :left, :height, :right

	def Index.nodes_to_instance(l, h, r)
	  _left = -1
	  _height = 0
	  _right = -1
	  _left =  l.most_left_child.index 
	  _right =  r.most_right_child.index 
	  _height =  h.heaight if h 
	  return Index.new(_left, _height, _right)
	end

	def initialize(l=0, h=-1, r=0)
	  @left = l
	  @height = h 
	  @right = r 
	end

	def to_s
	  return "#{@left}-#{@height}-#{@right}"
	end

	def hash
	  return self.to_s.hash
	end

	def == (_arg)
	  eql?(_arg)
	end

	def < (_arg)
	  return true  if @left   < _arg.left
	  return false if @left   > _arg.left
	  return true  if @right  < _arg.right
	  return false if @right  > _arg.right
	  return true  if @height < _arg.height
	  return false if @height > _arg.height
	end

	def > (_arg)
	  return false if self == _arg
	  return false if self < _arg
	  return true 
	end

	def clone
	  _clone = Index.new
	  _clone.left = @left
	  _clone.right = @right
	  _clone.height = @height
	  return _clone
	end

	def <=> (_arg)
	  return -1 if self < _arg
	  return 0  if self == _arg
	  return 1  if self > _arg
	end

	def eql?(_arg)
	  (@left == _arg.left) && (@height == _arg.height) && (@right == _arg.right )
	end
      end
    end
  end
end

class NaturalLanguage
  class ParseTree
    class PhraseStructure < ParseTree
      attr_accessor :index, :prev, :next, :parent
      attr_reader :candidates

      def initialize() 
	begin
	  super()
	rescue DisableConstruction
	rescue Exception
	  raise 
	end
	@parent = ROOT
	@prev = nil
	@next = nil
	@index = nil
	@candidates = nil 
	raise DisableConstruction, "%s is an abstruct class" 
      end      

      def indexing
	_id = 0
	post_order do |_node|

	  if _node.terminal?
	    _node.index = Index.new(_id, 0, _id)
	    _id += 1
	    next
	  end
	
	  _ml = _node.most_left_child
	  _mr = _node.most_right_child
	  h = _node.head
	  _node.index = Index.new(_ml.index.left, h.index.height + 1, _mr.index.right)
	end
	# @parent.index = Index.new(@index.left, @index.height + 1, @index.right)
	return self
      end

      def hard_copy
	if self.terminal?
	  return self.clone
	end
	_hc = self.clone
	each_child do |c|
	  x = c.hard_copy
	  _hc.add(x) if x
	end
	return _hc
      end

      def most_left?
	@prev == nil 
      end

      def most_right?
	@next == nil 
      end

      def == (_arg)
	self.object_id == _arg.object_id
      end

      def offset
	return 0 
      end

      def terminal?
	self.kind_of?(Terminal)
      end

      def none_terminal?
	self.kind_of?(NoneTerminal)
      end

      def root?
	return false if self.terminal?
	return (@phrasal_category == ROOT) || (@phrasal_category == TOP)
      end
      
      def top?
	return false if self.terminal?
	return @phrasal_category == TOP
      end

      def head_terminal
	_node = self
	while _node.none_terminal?
	  _node = _node.head_child
	end
	return _node
      end

      def set_candidates(_canididates)
      end

      def reduce_unary
	self.post_order do |_node|
	  next if _node.terminal?
	  next if _node.num_of_children > 1
	  c = _node.most_left_child
	  next if c.terminal?
	  next unless c.phrasal_category == _node.phrasal_category
	  _node.delete(c)
	  _node.head = c.head 
	  _node.index = c.index 
	  _node.clean
	  c.each_child do |x|
	    _node.add(x)
	  end

	end
      end

      class NoneTerminal < PhraseStructure 
	attr_accessor :phrasal_category, :head

	def initialize(_phrasal_category=nil, _function=nil)
	  begin
	    super()
	  rescue DisableConstruction
	  rescue Exception
	    raise 
	  end
	  @phrasal_category = _phrasal_category
	  @parent = ROOT
	  @funcion = _function
	  @head_index = nil 
	  @head = nil
	  @children = []
	  @unsorted = true
	end

	def clone
	  _clone = NoneTerminal.new
	  _clone.phrasal_category = @phrasal_category
	  _clone.head = @head
	  _clone.index = @index.clone 
	  _clone.set_candidates(@candidates)
	  return _clone
	end

	def NoneTerminal.top
	  return NoneTerminal.new(ParseTree::TOP)
	end

	def NoneTerminal.root
	  return NoneTerminal.new(ParseTree::ROOT)
	end

	ROOT = NoneTerminal.root	

	def bracketing
	  b = []
	  b << "( " if @parent && @parent.top?
	    
	  b << "(#{@phrasal_category}"
	  each_child do |c|
	    b << " " 
	    b << c.bracketing
	  end
	  b << ")"
	  b << " )" if @parent && @parent.top?
	  return b.join("")
	end

	

	def unlexicalize
	  return @phrasal_category.class::TAG 
	end

	def find_head
	  @head_index = @phrasal_category.find_head_index(@children)
	  @head = @children[@head_index]
	end

	def add(_node)
	  raise Exception, "%s is not an instance of the ParseTree class" % _node unless _node.kind_of?(ParseTree)
	  raise Exception, "can not add to itsself" if _node.object_id == self.object_id
	  if num_of_children > 0 
	    _node.prev = @children[-1]
	    @children[-1].next = _node
	  end

	  @children << _node
	  _node.parent = self
	  @unsorted = true
	end

	def clean
	  m = @children.size 
	  (1 .. m).each do |i|
	    x = @children.shift
	    next unless x
	    @children << x 
	  end
	end

	def delete(_node)
	  if _node.index
	    @children.each_index do |i|
	      c = @children[i]
	      next unless c.index 
	      next unless c.index == _node.index
	      c.prev = nil
	      c.next = nil
	      c.parent = nil 
	      @children[i] = nil 
	    end
	  else
	    @children.each_index do |i|
	      c = @children[i] 
	      next unless c.object_id == _node.object_id
	      c.prev = nil
	      c.next = nil
	      c.parent = nil 
	      @children[i] = nil 
	    end
	  end
	  

	end

	def head_pos
	  _node = self
	  while _node.none_terminal?
	    _node = _node.head_child
	  end
	  return _node.part_of_speech
	end



	def head_word
	  _node = self
	  while _node.none_terminal?
	    _node = _node.head_child
	  end
	  return _node.word
	end
	
	def head_child
	  return @head
	end

	def head_index
	  return nil if @head == nil 

	  @children.each_index do |i|
	    return i if @children[i].object_id == @head.object_id
	  end
	  return nil
	  @children.each_index do |i|
	    return i if @children[i].index == @head.index
	  end
	  return nil
	end

	def most_left_child
	  return @children[0]
	end

	def most_right_child
	  return @children[-1]
	end

	def to_cfg_rule
	  return self, @children
	end

	def to_s
	  f = nil  ; h = nil 
	  f = '-%s'% @funcion if @funcion
	  if h = head_index
	    h = '<%s>' % (h + 1)
	  end
	  c = @phrasal_category 
	  c = '?' unless @phrasal_category
	  i = ''
	  i = "#{@index}:" if @index
	  return "#{i}%s%s%s" % [c, f, h]
	end

	def num_of_children
	  n = 0
	  each_child do |c|
	    next unless c
	    n += 1 
	  end
	  return n 

	end

	def _sort_children
	  return nil unless @unsorted
	  return nil unless @index

	  @children = @children.sort{|x,y| x.index <=> y.index}
	  @unsorted = false 
	  return true
	end

	def each_left_child(&proc)
	  each_child(&proc) 
	end

	def each_right_child(&proc)

	end


	def each_child
	  _sort_children
	  @children.each do |_node|
	    yield(_node)
	  end
	end
      end

      class Terminal < PhraseStructure 
	attr_accessor :word, :offset 
	attr_reader :part_of_speech

	def initialize(_part_of_speech=nil)
	  begin
	    super()
	  rescue DisableConstruction
	  rescue Exception
	    raise 
	  end
	  @parent = NoneTerminal::ROOT
	  @part_of_speech = _part_of_speech
	  @word = nil
	  @offset = -1
	end

	def bracketing
	  return "(#{@part_of_speech} #{@word})"
	end

	def clone
	  _clone = Terminal.new(@part_of_speech)
	  _clone.word = @word
	  _clone.offset = @offset
	  _clone.index = @index.clone
	  _clone.set_candidates(@candidates)
	  return _clone
	end

	def find_head
	end

	def head_pos
	  return @part_of_speech
	end

	def head_word
	  return @word
	end

	def head_child
	  nil 
	end

	def unlexicalize
	  return @part_of_speech.class::TAG
	end

	def most_left_child
	  return nil 
	end

	def most_right_child
	  return nil 
	end

	def add(_node)
	  raise "can not add any nodes to a terminal node."
	end

	def to_s
	  "%s/%s" % [@word, @part_of_speech.to_s]
	end

	def num_of_children
	  return 0 
	end

	def each_left_child(&proc)
	end

	def each_right_child(&proc)
	end

	def each_child(&proc)
	end
      end





    end
  end
end

class NaturalLanguage
  class ParseTree
    class DependencyStructure < ParseTree


      attr_accessor :offset, :word, :prev, :next, :parent, :left_adjacent, :right_adjacent
      attr_reader :part_of_speech

      def initialize(_word='', _part_of_speech=nil, _offset=-1)
	begin
	  super()
	rescue DisableConstruction
	rescue Exception
	  raise 
	end
	@parent = nil 
	@part_of_speech = _part_of_speech
	@word = _word
	@left_children = []
	@right_children = []
	@offset = _offset
	@left_adjacent = nil
	@right_adjacent = nil
      end
      alias :index :offset 


      def clone
	_clone = DependencyStructure.new(@word, @part_of_speech, @offset)
	_clone.state = @state
	return _clone
      end

      def part_of_speech=(_pos) 
	raise Exception, "must be an instance of PartOfSpeech Class." unless _pos.kind_of?(PartOfSpeech)
	@part_of_speech = _pos
      end

      def DependencyStructure.each_tree(_is = $stdin, _POS=NaturalLanguage::PartOfSpeech, _fidx=1, _delimiter=/[\s\t]+/)
	while _trees = DependencyStructure.get_tree(_is, _POS, _fidx, _delimiter)
	  yield(_trees)
	end
      end

      def DependencyStructure.top
	return  DependencyStructure.new(NaturalLanguage::ParseTree::TOP, NaturalLanguage::PartOfSpeech::TOP.new, -1)
      end
 
      def DependencyStructure.get_tree(_is = $stdin, _POS=NaturalLanguage::PartOfSpeech, _fidx=1, _delimiter=/[\s\t]+/)
	_tokens = []
	_parents = Hash.new
	_offset = _fidx
	_line = nil 


	# while (! _is.eof? || _tokens.size > 0)
	while (! _is.eof? || _tokens.size > 0)
	  _line = _is.gets 
	  if (_line && (/^[\s\t]*\n/ =~ _line)) || (_line == nil && _is.eof?)
	    
	    _top = DependencyStructure.top
	    _tokens.each do |_node|
	      next unless _node
	      unless _node.offset - 1 < _fidx
		_node.left_adjacent = _tokens[_node.offset - 1]
	      end

	      if _node.offset + 1 < _tokens.size 
		_node.right_adjacent = _tokens[_node.offset + 1]
	      end

	      _parent = _parents[_node.offset] 
	      if _parent < 0 
		_top.add(_node) ; next ; 
	      end
	      # puts "p=#{_tokens[_parent]}, #{_node}"
	      _tokens[_parent].add(_node)
	    end
	    return _top if _top.num_of_children > 0 
	    _tokens.clear
	    _offset = _fidx
	    break if _is.eof?
	    next
	  end

	  _word, _pos, _dep, = _line.split(_delimiter)
	  _pos = NaturalLanguage::PartOfSpeech::UNK::TAG.clone unless _pos
	  _pos = _POS.s_to_instance(_pos)

	  if _dep == nil 
	    _dep = -1 
	  else
	    _dep = _dep.to_i 
	  end
	  _parents[_offset] = _dep 

	  _tokens[_offset] = DependencyStructure.new(_word, _pos, _offset)
	  _offset += 1
	end
	return nil 
      end

      def top?
	return @offset < 0 
      end

      def root?
	#return false if top? 
	#puts self
	return (top? || @parent == nil || @parent.top? )
      end

      def == (_dtree)
	return false unless _dtree.kind_of?(DependencyStructure)
	@offset == _dtree.offset
      end

      def clean
	s = @left_children.size 
	(0 ... s).each do |i|
	  x = @left_children.shift 
	  next unless x
	  @left_children << x 
	end

	s = @right_children.size 
	(0 ... s).each do |i|
	  x = @right_children.shift 
	  next unless x
	  @right_children << x 
	end

      end

      def delete(_node)
	# puts "parse_tree@delete  #{self}  #{_node}"
	if _node.offset < @offset
	  l = @left_children.size 
	  (0 ... l).each do |i|
	    x = @left_children[i]
	    next if x == nil 
	    if x.offset == _node.offset
	      # puts "!! delete !! #{x}, #{_node}"
	      # x.parent
	      @left_children[i] = nil 
	      x.parent = nil 
	      next 
	    end
	    # @left_children << x 
	  end
	end
	
	if _node.offset > @offset
	  r = @right_children.size 
	  (0 ... r).each do |i|
	    # x = @right_children.shift
	    x = @right_children[i]
	    next if x == nil 
	    if x.offset == _node.offset
	      @right_children[i] = nil 
	      x.parent = nil 
	      next 
	    end
	    # @right_children << x 
	  end
	end
	
      end

      def each_child(&proc)
	@left_children.each do |_node|
	  yield(_node)
	end

	@right_children.each do |_node|
	  yield(_node)
	end
      end

      def each_left_child(&proc)
	@left_children.each do |_node|
	  next if _node == nil 
	  yield(_node)
	end
      end

      def each_right_child(&proc)
	@right_children.each do |_node|
	  next if _node == nil 
	  yield(_node)
	end
      end

      def each_left_adjacent
	_node = self
	while _node = _node.left_adjacent
	  yield(_node)
	end
      end

      def each_right_adjacent
	_node = self
	while _node = _node.right_adjacent
	  yield(_node)
	end
      end

      def most_left?
	return num_of_left_children == 0 
      end

      def most_right?
	return num_of_right_children == 0 
      end

      def most_left_child
	return nil if num_of_left_children == 0 
	return @left_children[0]
      end

      def most_right_child
	return nil if num_of_right_children == 0 
	return @right_children[-1]
      end

      def num_of_children
	num_of_left_children + num_of_right_children
      end

      def num_of_left_children
	@left_children.size
      end

      def num_of_right_children
	@right_children.size
      end
      
      def add_to_right(_node)
	return nil if _node.offset < 0 
	return nil if @offset > _node.offset 
	raise if @offset == _node.offset 
	@right_children << _node 
	_node.parent = self
	@right_children  = @right_children.sort{|x,y| x.offset <=> y.offset}  
	return _node
      end

      def add_to_left(_node)
	return nil if _node.offset < 0 
	return nil if @offset < _node.offset 
	raise if @offset == _node.offset 
	@left_children << _node 
	_node.parent = self
	@left_children = @left_children.sort{|x,y| x.offset <=> y.offset}  
	return _node
      end

      def add(_node)
	return _node if add_to_left(_node)
	return _node if add_to_right(_node)
	return nil 
      end

      def show(_os=$stdout)
	super(_os)
      end

      def each_token
	in_order do |_node|
	  next if _node.top?
	  yield(_node)
	end
      end
      alias each_node each_token

      def to_s
	_offset = @offset  
	_offset = -1 * num_of_right_children if top?
	return "%s:%s" % [_offset, @word]
      end

    end
  end
end


if __FILE__ == $0
end

__END__

