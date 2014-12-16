require 'hashie'
require 'andand'
module DDCD
  class Visualization
    attr_reader :title, :slug, :dataset, :image_url
    def initialize(obj)
      h = Hashie::Mash.new obj
      @title = h.title
      @slug = h.slug
      @dataset = h.dataset
      @image_url = h.image_url
      @source = h.source
    end

    def url
      external? ? source.url : "/visualizations/#{slug}"
    end

    def dataset_name
      dataset.name.to_s if dataset
    end

    def dataset_url
      dataset.url.to_s if dataset
    end

    def source_name
      source.name.to_s if source
    end

    def source_url
      source.url.to_s if source
    end


    def external?
      !@source.nil?
    end

    def image_url
      u = URI.parse(@image_url)
      if u.absolute?
        image_url
      else
        URI.join( "/visualizations/images/", u).to_s
      end
    end


    ### description stuff
    def deck
      "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta ad, incidunt numquam voluptas, nesciunt dolorum illum, aperiam molestias consequuntur qui amet! Laboriosam facilis perspiciatis suscipit fugiat consequatur est, ex, animi?"
    end
  end
end
