#!/bin/bash

gcloud config set compute/zone "Zone"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "Region"
export REGION=$(gcloud config get compute/region)