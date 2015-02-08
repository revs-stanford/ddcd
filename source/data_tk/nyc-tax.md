In October 2009, the mta_tax was put into effect
http://www.nytimes.com/2009/11/02/nyregion/02mta.html?_r=0

in 2008, payment type is Cas, Cre



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
