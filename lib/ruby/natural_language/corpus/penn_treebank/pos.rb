require 'natural_language/pos'
require 'natural_language/corpus/penn_treebank/common'

class NaturalLanguage 
  class Corpus
    class PennTreebank
      class PartOfSpeech < NaturalLanguage::PartOfSpeech
	class Noun < PartOfSpeech
	  EXPLANATION = 'Noun'
	  TAG = nil
	  REGEXP = /^NN(S|P|PS)?$/
	end

	class NN < Noun
	  EXPLANATION = "#{Noun::EXPLANATION}, common singular or mass"
	  TAG = 'NN'
	end
	class NNS < Noun
	  EXPLANATION = "#{Noun::EXPLANATION}, common plural"
	  TAG = 'NNS'
	end
	class NNP < Noun
	  EXPLANATION = "#{Noun::EXPLANATION}, proper, singular"
	  TAG = 'NNP'
	end
	class NNPS < Noun
	  EXPLANATION = "#{Noun::EXPLANATION}, proper, plural"
	  TAG = 'NNPS'
	end

	class Verb < PartOfSpeech
	  EXPLANATION = 'Verb'
	  TAG = nil
	  REGEXP = /^VB[DGNPZ]?$/
	end

	class VB < Verb
	  EXPLANATION = "#{Verb::EXPLANATION}, base form"
	  TAG = 'VB'
	end

	class VBD < Verb
	  EXPLANATION = "#{Verb::EXPLANATION}, past tense"
	  TAG = 'VBD'
	end
	class VBG < Verb
	  EXPLANATION = "#{Verb::EXPLANATION}, present participle or gerund"
	  TAG = 'VBG'
	end
	class VBN < Verb
	  EXPLANATION = "#{Verb::EXPLANATION}, past participle"
	  TAG = 'VBN'
	end
	class VBP < Verb
	  EXPLANATION = "#{Verb::EXPLANATION}, present tense, not 3rd person singluar"
	  TAG = 'VBP'
	end
	class VBZ < Verb
	  EXPLANATION = "#{Verb::EXPLANATION}, present tense, 3rd preson singluar"
	  TAG = 'VBZ'
	end

	class Adjective < PartOfSpeech
	  EXPLANATION = 'Adjective'
	  TAG = nil
	  REGEXP = /^JJ[RS]?$/
	end

	class JJ < Adjective 
	  EXPLANATION = "#{Adjective::EXPLANATION}, or numeral ordinal"
	  TAG = 'JJ'
	end

	class JJR < Adjective
	  EXPLANATION = "#{Adjective::EXPLANATION}, comparative"
	  TAG = 'JJR'
	end

	class JJS < Adjective
	  EXPLANATION = "#{Adjective::EXPLANATION}, superlative"
	  TAG = 'JJS'
	end

	class Adverb < PartOfSpeech
	  EXPLANATION = 'Adverb'
	  TAG = nil
	  REGEXP = /^RB[RS]?$/
	end

	class RB < Adverb
	  EXPLANATION = "#{Adverb::EXPLANATION}"
	  TAG = 'RB'
	end

	class RBR < Adverb
	  EXPLANATION = "#{Adverb::EXPLANATION}, comparative"
	  TAG = 'RBR'
	end

	class RBS < Adverb
	  EXPLANATION = "#{Adverb::EXPLANATION}, superlative"
	  TAG = 'RBS'
	end
	
	class ModalAuxiliary < PartOfSpeech
	  EXPLANATION = 'Modal Auxiliary'
	  TAG = nil
	  REGEXP = /^MD$/
	end

	class MD < ModalAuxiliary
	  TAG = 'MD'
	end

	class AUX < PartOfSpeech
	  EXPLANATION = 'Auxiliary'
	  TAG = 'AUX'
	  REGEXP = /^AUX$/
	end

	class AUXG < PartOfSpeech
	  EXPLANATION = 'Auxiliary'
	  TAG = 'AUXG'
	  REGEXP = /^AUXG$/
	end

	class Pronoun < PartOfSpeech
	  EXPLANATION = 'Pronoun'
	  TAG = nil
	  REGEXP = /^PRP\$?$/
	end

	class PRP < Pronoun
	  EXPLANATION = "#{Pronoun::EXPLANATION}, personal"
	  TAG = 'PRP'
	end

	class PRP_DOLLAR < Pronoun
	  EXPLANATION = "#{Pronoun::EXPLANATION}, possessive"
	  TAG = 'PRP$'
	  REGEXP = /^PRP\$$/
	end
	
	class Wh < PartOfSpeech
	  EXPLANATION = 'Wh-'
	  TAG = nil 
	  REGEXP = /^(WDT|WP|WP\$|WRB)$/
	end

	class WDT < Wh
	  EXPLANATION = "#{Wh::EXPLANATION}determiner"
	  TAG = 'WDT'
	end
	class WP < Wh
	  EXPLANATION = "#{Wh::EXPLANATION}pronoun"
	  TAG = 'WP'
	end

	class WP_DOLLAR < Wh
	  EXPLANATION = "#{Wh::EXPLANATION}pronoun, possessive"
	  TAG = 'WP$'
	  REGEXP = /^WP\$$/
	end

	class WRB < Wh
	  EXPLANATION = "#{Wh::EXPLANATION}adverb"
	  TAG = 'WRB'
	end

	class CC < PartOfSpeech
	  EXPLANATION = "Conjunction or corrdination"
	  TAG = 'CC'
	  REGEXP = /^CC$/
	end

	class Preposition < PartOfSpeech
	  EXPLANATION = "Preposition"
	  TAG = nil
	  REGEXP = /^(IN|TO)$/
	end

	class IN < Preposition
	  EXPLANATION = "#{Preposition::EXPLANATION} or conjunction subordinating"
	  TAG = 'IN'
	end

	class TO < Preposition
	  EXPLANATION = 'To as preposition or infinitive marker'
	  TAG = 'TO'
	end

	class EX < PartOfSpeech
	  EXPLANATION = 'Existential there' 
	  TAG = 'EX'
	  REGEXP = /^EX$/
	end

	class FW < PartOfSpeech
	  EXPLANATION = 'Foreign word' 
	  TAG = 'FW'
	  REGEXP = /^FW$/
	end

	class DT < PartOfSpeech
	  EXPLANATION = 'Determiner' 
	  TAG = 'DT'
	  REGEXP = /^DT$/
	end

	class PDT < PartOfSpeech
	  EXPLANATION = 'Pre-determiner' 
	  TAG = 'PDT'
	  REGEXP = /^PDT$/
	end

	class RP < PartOfSpeech
	  EXPLANATION = 'Particle' 
	  TAG = 'RP'
	  REGEXP = /^RP$/
	end

	class UH < PartOfSpeech
	  EXPLANATION = 'Interjection' 
	  TAG = 'UH'
	  REGEXP = /^UH$/
	end

	class CD < PartOfSpeech
	  EXPLANATION = 'Numeral cardinal' 
	  TAG = 'CD'
	  REGEXP = /^CD$/
	end

	class LS < PartOfSpeech
	  EXPLANATION = 'List item marker' 
	  TAG = 'LS'
	  REGEXP = /^LS$/
	end

	class POS < PartOfSpeech
	  EXPLANATION = 'Genitive marker' 
	  TAG = 'POS'
	  REGEXP = /^POS$/
	end
	
	class Punctuation < PartOfSpeech
	  EXPLANATION = 'Punctuation'
	  TAG = nil
	  REGEXP = /^(|\`\`|\'\'|,|\.|\:)$/
	end

	class OP < PartOfSpeech
	  EXPLANATION = 'Opening parenthesis'
	  TAG = '-LRB-'
	end

	class CP < PartOfSpeech
	  EXPLANATION = 'Closing parenthesis'
	  TAG = '-RRB-'
	end

	class OQM < Punctuation
	  EXPLANATION = 'Opening quotation mark'
	  TAG = '``'
	end

	class CQM < Punctuation 
	  EXPLANATION = 'Closing quotation mark'
	  TAG = '\'\''
	end

	class COMMA < Punctuation
	  EXPLANATION = 'Comma'
	  TAG = ','
	end

	class PERIOD < Punctuation
	  EXPLANATION = 'Sentence Termination'
	  TAG = '.'
	end

	class COLON < Punctuation
	  EXPLANATION = 'Colon or ellipsis'
	  TAG = ':'
	end
	
	class DOLLAR < PartOfSpeech
	  EXPLANATION = 'Dollar'
	  TAG = '$'
	  REGEXP = /^\$$/
	end

	class DASH < PartOfSpeech
	  EXPLANATION = 'Dash'
	  TAG = '--'
	  REGEXP = /^\-\-$/
	end

	class SHARP < PartOfSpeech
	  EXPLANATION = 'Sharp'
	  TAG = '#'
	  REGEXP = /^\#$/
	end

	class SYMBOL < PartOfSpeech
	  EXPLANATION = 'Symbol'
	  TAG = 'SYM'
	  REGEXP = /^SYM$/
	end

	class NONE < PartOfSpeech
	  EXPLANATION = 'Gap'
	  TAG = '-NONE-'
	  REGEXP = /^-NONE-$/
	end

      end
    end
  end
end

=begin
= NaturalLanguage::Corpus::PennTreebank::PartOfSpeech < NaturalLanguage::PartOfSpeech 
Part of Speech tag class of Penn. Treebank
=end

class NaturalLanguage 
  class Corpus
    class PennTreebank
      class PartOfSpeech < NaturalLanguage::PartOfSpeech
	EXPLANATION = 'Penn Treebank Part-of-Speech tag set'
	TAG = nil

	def initialize(_score=0.0) 
	  super(_score)
	  if self.class  == NaturalLanguage::Corpus::PennTreebank::PartOfSpeech 
	    raise DisableConstruction, "this class is an abstracted class, can not create an instance"
	  end
	end

=begin
*((<Instance Methods>)
  --- PennTreebank::PartOfSpeech#punctuation? 
  --- PennTreebank::PartOfSpeech#functional_word?
  --- PennTreebank::PartOfSpeech#contents_word?
=end
	def punctuation?
	  return self.kind_of?(Punctuation)
	end

	def noun?
	  self.kind_of?(Noun)
	end

	def verb?
	  self.kind_of?(Verb)
	end

	def adjective?
	  self.kind_of?(Adjective)
	end

	def adverb?
	  self.kind_of?(Adverb)
	end


	def parenthesis?
	  return self.kind_of?(OP) || self.kind_of?(CP)
	end
      end
    end
  end
end


if __FILE__ == $0

  pos = NaturalLanguage::Corpus::PennTreebank::PartOfSpeech.s_to_instance("NNP")
  p pos 
  pos = NaturalLanguage::Corpus::PennTreebank::PartOfSpeech.s_to_instance("NXP")
  p pos

  exit
  _length = 'NaturalLanguage::Corpus::PennTreebank::PartOfSpeech'.length + 7
  NaturalLanguage::Corpus::PennTreebank::PartOfSpeech.each_defined_tag do |_tag|
    puts "%#{_length}s: %s" % [_tag::TAG, _tag::EXPLANATION]
  end
  puts 
  noun = NaturalLanguage::Corpus::PennTreebank::PartOfSpeech::NN.new
  puts noun =~ 'VP'

end
