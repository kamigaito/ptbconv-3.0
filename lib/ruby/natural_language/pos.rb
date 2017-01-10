require 'natural_language/common'

=begin
= NaturalLanguage::PartOfSpeech 
Abstract Class of Part of Speech
=end

class NaturalLanguage 
  class PartOfSpeech

=begin
*((<Class Methods>))
  --- PartOfSpeech.new(string, score=0.0)
        constructing an instance. 
  --- PartOfSpeech.s_to_instance(string, score)
        converting string into an instance of PartOfSpeech class.
*((<Class Constants>))
  --- TAG
        the tag string of the part of speech
  --- EXPLANATION
        the detail of the tag
  
=end
    TAG = nil
    EXPLANATION = 'Part of Speech class'

    class BOS < PartOfSpeech
      TAG = 'BOS'
      EXPLANATION = 'The beginning of the sentence'
    end
    
    class EOS < BOS
      TAG = 'EOS'
      EXPLANATION = 'The end of the sentence'
    end

    class UNK < PartOfSpeech
      TAG = 'UNK'
      EXPLANATION = 'Unknown tag'
    end

    class TOP < PartOfSpeech
      TAG = 'TOP'
      EXPLANATION = 'Special symbol for the top node of parse trees'
    end

    attr_accessor :score

    def initialize(_score=0.0) 
      @score = _score
      if self.class  == NaturalLanguage::PartOfSpeech 
	raise DisableConstruction, "this class is an abstracted class, can not create an instance"
      end
    end

    def PartOfSpeech.s_to_instance(_str, _score=0.0, _pos=nil)
      each_defined_tag do |_tag|
	return _tag.new(_score) if _tag::TAG == _str 
      end
      raise UndefinedTag, "%s is not defined" % _str
    end

=begin
* Instance Method
  --- PartOfSpeechd#bos?
  --- PartOfSpeechd#eos?
  --- PartOfSpeechd#unknown?
=end

    def bos?
      return self.kind_of?(BOS)
    end

    def eos?
      return self.kind_of?(EOS)
    end

    def top?
      return self.kind_of?(TOP)
    end

    def unknown?
      return self.kind_of?(UNK)
    end

=begin
  --- PartOfSpeechd#==(pos) 
        return true if the tag string of pos is same string.
  --- PartOfSpeechd#===(pos) 
        return true if pos maches exactly.
  --- PartOfSpeechd#=~(pos) 
        return true if pos is same word class to self's one. 
  --- PartOfSpeechd#to_s
        return the tag string
=end

    def == (arg)

      if self.class::TAG == nil 
	return self.class == arg.class 
      end

      if arg.kind_of?(String)
	return self.class::TAG == arg.to_s 
      end
      return nil unless arg.kind_of?(PartOfSpeech)

      return self.class::TAG == arg.to_s 
    end

    def === (arg)
      self.class == arg.class
    end

    def =~ (arg)
      return self.class::REGEXP =~ arg if arg.kind_of?(String)
      return arg.kind_of?(self.class) unless TAG 
      return arg.kind_of?(self.class.superclass)
    end

    def to_s
      self.class::TAG
    end

    def PartOfSpeech.each_defined_tag
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
  end
end

=begin
* ((<Related Class>))
  * ((<NaturalLanguage::Corpus::WallStreetJournal::PartOfSpeech>))
=end 

if __FILE__ == $0
  NaturalLanguage::PartOfSpeech.each_defined_tag do |_tag|
    puts "%s:%s" % [_tag, _tag::EXPLANATION]
  end
  
end


