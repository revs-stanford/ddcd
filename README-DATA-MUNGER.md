## Data munging notes


----

NY State data




-------------

# For NYC Taxi notes



# Chart translation


vendor_id
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

~~~sh

idir=./tlc-renamed
odir=./nyc-taxi-2008-to-revs/dumps
mkdir -p $odir
for year in $(seq 2009 2013); do
  echo ' '
  for month in $(seq 1 12); do
    mkdir -p "$odir/$year"
    oname="$odir/$year/trip_data_$month.csv"
    echo Making $oname
    echo "---------------------------------------------"
    echo 'vendor_id,pickup_datetime,dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude,rate_code,store_and_fwd_flag,fare_amount,surcharge,mta_tax,tip_amount,tolls_amount,total_amount,payment_type' > $oname


    ifile="$idir/$year/trip_data_$month.csv"
    cat $ifile | dos2unix | sed 1d >> $oname
  done
done


Load into big query

bq load --project_id='alien-climber-851' --skip_leading_rows=1 'alien-climber-851:nyc_taxi_redacted.trip_data' gs://nyctaxidatarevs/2010/*.csv 'vendor_id:string, pickup_datetime:timestamp, dropoff_datetime:timestamp, passenger_count:integer, trip_distance:float, pickup_longitude:float, pickup_latitude:float,dropoff_longitude:float,dropoff_latitude:float, rate_code, store_and_fwd_Flag, fare_amount:float, surcharge:float, mta_tax:float, tip_amount:float, tolls_amount:float, total_amount:float, payment_type'



~~~


Google query schema:
vendor_id:string, pickup_datetime:timestamp, dropoff_datetime:timestamp, passenger_count:integer, trip_distance:float, pickup_longitude:float, pickup_latitude:float,dropoff_longitude:float,dropoff_latitude:float, rate_code, store_and_fwd_Flag, fare_amount:float, surcharge:float, mta_tax:float, tip_amount:float, tolls_amount:float, total_amount:float, payment_type




pickup_datetime,dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude,rate_code,store_and_fwd_flag,fare_amount,surcharge,mta_tax,tip_amount,tolls_amount,total_amount,payment_type







-----------

### NYS Data

~~~sh
 cat Vehicle__Snowmobile__and_Boat_Registrations.csv | dos2unix | sed -E 's#([0-9]{2})/([0-9]{2})/([0-9]{4})#\3-\1-\2#g' > Vehicle__Snowmobile__and_Boat_Registrations.fixed-dates.csv 
~~~

~~~sh
cat Driver_License__Permit__and_Non-Driver_Identification_Cards_Issued.csv | dos2unix >  Driver_License__Permit__and_Non-Driver_Identification_Cards_Issued.fixed.csv
~~~

~~~sh
for year in $(seq 2008 2012); do 
  fname="${year}_tickets.csv"
  echo $fname
  cat $fname | dos2unix | ./perltime.pl > "${year}_tickets.fixed.csv"
done


bq load --project_id='stunning-ripsaw-851' --skip_leading_rows=1 'stunning-ripsaw-851:nys_dmv.traffic_tickets' gs://newyork-dmv/tickets/*.csv 'violation_charged_code:STRING,violation_description:STRING,violation_year:INTEGER,violation_month:INTEGER,violation_time:STRING,age_at_violation:INTEGER,state_of_license:STRING,gender:STRING,police_agency:STRING,court:STRING,source:STRING'





#### Air data


~~~sh
curl -s http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html | pup 'a attr{href}' | grep annual | sed 's#^#http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/#' | xargs wget

# munge
head -n 1 annual/annual_all_2013.csv | tr '[:upper:]' '[:lower:]' | tr ' ' '_' > annual_compiled.csv

