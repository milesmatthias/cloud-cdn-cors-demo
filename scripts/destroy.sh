#! /usr/bin/env bash

PROJECT=$(gcloud config get-value project)
BUCKET=$PROJECT-demo-cdn-origin
BACKEND_BUCKET=backend-$BUCKET
URL_MAP=$PROJECT-demo-cdn-url-map
FWD_RULE=$PROJECT-demo-cdn-fwd-rule
LB=$PROJECT-demo-cdn-lb-ip-1
HTTP_PROXY=$PROJECT-demo-cdn-http-proxy

# destroy bucket
gsutil -qm rm -r gs://$BUCKET

# destroy load balancer
gcloud -q compute addresses delete $LB --global

# destroy forwarding rule
gcloud -q compute forwarding-rules delete $FWD_RULE --global

# destroy target-http-proxies
gcloud -q compute target-http-proxies delete $HTTP_PROXY

# destroy url-maps
gcloud -q compute url-maps delete $URL_MAP

# destroy backend bucket
gcloud -q compute backend-buckets delete $BACKEND_BUCKET

