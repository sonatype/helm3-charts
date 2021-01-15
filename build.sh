#!/bin/sh

# package the charts into tgz archives
helm package charts/nexus-iq --destination docs
helm package charts/nexus-repository-manager --destination docs

# index the existing tgz archives
cd docs
helm repo index . --url https://sonatype.github.io/helm3-charts
