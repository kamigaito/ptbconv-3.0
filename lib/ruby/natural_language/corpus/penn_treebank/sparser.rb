require 'natural_language/corpus/penn_treebank/common'
require 'natural_language/parse_tree'
require 'natural_language/corpus/penn_treebank/phrasal_category'
require 'natural_language/corpus/penn_treebank/function'
require 'natural_language/corpus/penn_treebank/pos'

class NaturalLanguage 
  class Corpus
    class PennTreebank
      class SformParser

	OPENED_PARENTHESIS = '('
	CLOSED_PARENTHESIS = ')'
	DELIMITER = /[\s\t\n]/

	NoneTerminal = ParseTree::PhraseStructure::NoneTerminal
	Terminal     = ParseTree::PhraseStructure::Terminal
	class EOF < Exception ; end ; 
	class Fail < Exception ; end ;  

	def initialize
	  @stack = []
	  @is = nil 
	  @token = [] 
	end

	def trace(_str)
	end

	def ignore?(_part_of_speech)
	  false
	end

	def ignore?(_part_of_speech)
	  _part_of_speech.kind_of?(PartOfSpeech::NONE)
	end

	def each_token
	  @token.clear
	  while _line = @is.gets
	    trace _line
	    _line.split('').each do |c|
	      if c == OPENED_PARENTHESIS || c == CLOSED_PARENTHESIS
		yield(@token.join('')) if @token.size > 0
		@token.clear
		yield(c) ; next 
	      end
	      if DELIMITER =~ c 
		yield(@token.join('')) if @token.size > 0
		@token.clear
		next
	      end
	      @token << c
	    end
	  end
	  raise EOF 
	end


	def parse(_is=$stdin)
	  @is = _is
	  @num_of_terminal = 0
	  @stack.clear
	  begin 
	    each_token do |_token|
	      trace _token
	      if _token == CLOSED_PARENTHESIS
		_parent = reduce
		if @stack.size == 0 
		  _top = NoneTerminal.top 
		  _top.add(_parent)
		  _top.head = _parent
		  return _parent 
		end
		if _parent 
		  if _parent.none_terminal? 
		    next if _parent.num_of_children == 0
		  end
		  @stack.unshift(_parent) 
		end
		next
	      end
	      shift(_token)
	    end
	  rescue EOF
	    return nil 
	  rescue Exception
	    raise
	  end
	end

	def shift(_token)
	  if _token == OPENED_PARENTHESIS
	    @stack.unshift(_token)
	    return 
	  end

	  begin
	    if @stack[0].kind_of?(Terminal)
	      raise UndefinedTag
	    end
	    _phrasal_category, _function = _token.split(/[-=]/)
	    if /^(\D+)\d+$/ =~ _phrasal_category
	      _phrasal_category = $1
	    end
	    if /^(\S+?)\|/ =~ _phrasal_category
	      _phrasal_category = $1
	    end
	    n = NoneTerminal.new(PhrasalCategory.s_to_instance(_phrasal_category))
	    n.parent = NoneTerminal.root
	    @stack.unshift(n) 

	    # Function.new(_function) if _function
	  rescue UndefinedTag
	    begin 
	      
	      _pos = PartOfSpeech.s_to_instance(_token)
	      unless @stack[0].kind_of?(Terminal)
		_terminal =  Terminal.new(_pos)
		# puts _terminal
		@stack.unshift(_terminal)
		return 
	      end
	      raise UndefinedTag

	    rescue UndefinedTag
	      
	      unless @stack[0].kind_of?(Terminal)
		raise Fail 
	      end

	      if ignore?(@stack[0].part_of_speech)
		@stack.shift
		return 
	      end
	      @stack[0].word = _token
	      @stack[0].offset = @num_of_terminal
	      @num_of_terminal += 1 
	    rescue Exception
	      raise
	    end
	  rescue Exception
	    raise 
	  end
	end

	def reduce

	  _children = []
	  while _token = @stack.shift
	    if _token == CLOSED_PARENTHESIS
	      raise 
	    end
	    if _token == OPENED_PARENTHESIS
	      if _children.size == 0 
		return nil 
		raise CannotReduce 
	      end
	      
	      _parent = _children.shift

	      if _parent.kind_of?(NoneTerminal)
		_children.each do |_child|
		  _parent.add(_child)
		end
		return _parent
	      end
	      if _parent.kind_of?(Terminal)
		raise if _children.size > 1
		return  _parent
	      end
	      raise 
	    end
	    
	    _children.unshift(_token)
	  end
	end


      end
    end
  end
end

if __FILE__ == $0
  sp = NaturalLanguage::Corpus::PennTreebank::SformParser.new
  while _tree = sp.parse
    #_tree.post_order do |_node|
      #puts _node.to_s
    #end
    _tree.show
  end

end
