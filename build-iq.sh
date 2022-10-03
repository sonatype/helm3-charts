#!/bin/sh
#
# Copyright (c) 2020-present Sonatype, Inc. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.
#

helm plugin install https://github.com/quintush/helm-unittest

set -e

# lint yaml of charts
helm lint charts/nexus-iq

# unit test
(cd charts/nexus-iq; helm unittest -3 -t junit -o test-output.xml .)

# package the charts into tgz archives
helm package charts/nexus-iq --destination docs
