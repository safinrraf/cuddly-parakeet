BUCKET_NAME=

#create a storage bucket
gcloud storage buckets create gs://$BUCKET_NAME

gsutil mb gs://<$BUCKET_NAME>

curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output sample.txt

curl https://storage.googleapis.com/cloud-training/gsp315/map.jpg --output sample.txt


gcloud storage cp sample.txt gs://$BUCKET_NAME

gsutil ls gs://$BUCKET_NAME
