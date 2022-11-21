#!/bin/bash

curl --location --request GET https://$1:$2/_cluster/health?pretty --header 'Authorization: Basic ZWxhc3RpYzpwYXNzQDEyMw=='
