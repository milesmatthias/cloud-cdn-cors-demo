#! /usr/bin/env bash

PROJECT=$(gcloud config get-value project)
LB=$PROJECT-demo-cdn-lb-ip-1
BUCKET=$PROJECT-demo-cdn-origin

IP_ADDR=$(gcloud compute addresses describe $LB --global | \
  grep -e "^address:" | awk -F' ' '{print $2}')

# TODO -- loop while status == 404; takes CDN a bit to get up and running
HEADERS=$(curl -vvvv -I -H "Origin: http://example.appspot.com" \
	$IP_ADDR/index.html)

# give success or failure message

if [[ ! $HEADERS =~ "Access-Control-Allow-Origin: *" ]]; then
	echo -e "FAILED: Missing the Access-Control-Allow-Origin header!"
	echo -e "NOTE that it may take time to propogate these headers."
else
	echo "SUCCESS: 'Access-Control-Allow-Origin' header is present"
fi

if [[ ! $HEADERS =~ "Access-Control-Expose-Headers: Origin" ]]; then
	echo -e "FAILED: Missing the Access-Control-Expose-Headers header!"
	echo -e "NOTE that it may take time to propogate these headers."
else
	echo "SUCCESS: 'Access-Control-Expose-Headers' header is present"
fi


### Other ways to check CORS HEADERS

# Option request
# HEADERS=$(curl -vvvv -H "Origin: http://example.appspot.com" \
#   -H "Access-Control-Request-Method: POST" \
#   -H "Access-Control-Request-Headers: X-Requested-With" \
#   -X OPTIONS \
#   $IP_ADDR/index.html)
# echo $HEADERS

# curl the GCS bucket directly
# HEADERS=$(curl -vvvv -I -H "Origin: http://example.appspot.com" \
#   http://$BUCKET.storage.googleapis.com/index.html)
# echo $HEADERS

