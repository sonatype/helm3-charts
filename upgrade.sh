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

if [ $# != 3 ]; then
    echo "Usage: $0 <dir> <chart-version> <app-version>"
    exit 1
fi

DIR="$1"
CHART_VERSION="$2"
APP_VERSION="$3"

OUTPUT_FILE=$(mktemp)

cat "$DIR/Chart.yaml" \
  | sed -E "s/version: .+/version: $CHART_VERSION/" \
  | sed -E "s/appVersion: .+/appVersion: $APP_VERSION/" \
  > "$OUTPUT_FILE"

mv "$OUTPUT_FILE" "$DIR/Chart.yaml"

cat "$DIR/values.yaml" \
  | sed -E "s/^  tag: .+$/  tag: $APP_VERSION/" \
  > "$OUTPUT_FILE"

mv "$OUTPUT_FILE" "$DIR/values.yaml"

git diff "$DIR"
