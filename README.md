# cloud-cdn-cors-demo
A simple demo on options to add CORS headers to the GCP Cloud CDN

NOTE -- This is for demo purposes only. Do not run this in production.
This repo will not be maintained either.
It is also recommended that you run this demo in a new project.


## Pre-reqs

1. Authenticate: `gcloud auth default-application login`
2. Set your project `gcloud config set project <project-id>`


## Create infrastructure

`make create`

will create the necessary infrastructure for this demo. Mainly:

1. A GCS bucket with example/index.html in it
2. Add CORS configuration to the GCS bucket for example.appspot.com
2. Cloud CDN distribution with the GCS bucket as the origin

See `cors-config-example.json` for the example CORS config.


## Validate our demo

`make validate`

will request `index.html` from the Cloud CDN and ensure
CORS headers are present. If not, you'll see an error message.


## Resources
* [CORS](https://cloud.google.com/storage/docs/cross-origin)
* [Configure CORS on Storage Bucket](https://cloud.google.com/storage/docs/configuring-cors)
