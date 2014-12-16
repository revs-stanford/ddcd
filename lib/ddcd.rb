module DDCD
  def self.slugify(str)
    str.downcase.gsub(/'/, '').gsub(/[^a-z0-9]+/, '-') do |slug|
      slug.chop! if slug.last == '-'
    end
  end
end

require'lib/ddcd/categorizer.rb'
require'lib/ddcd/dataset.rb'
require'lib/ddcd/visualization.rb'
