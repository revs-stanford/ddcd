require 'hashie'
require 'pry'
module DDCD
  class Categorizer
    attr_reader :categories
    def initialize(cat_hash)
      @categories = Hashie::Mash.new cat_hash
      @indexed_items = {}
    end

    # given an array of tags, ['Huge', 'Safety', 'U.S.']
    # return a Hash:
    #   "Data Size" => "Huge"
    #   "Topical" => "Safety"
    #   "Jurisdiction" => "U.S."
    def organize_tags(tags)
      tags.inject(Hash.new{|x,y| x[y] = [] }) do |h, tag|
        @categories.each_pair do |cat_group, cats|
          h[cat_group] << tag if cats.include?(tag)
        end

        h
      end
    end

    # TODO: this is a big hack
    def index_tagged_items(collection)
      @indexed_items = tags.inject(Hash.new{|x,y| x[y] = []}) do |h, cat_name|
        h[cat_name].concat collection.select{|i| i.tags.include?(cat_name)}
        h
      end
    end

    def items_tagged_as(tag)
      @indexed_items[tag]
    end

    def tags
      @categories.values.flatten
    end

  end
end
