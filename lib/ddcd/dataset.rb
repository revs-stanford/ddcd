require 'hashie'
require 'andand'
module DDCD
  class Dataset
    attr_reader :title, :slug, :categories, :description, :source,
      :fields, :visualizations, :tags, :supplements, :url
    attr_accessor :categories
    def initialize(obj)
      h = Hashie::Mash.new obj
      @title = h.title
      @slug = h.slug
      @categories = {}
      @tags = h.tags
      @description = h.description
      @source = h.source
      @fields = h.data_fields
      @visualizations = init_vizzes( h.visualizations )
      @supplements = h.supplements || []
      @url = obj.url
    end


    def name # alias
      @title
    end

    def source_name
      source.name.to_s if source
    end

    def source_url
      source.url.to_s if source
    end

    def source_name_and_author
      [source.author, source.name].compact.join(', ')
    end


    def deck
      "TK DECK"
    end


    ## category stuff
    def data_size
      categories['Data Size'].andand.first
    end

    def jurisdiction
      categories['Jurisdiction'].andand.first
    end

    def topical_categories
      categories['Topical']
    end

    def primary_topic
      topical_categories.andand.first
    end

    ############# visualization stuff
    def visualizations?
      !visualizations.empty?
    end

    def supplements?
      !supplements.empty?
    end

    private
        def init_vizzes(viz_arr)
          Array(viz_arr).map do |v|

            DDCD::Visualization.new v.merge(dataset: self)
          end
        end
    ### end privates
  end
end
