require 'hashie'
require 'andand'
module DDCD
  class Visualization
    attr_reader :title, :slug, :dataset, :source, :description
    def initialize(obj)
      h = Hashie::Mash.new obj
      @title = h.title
      @slug = h.slug
      @dataset = h.dataset
      @image_url = h.image_url
      @source = h.source
      @description = h.description

      @_content_url = h.content_url
      @_image_url = h.image_url
    end

    alias_method :name, :title

    def url
      external? ? source.url : "/visualizations/#{slug}"
    end

    def content_url
      @_content_url || "/visualizations/content/#{slug}.html"
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

    def native?
      !external?
    end

    def image_url
      u = URI.parse(@_image_url)
      if u.absolute?
        image_url
      else
        Pathname.new( "/visualizations/images/").join( u.to_s)
      end
    end

  end
end