for file in annual/*.csv; do
  echo $file
  cat $file | dos2unix | sed 1d >> annual_compiled.csv
done

~~~

~~~sh
curl -s http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html | pup 'a attr{href}' | grep daily | grep -vE 'WIND|TEMP|PRESS|RH_DP' | sed 's#^#http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/#' | xargs wget


for id in 42401 42602 44201 81102 88101 88502; do
  head -n 1 daily/daily_${id}_2013.csv | tr '[:upper:]' '[:lower:]' | \
    tr ' ' '_' > daily_compiled_${id}-1990_2014.csv
  for file in daily/daily_${id}_*.csv; do 
    echo $file
    cat $file | dos2unix | sed 1d >> daily_compiled_${id}-1990_2014.csv
  done
done


~~~














######## EPA


~~~sh
# for annual epa
bq load --project_id='valiant-vault-851' --skip_leading_rows=1 'valiant-vault-851:epa_airdata.annual_summaries' gs://epa-airdata/annual_compiled-1990-2014.csv 'state_code,county_code,site_num,parameter_code,poc,latitude:float,longitude:float,datum,parameter_name,sample_duration,pollutant_standard,metric_used,method_name,year,units_of_measure,event_type,observation_count:float,observation_percent,valid_day_count,required_day_count,exceptional_data_count,null_data_count,primary_exceedance_count,secondary_exceedance_count,certification_indicator,num_obs_below_mdl,arithmetic_mean:float,arithmetic_standard_dev,the_1st_max_value,the_1st_max_datetime,the_2nd_max_value,the_2nd_max_datetime,the_3rd_max_value,the_3rd_max_datetime,the_4th_max_value,the_4th_max_datetime,the_1st_max_non_overlapping_value,the_1st_no_max_datetime,the_2nd_max_non_overlapping_value,the_2nd_no_max_datetime,the_99th_percentile,the_98th_percentile,the_95th_percentile,the_90th_percentile,the_75th_percentile,the_50th_percentile,the_10th_percentile,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change'
~~~


~~~sh
bq load --project_id='valiant-vault-851' --skip_leading_rows=1 'valiant-vault-851:epa_airdata.daily_summaries' gs://epa-airdata/daily_compiled*.csv state_code,county_code,site_num,parameter_code,poc,latitude:float,longitude:float,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count:float,observation_percent,arithmetic_mean:float,the_1st_max_value,the_1st_max_hour,aqi:integer,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change
~~~

~~~sh
# particulate stuff
gsutil -m cp {*LEAD*.csv,*VOCS*.csv,*HAPS*.csv,*SPEC*.csv} gs://epa-airdata/daily_summaries_particulates/*

bq load --project_id='valiant-vault-851' --skip_leading_rows=1 'valiant-vault-851:epa_airdata.daily_summaries' gs://epa-airdata/daily_summaries_particulates/*.csv state_code,county_code,site_num,parameter_code,poc,latitude:float,longitude:float,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count:float,observation_percent,arithmetic_mean:float,the_1st_max_value,the_1st_max_hour,aqi:integer,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change
~~~


### FARS

~~~sh
mkdir -p sas/downloads
cd sas/downloads
for year in $(seq 1975 2013); do
  echo "Downloading $year"
  mkdir -p $year


  if [[ $year -eq 1978]]
   echo 'have to dwonload files manually ftp://ftp.nhtsa.dot.gov/fars/1978/SAS/'

  # because they decided to change naming conventions, because why not?
  elif [[ $year -ge 1975 && $year -le 1998 || $year -eq 2000 ]]; then
    curl -sS "ftp://ftp.nhtsa.dot.gov/fars/$year/SAS/FSAS$(echo $year | \
      grep -oE '[0-9]{2}$').zip" \
      -o "$year/FSAS$year.zip"

  
  elif [[ $year -eq 1999 ]]; then  
    curl -sS "ftp://ftp.nhtsa.dot.gov/fars/$year/SAS/FARS$(echo $year | \
      grep -oE '[0-9]{2}$').zip" \
      -o "$year/FSAS$year.zip"
  else
    curl -sS ftp://ftp.nhtsa.dot.gov/fars/$year/SAS/FSAS$year.zip \
    -o "$year/FSAS$year.zip"
  fi

  cd $year
  unzip "FSAS$year.zip" 
  cd ..
done


~~~

~~~sh
# for DBFS
mkdir -p dbf/downloads
cd dbf/downloads

for year in $(seq 1975 2013); do
  echo "Downloading $year"
  mkdir -p $year

  # because they decided to change naming conventions, because why not?
  if [[ $year -ge 1994 && $year -le 2000 ]]; then  
    curl -sS "ftp://ftp.nhtsa.dot.gov/fars/$year/DBF/FARSDBF$(echo $year | \
      grep -oE '[0-9]{2}$').zip" \
      -o "$year/FARS$year.zip"
  else
    curl -sS ftp://ftp.nhtsa.dot.gov/fars/$year/DBF/FARS$year.zip \
    -o "$year/FARS$year.zip"
  fi

  cd $year
  unzip "FARS$year.zip" 
  cd ..
done


## Using this python script, dbf2csv.py
mkdir -p usable-files
ls ./downloads/*/*{.dbf,DBF} | grep -iE 'accident|person|vehicle' | \
while read -r fname; do
  newname=$(echo $fname | grep -oE '[0-9]{4}/.+' | sed 's/\//-/' | tr '[:upper:]' '[:lower:]')
  echo $fname to usable-files/$newname
  mv $fname "usable-files/$newname"
  ./dbf2csv.py "usable-files/$newname"
