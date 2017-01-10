require 'natural_language/corpus/penn_treebank/common'
=begin
= NaturalLanguage::Corpus::PennTreebank::Function
Function of Penn. Treebank 
=end

class NaturalLanguage 
  class Corpus
    class PennTreebank
      class Function
	def initialize()
	  if self.class == NaturalLanguage::Corpus::PennTreebank::Function
	    raise DisableConstruction, "this class is an abstracted class, can not create an instance"
	  end
	end

	def Function.s_to_instance(_str, _score=0.0, _pc=nil)
	  each_defined_tag do |_tag|
	    return _tag.new(_score) if _tag::TAG == _str 
	  end
	  raise UndefinedTag, "%s is not defined" % _str
	end

	def Function.each_defined_tag
	  constants.each do |_const|
	    v = const_get(_const)
	    next unless v.kind_of?(Class)
	    begin
	      v.const_get("TAG")
	      yield(v) if v::TAG 
	    rescue NameError
	    rescue Exception
	      raise 
	    end
	  end
	end

	def to_s
	  self.class::TAG
	end

      end
    end
  end
end

class NaturalLanguage
  class Corpus
    class PennTreebank
      class Function
	class FormFunctionDescription < Function
	  EXPLANATION = ''
	  TAG = nil
	end
	class ADV < FormFunctionDescription
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class NOM < FormFunctionDescription
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end


	class GrammaticalRole < Function
	  EXPLANATION = ''
	  TAG = nil 
	end
	class DTV < GrammaticalRole
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class LGS < GrammaticalRole
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class PRD < GrammaticalRole
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class PUT < GrammaticalRole
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class SBJ < GrammaticalRole
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class TPC < GrammaticalRole
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	
	class Adverbial < Function
	  EXPLANATION = ''
	  TAG = nil
	end
	class BNF < Adverbial
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class DIR < Adverbial
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class EXT < Adverbial
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class LOC < Adverbial
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class MNR < Adverbial
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class PRP < Adverbial
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class TMP < Adverbial
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end

	class Miscellaneous < Function
	  EXPLANATION = ''
	  TAG =nil
	end
	class CLR < Miscellaneous
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class CLF < Miscellaneous
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class HLN < Miscellaneous
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end
	class TTL < Miscellaneous
	  EXPLANATION = ''
	  TAG = new.class.to_s.split('::').pop
	end


      end
    end
  end
end

if __FILE__ == $0
end

__END__

