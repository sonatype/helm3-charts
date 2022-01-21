# Copyright (c) 2019-present Sonatype, Inc. All rights reserved.
# Includes the third-party code listed at http://links.sonatype.com/products/nexus/attributions.
# "Sonatype" is a trademark of Sonatype, Inc.

FROM docker-all.repo.sonatype.com/alpine/helm:3.5.0

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN helm plugin install https://github.com/quintush/helm-unittest