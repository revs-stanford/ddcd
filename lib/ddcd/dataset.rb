require 'hashie'

module DDCD
  class Dataset
    attr_reader :title
    def initialize(obj)
      h = Hashie::Mash.new obj

      @title = h.title
    end
  end


  def Dataset(object)
    Dataset.new(object)
  end
end
