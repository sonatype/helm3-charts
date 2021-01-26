#!/bin/sh
#
# Copyright (c) 2011-present Sonatype, Inc. All rights reserved.
# Includes the third-party code listed at http://links.sonatype.com/products/nexus/attributions.
# "Sonatype" is a trademark of Sonatype, Inc.
#

# package the charts into tgz archives
helm package charts/nexus-iq --destination docs
helm package charts/nexus-repository-manager --destination docs

# index the existing tgz archives
cd docs
helm repo index . --url https://sonatype.github.io/helm3-charts
