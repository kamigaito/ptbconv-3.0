require 'natural_language/corpus/penn_treebank/common'
require 'natural_language/corpus/penn_treebank/pos'
=begin
= NaturalLanguage::Corpus::PennTreebank::PhrasalCategory
== Abstract Class of Penn Treebank Phrasal Categories.  

The explanation of each tag is refered to ((<JEANETTE PETTIBONE's website|URL:http://bulba.sdsu.edu/jeanette/thesis/PennTags.html#Phrase>)).
Our head finding rules is almost similar to Collins' one. However, we don't deal with some special rules of him, such as NP and Coordination.  

=end

class NaturalLanguage 
  class Corpus
    class PennTreebank
      class PhrasalCategory

=begin
*((<Class Methods>)0
--- PhrasalCategory.new(score=0.0)
--- PhrasalCategory.s_to_instance(_str, _score=0.0)
*((<Class Constants))
--- EXPLANATION
      The explanation of the tag.
--- SEARCH_DIRECTION
      Seaching direction for finding a head child (LEFT or RIGHT). 
--- LEFT
--- RIGHT
--- PRIORITY_LIST
      The array of the prioritiy for finding a head child.
=end

	EXPLANATION = 'Penn treebank phrasal category'
	LEFT = 0
	RIGHT = 1
	SEARCH_DIRECTION = RIGHT

	attr_accessor :score

	def initialize(_score=0.0) 
	  @score = _score
	  if self.class == NaturalLanguage::Corpus::PennTreebank::PhrasalCategory
	    raise DisableConstruction, "this class is an abstracted class, can not create an instance"
	  end
	end

	def PhrasalCategory.s_to_instance(_str, _score=0.0, _pc=nil)
	  each_defined_tag do |_tag|
	    return _tag.new(_score) if _tag::TAG == _str 
	  end
	  raise UndefinedTag, "%s is not defined" % _str
	end

	def PhrasalCategory.each_defined_tag
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

	def PhrasalCategory.head_rule
	  _class = new.class
	  _pl = []
	  each_priority do |_priority|
	    _pl << _priority.source
	  end
	  d = 'L'
	  d = 'R' if _class::SEARCH_DIRECTION == _class::RIGHT
	  return "%12s  %5s      %s" % [_class::TAG, d, _pl.join(', ')]
	end


=begin
*((<Instance Methods>))
--- PhrasalCategory#each_priority
--- PhrasalCategory#get_search_index_and_step_width(children)
      
--- PhrasalCategory#find_head_index(children)
      return the index of head child in the children.
=end



	def == (_arg)
	  return nil unless _arg.kind_of?(String) || _arg.kind_of?(PhrasalCategory)
	  self.to_s == _arg.to_s 
	end

	def === (_arg)
	  self.class == _arg.class
	end

	def PhrasalCategory.each_priority
	  new.class::PRIORITY_LIST.each do |_priority|
	    yield(_priority)
	  end
	end

	def each_priority
	  self.class::PRIORITY_LIST.each do |_priority|
	    yield(_priority)
	  end
	end

	def head_final?
	  self.class::SEARCH_DIRECTION == PhrasalCategory::RIGHT
	end

	def get_search_range_and_step_width(_children)
	  s = 0 
	  e = _children.size - 1
	  w = 1
	  
	  if self.class::SEARCH_DIRECTION == PhrasalCategory::RIGHT
	    s = _children.size - 1
	    e = 0
	    w = -1
	  end
	  return s, e, w
	end

	def find_head_index(_children)
	  s, e, w = get_search_range_and_step_width(_children)

	  each_priority do |_priority|
	    i = s 

	    while i != (e + w)
	      if _children[i].terminal?
		if _children[i].part_of_speech.punctuation?
		  i += w ; next
		end
	      end

	      _ch = _children[i].unlexicalize
	      return i if _priority =~ _ch 
	      i += w
	    end
	  end
	  return s if _children[s].none_terminal? 
	  _pos = _children[s].part_of_speech
	  i = s
	  while  (i != (e + w))

	    return i if _children[i].none_terminal?
	    _pos = _children[i].part_of_speech

	    return i unless (_pos.parenthesis? || _pos.punctuation?)
	    i += w
	  end
	  return s
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
      class PhrasalCategory

	class S < PhrasalCategory
	  EXPLANATION = 'Simple declarartive clause'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class SBAR < PhrasalCategory
	  EXPLANATION = 'Clause introduced by a (possibly empty) subordinating conjunction.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	  
	end

	class SBARQ < PhrasalCategory
	  EXPLANATION = 'Direct question introduced by a wh-word or a wh-phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class SQ < PhrasalCategory
	  EXPLANATION = 'Inverted yes/no question, or main clause of a wh-question.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class SINV < PhrasalCategory
	  EXPLANATION = 'Inverted declarative sentence,'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class ADJP < PhrasalCategory
	  EXPLANATION = 'Adjective Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class ADVP < PhrasalCategory
	  EXPLANATION = 'Adverbal Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class NP < PhrasalCategory
	  EXPLANATION = 'Noun Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class PP < PhrasalCategory
	  EXPLANATION = 'Prepositional Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class QP < PhrasalCategory
	  EXPLANATION = 'Quantifier Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class VP < PhrasalCategory
	  EXPLANATION = 'Verb Phrase'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class WHNP < PhrasalCategory
	  EXPLANATION = 'Wh-noun Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class WHPP < PhrasalCategory
	  EXPLANATION = 'Wh-prepositional Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class CONJP < PhrasalCategory
	  EXPLANATION = 'Conjunction Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class FRAG < PhrasalCategory
	  EXPLANATION = 'Fragment.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end


	class INTJ < PhrasalCategory
	  EXPLANATION = 'Interjection.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class LST < PhrasalCategory
	  EXPLANATION = 'List Marker'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class NAC < PhrasalCategory
	  EXPLANATION = 'Not A Constituent'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class NX < PhrasalCategory
	  EXPLANATION = 'Used within certain complex NPs to mark the head of the NP.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class PRN < PhrasalCategory
	  EXPLANATION = 'Parenthetical'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class PRT < PhrasalCategory
	  EXPLANATION = 'Particle.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class RRC < PhrasalCategory
	  EXPLANATION = 'Reduced Relative Clause.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class UCP < PhrasalCategory
	  EXPLANATION = 'Unlike Coordinated Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class X < PhrasalCategory
	  EXPLANATION = 'Unknown, uncertain, or unbracketable.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class WHADJP < PhrasalCategory
	  EXPLANATION = 'Wh-adjective Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::RIGHT
	  TAG = new.class.to_s.split('::').pop
	end

	class WHADVP < PhrasalCategory
	  EXPLANATION = 'Wh-adverb Phrase.'
	  SEARCH_DIRECTION = PhrasalCategory::LEFT
	  TAG = new.class.to_s.split('::').pop
	end

	class S < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::TO::TAG}$/,
	    /^#{PartOfSpeech::IN::TAG}$/,
	    /^#{PhrasalCategory::VP::TAG}$/,
	    /^#{PhrasalCategory::S::TAG}$/,
	    /^#{PhrasalCategory::SBAR::TAG}$/,
	    /^#{PhrasalCategory::ADJP::TAG}$/,
	    /^#{PhrasalCategory::UCP::TAG}$/,
	    /^#{PhrasalCategory::NP::TAG}$/
	  ]
	end

	class SBAR < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PhrasalCategory::WHNP::TAG}$/,
	    /^#{PhrasalCategory::WHPP::TAG}$/,
	    /^#{PhrasalCategory::WHADVP::TAG}$/,
	    /^#{PhrasalCategory::WHADJP::TAG}$/,
	    /^#{PartOfSpeech::IN::TAG}$/,
	    /^#{PartOfSpeech::DT::TAG}$/,
	    /^#{PhrasalCategory::S::TAG}$/,
	    /^#{PhrasalCategory::SQ::TAG}$/,
	    /^#{PhrasalCategory::SINV::TAG}$/,
	    /^#{PhrasalCategory::SBAR::TAG}$/,
	    /^#{PhrasalCategory::FRAG::TAG}$/
	  ]
	end

	class SBARQ < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PhrasalCategory::SQ::TAG}$/,
	    /^#{PhrasalCategory::S::TAG}$/,
	    /^#{PhrasalCategory::SINV::TAG}$/,
	    /^#{PhrasalCategory::SBARQ::TAG}$/,
	    /^#{PhrasalCategory::FRAG::TAG}$/
	  ]
	end

	class SQ < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::VBZ::TAG}$/,
	    /^#{PartOfSpeech::VBD::TAG}$/,
	    /^#{PartOfSpeech::VBP::TAG}$/,
	    /^#{PartOfSpeech::VB::TAG}$/,
	    /^#{PartOfSpeech::MD::TAG}$/,
	    /^#{PhrasalCategory::VP::TAG}$/,
	    /^#{PhrasalCategory::SQ::TAG}$/
	  ]
	end

	class SINV < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::VBZ::TAG}$/,
	    /^#{PartOfSpeech::VBD::TAG}$/,
	    /^#{PartOfSpeech::VBP::TAG}$/,
	    /^#{PartOfSpeech::VB::TAG}$/,
	    /^#{PartOfSpeech::MD::TAG}$/,
	    /^#{PhrasalCategory::VP::TAG}$/,
	    /^#{PhrasalCategory::S::TAG}$/,
	    /^#{PhrasalCategory::SINV::TAG}$/,
	    /^#{PhrasalCategory::ADJP::TAG}$/,
	    /^#{PhrasalCategory::NP::TAG}$/
	  ]
	end

	class ADJP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::NNS::TAG}$/,
	    /^#{PhrasalCategory::QP::TAG}$/,
	    /^#{PartOfSpeech::NN::TAG}$/,
	    PartOfSpeech::DOLLAR::REGEXP,
	    /^#{PhrasalCategory::ADVP::TAG}$/,
	    /^#{PartOfSpeech::JJ::TAG}$/,
	    /^#{PartOfSpeech::VBN::TAG}$/,
	    /^#{PartOfSpeech::VBG::TAG}$/,
	    /^#{PhrasalCategory::ADJP::TAG}$/,
	    /^#{PartOfSpeech::JJR::TAG}$/,
	    /^#{PhrasalCategory::NP::TAG}$/,
	    /^#{PartOfSpeech::JJS::TAG}$/,
	    /^#{PartOfSpeech::DT::TAG}$/,
	    /^#{PartOfSpeech::FW::TAG}$/,
	    /^#{PartOfSpeech::RBR::TAG}$/,
	    /^#{PartOfSpeech::RBS::TAG}$/,
	    /^#{PhrasalCategory::SBAR::TAG}$/,
	    /^#{PartOfSpeech::RB::TAG}$/
	  ]
	end


	class ADVP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::RB::TAG}$/,
	    /^#{PartOfSpeech::RBR::TAG}$/,
	    /^#{PartOfSpeech::RBS::TAG}$/,
	    /^#{PartOfSpeech::FW::TAG}$/,
	    /^#{PhrasalCategory::ADVP::TAG}$/,
	    /^#{PartOfSpeech::TO::TAG}$/,
	    /^#{PartOfSpeech::CD::TAG}$/,
	    /^#{PartOfSpeech::JJR::TAG}$/,
	    /^#{PartOfSpeech::JJ::TAG}$/,
	    /^#{PartOfSpeech::IN::TAG}$/,
	    /^#{PhrasalCategory::NP::TAG}$/,
	    /^#{PartOfSpeech::JJS::TAG}$/,
	    /^#{PartOfSpeech::NN::TAG}$/
	  ]
	end

	class NP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^(#{PartOfSpeech::POS::TAG}|#{PartOfSpeech::NN::TAG}|#{PartOfSpeech::NNP::TAG}|#{PartOfSpeech::NNPS::TAG}|#{PartOfSpeech::NNS::TAG})$/,
	    /^#{PhrasalCategory::NX::TAG}$/,
	    /^#{PartOfSpeech::JJR::TAG}$/,
	    /^#{PartOfSpeech::CD::TAG}$/,
	    /^#{PartOfSpeech::JJ::TAG}$/,
	    /^#{PartOfSpeech::JJS::TAG}$/,
	    /^#{PartOfSpeech::RB::TAG}$/,
	    /^#{PhrasalCategory::QP::TAG}$/,
	    /^#{PhrasalCategory::NP::TAG}$/
	  ]
	end

	class PP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::IN::TAG}$/,
	    /^#{PartOfSpeech::TO::TAG}$/,
	    /^#{PartOfSpeech::VBG::TAG}$/,
	    /^#{PartOfSpeech::VBN::TAG}$/,
	    /^#{PartOfSpeech::RP::TAG}$/,
	    /^#{PartOfSpeech::FW::TAG}$/
	  ]
	end

	class QP < PhrasalCategory
	  PRIORITY_LIST = [
	   PartOfSpeech::DOLLAR::REGEXP,
	   /^#{PartOfSpeech::IN::TAG}$/,
	   /^#{PartOfSpeech::NNS::TAG}$/,
	   /^#{PartOfSpeech::NN::TAG}$/,
	   /^#{PartOfSpeech::JJ::TAG}$/,
	   /^#{PartOfSpeech::RB::TAG}$/,
	   /^#{PartOfSpeech::DT::TAG}$/,
	   /^#{PartOfSpeech::CD::TAG}$/,
	   /^#{PhrasalCategory::QP::TAG}$/,
	   /^#{PartOfSpeech::JJR::TAG}$/,
	   /^#{PartOfSpeech::JJS::TAG}$/
	  ]

	end
	
	class VP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::VBD::TAG}$/,
	    /^#{PartOfSpeech::VBN::TAG}$/,
	    /^#{PartOfSpeech::MD::TAG}$/,
	    /^#{PartOfSpeech::VBZ::TAG}$/,
	    /^#{PartOfSpeech::VB::TAG}$/,
	    /^#{PartOfSpeech::VBG::TAG}$/,
	    /^#{PartOfSpeech::VBP::TAG}$/,
	    /^#{PhrasalCategory::VP::TAG}$/,
	    /^#{PhrasalCategory::ADJP::TAG}$/,
	    /^#{PartOfSpeech::NN::TAG}$/,
	    /^#{PartOfSpeech::NNS::TAG}$/,
	    /^#{PhrasalCategory::NP::TAG}$/
	  ]
	end

	class WHNP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::WDT::TAG}$/,
	    /^#{PartOfSpeech::WP::TAG}$/,
	    PartOfSpeech::WP_DOLLAR::REGEXP,
	    /^#{PhrasalCategory::WHADJP::TAG}$/,
	    /^#{PhrasalCategory::WHPP::TAG}$/,
	    /^#{PhrasalCategory::WHNP::TAG}$/
	  ]
	end

	class WHPP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::IN::TAG}$/,
	    /^#{PartOfSpeech::TO::TAG}$/,
	    /^#{PartOfSpeech::FW::TAG}$/
	  ]
	end

	class CONJP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::CC::TAG}$/,
	    /^#{PartOfSpeech::RB::TAG}$/,
	    /^#{PartOfSpeech::IN::TAG}$/
	  ]
	end

	class FRAG < PhrasalCategory
	  PRIORITY_LIST = []
	end

	class INTJ < PhrasalCategory
	  PRIORITY_LIST = []
	end

	class LST < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::LS::TAG}$/,
	    /^#{PartOfSpeech::COLON::TAG}$/
	  ]
	end

	class NAC < PhrasalCategory	
	  PRIORITY_LIST = [
	    /^(#{PartOfSpeech::NN::TAG}|#{PartOfSpeech::NNP::TAG}|#{PartOfSpeech::NNPS::TAG}|#{PartOfSpeech::NNS::TAG})$/,
	    /^#{PhrasalCategory::NP::TAG}$/,
	    /^#{PhrasalCategory::NAC::TAG}$/,
	    /^#{PartOfSpeech::EX::TAG}$/,
	    PartOfSpeech::DOLLAR::REGEXP,
	    /^#{PartOfSpeech::CD::TAG}$/,
	    /^#{PhrasalCategory::QP::TAG}$/,
	    /^#{PartOfSpeech::PRP::TAG}$/,
	    /^#{PartOfSpeech::VBG::TAG}$/,
	    /^#{PartOfSpeech::JJ::TAG}$/,
	    /^#{PartOfSpeech::JJS::TAG}$/,
	    /^#{PartOfSpeech::JJR::TAG}$/,
	    /^#{PhrasalCategory::ADJP::TAG}$/,
	    /^#{PartOfSpeech::FW::TAG}$/
	  ]
	end

	class NX < PhrasalCategory
	  PRIORITY_LIST = PhrasalCategory::NP::PRIORITY_LIST
	end

	class PRN < PhrasalCategory
	  PRIORITY_LIST = []
	end

	class PRT < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::RP::TAG}$/
	  ]
	end

	class RRC < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PhrasalCategory::VP::TAG}$/,
	    /^#{PhrasalCategory::NP::TAG}$/,
	    /^#{PhrasalCategory::ADVP::TAG}$/,
	    /^#{PhrasalCategory::ADJP::TAG}$/,
	    /^#{PhrasalCategory::PP::TAG}$/
	  ]
	end

	class UCP < PhrasalCategory
	  PRIORITY_LIST = []
	end

	class X < PhrasalCategory
	  PRIORITY_LIST = []
	end

	class WHADJP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::CC::TAG}$/,
	    /^#{PartOfSpeech::WRB::TAG}$/,
	    /^#{PartOfSpeech::JJ::TAG}$/,
	    /^#{PhrasalCategory::ADJP::TAG}$/
	  ]
	end

	class WHADVP < PhrasalCategory
	  PRIORITY_LIST = [
	    /^#{PartOfSpeech::CC::TAG}$/,
	    /^#{PartOfSpeech::WRB::TAG}$/
	  ]
	end


      end
    end
  end
end

if __FILE__ == $0
  #pc = NaturalLanguage::Corpus::PennTreebank::PhrasalCategory.s_to_instance("NP")
  # puts pc 
  NaturalLanguage::Corpus::PennTreebank::PhrasalCategory.each_defined_tag do |_tag|
    puts _tag.head_rule
  end

end
