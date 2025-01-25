# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
echo "Exporting GCLOUD_PROJECT and GCLOUD_BUCKET"
export GCLOUD_PROJECT=$DEVSHELL_PROJECT_ID
export GCLOUD_BUCKET=$DEVSHELL_PROJECT_ID-media

echo "Enabling App Engine Flex API"
gcloud services enable appengineflex.googleapis.com

echo "Enabling Cloud Functions API"
gcloud services enable cloudfunctions.googleapis.com

echo "Enabling Cloud Build API"
gcloud services enable cloudbuild.googleapis.com

echo "Creating App Engine app"
gcloud app create --region "us-central"

echo "Making bucket: gs://$GCLOUD_BUCKET"
gsutil mb gs://$GCLOUD_BUCKET

echo "Installing dependencies"
npm install -g npm@8.1.3
npm update

echo "Creating Datastore entities"
node setup/add_entities.js

echo "Creating Cloud Pub/Sub topic"
gcloud pubsub topics create feedback

echo "Creating Cloud Spanner Instance, Database, and Table"
gcloud spanner instances create quiz-instance --config=regional-us-central1 --description="Quiz instance" --nodes=1
gcloud spanner databases create quiz-database --instance quiz-instance --ddl "CREATE TABLE Feedback ( feedbackId STRING(100) NOT NULL, email STRING(100), quiz STRING(20), feedback STRING(MAX), rating INT64, score FLOAT64, timestamp INT64 ) PRIMARY KEY (feedbackId);"

echo "Creating Cloud Function"
gcloud functions deploy process-feedback --runtime nodejs14 --allow-unauthenticated --trigger-topic feedback --source ./function --stage-bucket $GCLOUD_BUCKET --entry-point subscribe

echo "Project ID: $DEVSHELL_PROJECT_ID"