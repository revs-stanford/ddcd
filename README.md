
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
