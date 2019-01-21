#! /usr/bin/env bash

function ensureRequiredTools() {
command -v helm >/dev/null 2>&1 || { \
  echo >&2 "I require helm but it's not installed. Aborting."; exit 1; }

command -v kubectl >/dev/null 2>&1 || { \
  echo >&2 "I require kubectl but it's not installed. Aborting."; exit 1; }

command -v gcloud >/dev/null 2>&1 || { \
  echo >&2 "I require gcloud but it's not installed. Aborting."; exit 1; }

command -v gsutil >/dev/null 2>&1 || { \
  echo >&2 "I require gsutil but it's not installed. Aborting."; exit 1; }
}

