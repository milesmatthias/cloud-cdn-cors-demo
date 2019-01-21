#! /usr/bin/env bash

PROJECT=$(gcloud config get-value project)
LB=$PROJECT-demo-cdn-lb-ip-1

IP_ADDR=$(gcloud compute addresses describe $LB --global | \
  grep -e "^address:" | awk -F' ' '{print $2}')


# TODO -- loop while status == 404; takes CDN a bit to get up and running

HEADERS=$(curl -vvvv -H "Host: example.appspot.com" $IP_ADDR/index.html)

echo $HEADERS

# TODO -- give success or failure message
