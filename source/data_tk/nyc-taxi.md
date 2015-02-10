---
title: NYC Taxi 2008 to 2013 Redacted Dataset
description: |
  Description TOK Fun Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quidem fugit, a asperiores cum omnis magni sunt consectetur unde alias in obcaecati odit magnam dicta enim vero illum. Itaque, praesentium aut?

source:
  primary: National Highway Traffic Safety Administration
  sub: Office of Defect Investigations

visualizations:
  - title: Ocks Lorem Hexabins
    slug: ocks-dynamic-hexabin
    image_url: '/visualizations/images/ocks-dynamic-hexabin.png'
    description: |
      Hexabin from ocks org http://bl.ocks.org/mbostock/7833311    
---


### Origin of the dataset

The Taxi & Limousine Commission will provide data upon request. [See Chris Whong](http://chriswhong.com/open-data/foil_nyc_taxi/).

This 2008 to 2013 dataset came from a public records request made by [Dan Nguyen](https://twitter.com/dancow) on Aug. 8, 2014.


### History of the dataset


In October 2009, the [mta_tax was put into effect](http://www.nytimes.com/2009/11/02/nyregion/02mta.html?_r=0)




# Chart translation

pickup_datetime
dropoff_datetime
passenger_count
trip_distance
pickup_longitude
pickup_latitude
rate_code => dropoff_longitude
store_and_fwd_flag => dropoff_latitude
dropoff_longitude => rate_code
dropoff_latitude => store_and_fwd_flag
payment_type => fare_amount
fare_amount => surcharge
surcharge => mta_tax
mta_tax => tip_amount
tip_amount => tolls_amount
tolls_amount => total_amount
total_amount => payment_type