done

~~~





### NHTSA Safety Ratings 51

~~~sh
https://gist.github.com/dannguyen/57423dbcb1713d31b659


# quick hack



# fucking CSVs are broke
# collect em all
# head -n 1 vehicles/9001.csv > all-vehicles.csv
# ls vehicles/*.csv | while read f; do 
#  tail -n1 $f >> all-vehicles.csv
# done 

gsutil cp all-vehicles.psv gs://nhtsa-data/5-star-ratings/all-vehicles.csv

bq load  --project_id='nhtsa-revs' --skip_leading_rows=1 'nhtsa-revs:safety.ratings' gs://nhtsa-data/5-star-ratings/all-vehicles.csv 'ComplaintsCount,FrontCrashDriversideNotes,FrontCrashDriversideRating,FrontCrashDriversideSafetyConcern,FrontCrashPassengersideNotes,FrontCrashPassengersideRating,FrontCrashPicture,FrontCrashVideo,FrontPassengersideSafetyConcern,InvestigationCount,Make,Model,ModelYear,NHTSAElectronicStabilityControl,NHTSAForwardCollisionWarning,NHTSALaneDepartureWarning,NHTSARearviewVideoSystems,OverallFrontCrashRating,OverallRating,OverallSideCrashRating,RecallsCount,RolloverNotes,RolloverPossibility,RolloverPossibility2,RolloverRating,RolloverRating2,SideCrashDriversideNotes,SideCrashDriversideRating,SideCrashDriversideSafetyConcern,SideCrashPassengersideNotes,SideCrashPassengersideRating,SideCrashPassengersideSafetyConcern,SideCrashPicture,SideCrashVideo,SidePoleCrashRating,SidePoleNotes,SidePolePicture,SidePoleSafetyConcern,SidePoleVideo,VehicleDescription,VehicleId,VehiclePicture'




# and all the pix
for t in FrontCrashPicture VehiclePicture SidePolePicture SideCrashPicture; do 
  mkdir -p pictures/$t
  cd pictures/$t  
  jq -r ".[] | select(.$t != null) | [.VehicleId, .$t] | @csv" < ../../all-vehicles.json | tr -d '"' | \
  while read -r line; do     
    id=$(echo "$line" | cut -d ',' -f1)
    url=$(echo "$line" | cut -d ',' -f2)
    fname="$id-$(basename "$url")"
    if [[ ! -a "$fname" ]]; then
      echo $fname
      curl -sS "$url" -o "$fname"
    fi
  done
  cd ../..  
