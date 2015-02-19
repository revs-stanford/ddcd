---
title: New York City Taxi Trip Data
---

<iframe width='100%' height='520' frameborder='0' src='http://dansn.cartodb.com/viz/1eba1b7e-b39e-11e4-befe-0e4fddd5de28/embed_map' allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>

<iframe width='100%' height='520' frameborder='0' src='http://dansn.cartodb.com/viz/2a5b43aa-b39d-11e4-9a17-0e018d66dc29/embed_map' allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>


The 2008 to 2013 NYC Taxi Trip Data set comes courtesy of a FOIL request to the Taxi & Limousine Commission. [The data is currently hosted on Google's BigQuery service](https://bigquery.cloud.google.com/table/alien-climber-851:nyc_taxi_redacted.trip_data), where you can run SQL queries and batch jobs on it. There are nearly 850,000,000 rows and the data requires 98 gigabytes of disk space.


Sample query to select everyone who has been dropped off at JFK Airport:

~~~sql
SELECT 
  pickup_datetime, dropoff_datetime,
  ((dropoff_datetime - pickup_datetime) / 1000000) AS trip_duration,
  trip_distance,passenger_count,
  fare_amount, tolls_amount, surcharge, mta_tax, tip_amount, total_amount,  payment_type,
  pickup_longitude, pickup_latitude,
  dropoff_longitude, dropoff_latitude
  FROM 
    [alien-climber-851:nyc_taxi_redacted.trip_data]
  WHERE 
    YEAR(pickup_datetime) >= 2010
      AND pickup_latitude > 40.641898 
      AND pickup_latitude < 40.659925
      AND pickup_longitude > -73.809503
      AND pickup_longitude < -73.775857
  ORDER BY 
    pickup_datetime, dropoff_datetime 
~~~


#### Cash vs credit card payments, per day, from 2008 to 2013

![img](/files/images/features/cash-vs-credit-payments-taxi-nyc.png)



#### Taxi pickups during Hurricane Sandy compared to one week after

![img](/files/images/features/hurricane-sandy-taxi.png)


#### Taxi pickups during Hurricane Irene compared to one week before

![img](/files/images/features/irene-one-week-before.png)


#### Taxi pickups during President Obama's 2011 NYC fundraiser compared to one week after

![img](/files/images/features/obama-apr-27-2011.png)

