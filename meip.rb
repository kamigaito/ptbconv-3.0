class NaturalLanguage 
  class Corpus
    class PennTreebank
      class PhrasalCategory
	class VP < PhrasalCategory
 	  PRIORITY_LIST = [
 	    /^#{PartOfSpeech::AUX::TAG}$/,
 	    /^#{PartOfSpeech::AUXG::TAG}$/,
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
      end
    end
  end
end
