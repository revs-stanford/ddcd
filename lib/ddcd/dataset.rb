require 'hashie'
require 'andand'
module DDCD
  class Dataset
    attr_reader :title, :slug, :categories, :descriptions, :source,
      :fields, :visualizations, :tags, :supplements
    attr_accessor :categories
    def initialize(obj)
      h = Hashie::Mash.new obj
      @title = h.title
      @slug = h.slug
      @categories = {}
      @tags = h.tags
      @descriptions = h.descriptions || {}
      @source = h.source
      @fields = h.data_fields
      @visualizations = init_vizzes( h.visualizations )
      @supplements = h.supplements || []
    end

    def url
      "/datasets/#{slug}"
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


    ### description stuff
    def deck
      descriptions.values[0] || "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta ad, incidunt numquam voluptas, nesciunt dolorum illum, aperiam molestias consequuntur qui amet! Laboriosam facilis perspiciatis suscipit fugiat consequatur est, ex, animi?"
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
