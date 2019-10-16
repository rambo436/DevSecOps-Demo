#!/bin/bash

echo "Download Ruby Tarball"
curl https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.5.tar.gz --output ./src/ruby-2.6.5.tar.gz

echo "Validate MD5 checksum"
shasum -a256 ruby-2.6.5.tar.gz |
  awk '$1=="66976b716ecc1fd34f9b7c3c2b07bbd37631815377a2e3e85a5b194cfdcbed7d"{print"good to go"}'

echo "Building docker image and tagging as moonrake-docker-ruby:demo"
docker build -t moonrake-docker-ruby:demo .

echo "Running cleanup"
rm -rf ./src/ruby-2.6.5.tar.gz

echo "Interact with image by running in terminal: docker run -it moonrake-docker-ruby:demo"
