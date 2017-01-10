require 'natural_language/common'

class NaturalLanguage 
  class Context
    class LRpair
     attr_accessor :left, :right
      def initialize(_left, _right)
	@left = _left
	@right = _right
      end
      
      def + (i)
	@left += i
	@right += i
	return self
      end

      def - (i)
	@left -= i
	@right -= i
	return self
      end

      def to_s
	puts "[#{@left},#{@right}]"
      end
    end
  end
end

class NaturalLanguage 
  class Context

    attr_reader :target, :length
    attr_accessor :sequence, :time

    LEFT_TO_RIGHT = 1 
    RIGHT_TO_LEFT = -1

    def initialize(_sequence = nil)
      @target = LRpair.new(0,0)
      @sequence = _sequence
      @length = LRpair.new(2, 2)
      @time = 0 
    end

    def set_target_index(_left, _right=_left)
      @target.left = _left
      @target.right = _right
    end

    def current
      @target.left
    end

    def set_length(_left, _right)
      @length.left = _left
      @length.right = _right
    end

    def back(_step = 1)
      @target -= _step
      return nil if @target.left < 0
      return @target
    end

    def forward(_step = 1)
      @target += _step 
      return nil unless @target.right < @sequence.size
      return @target
    end

    def most_left_node
      each_left_node do |_node|
	return _node
      end
    end

    def most_right_node
      each_right_node(RIGHT_TO_LEFT) do |_node|
	return _node
      end
    end

    def _each_node(s, e, d)
      if d == LEFT_TO_RIGHT
	s.upto(e) do |i|
	  if i < 0 
	    yield(nil) ; next
	  end
	  unless i < @sequence.size
	    yield(nil) ; next
	  end
	  yield(@sequence[i])
	end
	return 
      end

      if d == RIGHT_TO_LEFT
	e.upto(s) do |i|
	  if i < 0 
	    yield(nil) ; next
	  end
	  unless i < @sequence.size
	    yield(nil) ; next
	  end
	  yield(@sequence[i])
	end
	return
      end
      raise "Invalid direction:" 
    end

    def each_left_node(_direction=LEFT_TO_RIGHT)
      s = @target.left - @length.left
      #s = 0 if s < 0  
      e = @target.left - 1
      #return if e < s 
      _each_node(s, e, _direction) do |_node|
	yield(_node)
      end
    end

    def each_right_node(_direction=LEFT_TO_RIGHT)
      s = @target.right + 1
      e = @target.right + @length.right
      #e = @sequence.size - 1 unless e < @sequence.size 

      #return if e < s 
      _each_node(s, e, _direction) do |_node|
	yield(_node)
      end
    end

    def each_outside_left_node(_direction=LEFT_TO_RIGHT)
      s = 0
      e = @target.left - @length.left - 1 
      return if e < s 
      _each_node(s, e, _direction) do |_node|
	yield(_node)
      end
    end

    def each_outside_right_node(_direction=LEFT_TO_RIGHT)
      s = @target.right + @length.right + 1
      e = @sequence.size - 1
      return if e < s 
      _each_node(s, e, _direction) do |_node|
	yield(_node)
      end
    end

    def each_left_parent_candidate
      @sequence[@target.left].each_left_parent_candidate do |_node|
	yield(_node)
      end
    end

    def each_right_parent_candidate
      @sequence[@target.right].each_right_parent_candidate do |_node|
	yield(_node)
      end
    end

    def adjacent_nodes
      _left = nil 
      _right = nil 
      i = @target.left - 1
      _left = @sequence[i] unless i < 0
      i = @target.right + 1
      _right = @sequence[i] if i < @sequence.size 
      return _left, _right
    end

    def each_target_node
      _left  = @sequence[@target.left]
      _right = @sequence[@target.right]
      yield(_left)
      yield(_right) if _left != _right 
    end

    def target_node
      return @sequence[@target.left]
    end

    def target_nodes
      return @sequence[@target.left], @sequence[@target.right]
    end
    
    def to_s
      _str = [] 
      _str << '['
      each_left_node do |_node|
	_str << _node
      end
      _str << '|'
      each_target_node do |_node|
	_str << _node
      end
      _str << '|'
      each_right_node do |_node|
	_str << _node
      end
      _str << ']'
      return _str.join(" ")
    end

  end
end

if __FILE__ == $0
  a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
  _context = NaturalLanguage::Context.new
  _context.sequence = a
  while true
    puts _context.to_s
    break unless _context.forward
  end
end
