#! /usr/bin/env bash

PROJECT=$(gcloud config get-value project)
LB=$PROJECT-demo-cdn-lb-ip-1
BUCKET=$PROJECT-demo-cdn-origin

HEADERS=$(curl -vvvv -I -H "Origin: http://example.appspot.com" \
  http://$BUCKET.storage.googleapis.com/index.html)

# HEADERS=$(curl -vvvv -H "Host: example.appspot.com" \
#   -H "Access-Control-Request-Method: GET" \
#   -H "Access-Control-Request-Headers: Content-Type" \
#   -X OPTIONS \
#   http://$BUCKET.storage.googleapis.com/index.html)
#   #http://storage.googleapis.com/$BUCKET/index.html)

echo $HEADERS

# IP_ADDR=$(gcloud compute addresses describe $LB --global | \
#   grep -e "^address:" | awk -F' ' '{print $2}')

# TODO -- loop while status == 404; takes CDN a bit to get up and running

# HEADERS=$(curl -vvvv -H "Host: example.appspot.com" \
#   -H "Access-Control-Request-Method: POST" \
#   -H "Access-Control-Request-Headers: X-Requested-With" \
#   -X OPTIONS \
#   $IP_ADDR/index.html)
# 
# echo $HEADERS

# TODO -- give success or failure message
# TODO -- saw note on SO that this may take 2-3 hours for CORS to propagate
