class NaturalLanguage
  class Parser

    class InvalidOperation < Exception ; end 
    class InfiniteLoop < Exception ; end 
    class Fail < Exception ; end
    class Success < Exception ; end 

    LEFT_TO_RIGHT = +1
    RIGHT_TO_LEFT = -1

    def initialize(_model=nil) 
      @model = _model
      @submodel = nil 
      @sentence = nil
      @direction = LEFT_TO_RIGHT 
    end

    def trace
    end

    def left_to_right
      @direction = LEFT_TO_RIGHT
    end

    def right_to_left
      @direction = RIGHT_TO_LEFT
    end

    def left_to_right?
      @direction == LEFT_TO_RIGHT
    end

    def right_to_left?
      @direction == RIGHT_TO_LEFT
    end

    def reverse
      if left_to_right?
	return right_to_left 
      end
      left_to_right
    end

    def parse()
    end

    def parse_tree
    end

    def set_sentence(_sentence) 
      @sentence = _sentence
    end

  end
end

class NaturalLanguage
  class Parser
    class Feature
      attr_accessor :position, :type, :value
      def initialize(_position=nil, _type=nil, _value=nil)
	@position = _position
	@type     = _type
	@value    = _value
      end

      def == (_feature)
	(@position == _feature.position) && (@type == _feature.type)
      end

      def === (_feature)
	(self == _feature) && (@value == _feature)
      end

      def to_s
	"#{@position}.#{@type}.#{@value}"
      end
    end
  end
end

