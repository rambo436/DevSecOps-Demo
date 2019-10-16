#!/bin/bash

####################################################
# Bootstrapping script for DSOP vendor onboarding
# See https://dccscr.dsop.io/dsop/vendor-onboarding
####################################################

PRODUCT_NAME=ruby
# WIDGETS=(api cli ui)
DOCKERFILE="#base dockerfile structure"

# Downloading tarball
curl https://github.com/ruby/ruby/archive/v2_6_5.tar.gz --output ./src/ruby-2.6.5.tar

mkdir -p ${PRODUCT_NAME}.repo/deployment/{helm/$PRODUCT_NAME/templates,vendor}

for i in "${WIDGETS[@]}"; do mkdir -p ${PRODUCT_NAME}.repo/images/$PRODUCT_NAME-$i/src; done

for i in "${WIDGETS[@]}";
do
  cat << EOF > ${PRODUCT_NAME}.repo/images/$PRODUCT_NAME-$i/Dockerfile
  # An example of customising Ruby using RedHat Univeral Base Image (UBI).
  ARG RUBY_BASE_VERSION=2.6.5
  ARG UBI_BASE_IMAGE=ubi7-dev-preview/ubi:latest
  ARG BASE_IMAGE_REGISTRY=registry.access.redhat.com
  ARG USER=ruby
  ARG GROUP=ruby-group

  FROM ${BASE_IMAGE_REGISTRY}/${UBI_BASE_IMAGE} as ruby-builder

  USER ${USER}

  COPY ./src/ /src

  ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

  RUN mkdir -p /build_output && \
      tar -x -v -C /build_output/ -f /src/ruby-2.6.5.tar


  FROM registry.access.redhat.com/ubi7/ubi as ruby-final

  ARG PRODUCT_VERSION="2.6.5"

  # Copy artifacts from build step
  COPY --from=ruby-builder /build_output /build_output

  #
  # Container metadata section
  #

  MAINTAINER Moonrake, LLC <kai@moonrake.it>

  LABEL name="Ruby" \
        source="https://github.com/ruby/ruby" \
        description="Ruby image based on the Red Hat Universal Base Image for DSOP." \
        vendor="Moonrake, LLC" \
        contributor="Kai Prout" \
        release="" \
        summary="Ruby v2.6.5 (Red Hat UBI)" \
        maintainer="Moonrake, LLC. <kai@moonrake.it>" \
        version="2.6.5"

  RUN yum update -y && \
      yum install -y --disableplugin=subscription-manager gcc make zlib zlib-devel openssl-devel

  WORKDIR /build_output/ruby-2.6.5

  #
  # Perform OS setup
  # Include applicable license files under /licenses
  #
  RUN set -ex && \
      groupadd --gid 1000 ruby && \
      useradd --uid 1000 --gid ruby --shell /bin/bash --create-home ruby

  #
  # Perform the Ruby build, executing unit tests, and installing
  #

  RUN ./configure  --disable-dtrace --disable-install-doc --disable-install-rdoc --enable-shared --without-gmp --without-gdbm --without-tk \
      && make && make install

  RUN gem update --no-document
  RUN gem install bundler --force --no-document
  #
  # Avoid running as root, apply USER directive
  # For a full working example on this please ref:
  # https://raw.githubusercontent.com/RHsyseng/container-rhel-examples/master/starter-arbitrary-uid/Dockerfile
  #
  USER ruby:ruby

  HEALTHCHECK CMD ruby -v || exit 1

EOF
done

# inject files for helm
touch ${PRODUCT_NAME}.repo/deployment/helm/$PRODUCT_NAME/{Chart.yaml,OWNERS,README.md,values.yaml,requirements.lock,requirements.yaml}
touch ${PRODUCT_NAME}.repo/deployment/helm/$PRODUCT_NAME/templates/{NOTES.txt,_helpers.tpl,ingress.yaml,secrets.yaml}
for i in "${WIDGETS[@]}";
do
  touch ${PRODUCT_NAME}.repo/deployment/helm/$PRODUCT_NAME/templates/${i}_deployment.yaml
  touch ${PRODUCT_NAME}.repo/deployment/helm/$PRODUCT_NAME/templates/${i}_config.yaml
done

# inject license and readme files per widget
for i in "${WIDGETS[@]}";
do
  touch ${PRODUCT_NAME}.repo/images/$PRODUCT_NAME-$i/{LICENSE,README.md}
done
