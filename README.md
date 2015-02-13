
This is the repo for REVS data

This site is built with the [Middleman static site generator](//middlemanapp.com).

## Developer/installation instructions

1. Clone the repo to your computer:

            git clone https://github.com/revs-stanford/ddcd
            # change into the directory
            cd ddcd  

2. Install the necessary Ruby gem dependencies:
          
           bundle install

3. Start the local webserver:

           middleman server

4. Visit the site in a browser at __127.0.0.1:4567__

---------

Notes about drafting the site:

## Site structure

### Front/landing page

#### Nav bar
+ /datasets
+ /visualizations
+ /news
+ /about (i.e contact info)

#### Banner
Short blurb about the database with a prominent __search bar__ that allows users to quickly nav to a dataset (e.g. "NHTSA Complaints") or to a subcategory

#### Visualization strip
A quick nav element showing five random vizzes.


#### Category index
A listing of all subcategories




------------

### Dataset page

- Title
- Overview description
- Visualization examples, if any
- Data field descriptors, if any
- Download/access type:
  + Direct link to official site
  + Cached copy




----------------


#### Data spreadsheet

https://docs.google.com/a/stanford.edu/spreadsheets/d/18CSuy8fh9Ro0-k1UlIw5Q_Yso9O8uafrAfsJtmxKqik/edit#gid=0

https://docs.google.com/a/stanford.edu/spreadsheets/d/18CSuy8fh9Ro0-k1UlIw5Q_Yso9O8uafrAfsJtmxKqik/export?format=csv&gid=0

Using Ruby to export it to YAML

~~~ruby
require 'csv'
require 'yaml'
require 'open-uri'

url='https://docs.google.com/a/stanford.edu/spreadsheets/d/18CSuy8fh9Ro0-k1UlIw5Q_Yso9O8uafrAfsJtmxKqik/export?format=csv&gid=0'


csv = CSV.new(open(url).read, headers: true)
arr = []
csv.each do |c|
   h = Hash.new{|x,y| x[y] = {}}
   h['title'] = c['Title']
   h['slug'] = c['Slug'].gsub(/-+/, '-').sub(/^-/, '').sub(/-$/, '')
   h['source'] = {'primary' => c['Agency'], 'sub' => c['Subagency']}
   h['description'] = "#{c['Description'].gsub(/\s+/,' ')}"
   h['links'] = []

   ['Official URL', 'Official Data Portal', 'Official data direct link', 'Official documentation'].each do |u|
      h['links'] << {'name' => u, 'url' => c[u]} unless c[u].to_s.empty?
   end

   arr << h
end

arr.each

arr.each do |doc|
  open(File.join('./_drafts/temp/', doc['slug'] + '.md'), 'w') do |d|
    d.puts doc.to_yaml
    d.puts '---'
  end
end
~~~

