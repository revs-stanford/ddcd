require 'hashie'
require 'andand'
module DDCD
  class Dataset
    attr_reader :title, :slug, :categories, :descriptions, :source
    def initialize(obj)
      h = Hashie::Mash.new obj
      @title = h.title
      @slug = h.slug
      @categories = h.categories
      @descriptions = h.descriptions || {}
      @source = h.source
    end

    def url
      "/datasets/#{slug}"
    end

    def source_name
      source.name.to_s
    end

    def source_url
      source.url.to_s
    end


    ### description stuff
    def deck
      descriptions.values[0] || "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta ad, incidunt numquam voluptas, nesciunt dolorum illum, aperiam molestias consequuntur qui amet! Laboriosam facilis perspiciatis suscipit fugiat consequatur est, ex, animi?"
    end



    ## category stuff
    def data_size
      categories[:size].andand.first
    end

    def jurisdiction
      categories.geography.andand.first
    end

    def topical_categories
      categories.topical
    end

    def primary_topic
      topical_categories.andand.first
    end





  end


  def Dataset(object)
    Dataset.new(object)
  end
end