done


# Now download all the movies
for t in FrontCrashVideo SideCrashVideo SidePoleVideo; do 
  mkdir -p wmvs/$t
  cd wmvs/$t  
  jq -r ".[] | select(.$t != null) | [.VehicleId, .$t] | @csv" < ../../all-vehicles.json | tr -d '"' | grep -iE '\.[A-Z]{2,}$' | 
  while read -r line; do 
    id=$(echo "$line" | cut -d ',' -f1)
    url=$(echo "$line" | cut -d ',' -f2)
    fname="$id-$(basename "$url")"
    if [[ ! -a "$fname" ]]; then
        echo $fname
        curl -sS "$url" -o "$fname"
        sleep 1
    fi
  done
  cd ../..  
done

# Now convert them to mpegs
for t in FrontCrashVideo SideCrashVideo SidePoleVideo; do 
  mkdir -p mp4s/$t
  ls wmvs/$t/*{.wmv,.WMV} | while read -r wfile; do
    mfile=$(basename "$wfile" | sed -E 's/\.WMV$|\.wmv$/.mp4/')
    echo "mp4s/$t/$mfile" 
    avconv -i $wfile "mp4s/$t/$mfile" 
  done  
done


# jq '.[] | select(.FrontCrashPicture != null) | select(.OverallFrontCrashRating != "Not Rated") | select(.OverallSideCrashRating != "Not Rated") | .OverallSideCrashRating' < all-vehicles.json

Grab all with working mp4s and jpgs and ratings

# Video stuff
http://superuser.com/questions/547296/resizing-videos-with-ffmpeg-avconv-to-fit-into-static-sized-player

width=200
height=200
ffmpeg -i "$file" -filter:v "scale=iw*min($width/iw\,$height/ih):ih*min($width/iw\,$height/ih), pad=$width:$height:($width-iw*min($width/iw\,$height/ih))/2:($height-ih*min($width/iw\,$height/ih))/2" out.mp4

# crop the images
http://www.imagemagick.org/discourse-server/viewtopic.php?t=18545
convert image -resize "275x275^" -gravity center -crop 275x275+0+0 +repage resultimage

(er check screenshotty!)
~~~



### NHTSA flat file databases

~~~sh
for t in Complaints-CMPL Investigations-INV Recalls-RCL TSBS-TSBS; do 
  x=$(echo $t | cut -d'-' -f1)
  y=$(echo $t | cut -d'-' -f2)
  # download the zip
  # get the instructions
  curl -sS http://www-odi.nhtsa.dot.gov/downloads/folders/$x/$y.txt \
    -o INSTRUCTIONS_$y.txt
  # get the fields from the instruction TXT
  fields=$(cat INSTRUCTIONS_$y.txt | dos2unix | grep -oE '^[0-9]{1,2} +[A-z0-9_]+' | sed -E 's/^[0-9]+ +//' | paste -s -d ',' -)
  echo $fields | csvfix echo > FLAT_$y.csv

  # curl -O -sS http://www-odi.nhtsa.dot.gov/downloads/folders/$x/FLAT_$y.zip 
  # unzip it
  echo "Unzipping $FLAT_$y.zip"
  unzip -aa -p FLAT_$y.zip  | csvfix read_dsv -s '\t' >> FLAT_$y.csv

  # load into GS
  echo "Loading into s://nhtsa-data/odi/FLAT_$y.csv"
  gsutil cp FLAT_$y.csv gs://nhtsa-data/odi/FLAT_$y.csv

  # load into big query
  echo "big query nhtsa-revs:odi.$y"
  # removing old table
  bq rm -f --project_id='nhtsa-revs' "nhtsa-revs:odi.$y"
  bq load --project_id='nhtsa-revs' --skip_leading_rows=1 --max_bad_records=100 "nhtsa-revs:odi.$y" "gs://nhtsa-data/odi/FLAT_$y.csv" "$fields"
done


~~~
