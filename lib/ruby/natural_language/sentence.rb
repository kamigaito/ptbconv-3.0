require 'natural_language/common'
require 'natural_language/pos'

class NaturalLanguage 
  class Sentence < Array

    def initialize(*arg)
      super(arg)
    end

    def to_s
      self.join(" ")
    end

  end
end

