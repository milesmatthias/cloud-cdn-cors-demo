#! /usr/bin/env bash

source "scripts/common.sh"
ensureRequiredTools

PROJECT=$(gcloud config get-value project)
BUCKET=$PROJECT-demo-cdn-origin
BACKEND_BUCKET=backend-$BUCKET
URL_MAP=$PROJECT-demo-cdn-url-map
FWD_RULE=$PROJECT-demo-cdn-fwd-rule
LB=$PROJECT-demo-cdn-lb-ip-1
HTTP_PROXY=$PROJECT-demo-cdn-http-proxy

# enable compute api
gcloud services enable compute.googleapis.com


#####################
# GCS CONFIG
#####################

# create a GCS bucket
gsutil mb -c regional -l us-central1 gs://$BUCKET

# upload example/index.html to the bucket
gsutil cp example/index.html gs://$BUCKET

# make the bucket publically readable
gsutil defacl set public-read gs://$BUCKET

# Add CORS config for 
gsutil cors set example/cors-config-example.json gs://$BUCKET

# map / to /index.html
gsutil web set -m index.html gs://$BUCKET


#####################
# CDN CONFIG
#####################

# create load balancer
gcloud compute addresses create $LB \
  --ip-version=IPV4 \
  --global

# Get the LB IP address
IP_ADDR=$(gcloud compute addresses describe $LB --global | \
  grep -e "^address:" | awk -F' ' '{print $2}')

# create a CDN distribution with the GCS bucket as the origin
# ie "Backend"
gcloud compute backend-buckets create $BACKEND_BUCKET \
  --enable-cdn --gcs-bucket-name=$BUCKET

# Create URL map to route everything to the bucket
gcloud compute url-maps create $URL_MAP \
  --default-backend-bucket $BACKEND_BUCKET

# Add url map to load balancer via HTTP Proxy
# You have to do this if you want to use a global load balancer
# with a backend bucket. If LB is regional, then the
# forwarding rule can use --backend-service to point to our bucket.
gcloud compute target-http-proxies create $HTTP_PROXY \
  --url-map $URL_MAP

# Add proxy rule to load balancer ie "Frontend"
gcloud compute forwarding-rules create $FWD_RULE \
  --address "$IP_ADDR" \
  --global \
  --target-http-proxy $HTTP_PROXY \
  --ports 80

echo "CDN is setup at ${IP_ADDR}."
