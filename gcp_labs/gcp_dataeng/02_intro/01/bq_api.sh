#In your Cloud Shell, run the following command
#With the this load job, we are specifying that this subset is to be appended to the existing 2018trips table that you created above.
bq load \
--source_format=CSV \
--autodetect \
--noreplace  \
nyctaxi.2018trips \
gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv
