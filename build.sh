#!/bin/sh
#
# Copyright (c) 2019-present Sonatype, Inc. All rights reserved.
# Includes the third-party code listed at http://links.sonatype.com/products/nexus/attributions.
# "Sonatype" is a trademark of Sonatype, Inc.
#

set -e

helm lint charts/nexus-iq
helm lint charts/nexus-repository-manager

# package the charts into tgz archives
helm package charts/nexus-iq --destination docs
helm package charts/nexus-repository-manager --destination docs

# index the existing tgz archives
cd docs
helm repo index . --url https://sonatype.github.io/helm3-charts
