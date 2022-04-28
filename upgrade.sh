#!/bin/sh

if [ $# != 3 ]; then
    echo "Usage: $0 <dir> <chart-version> <app-version>"
    exit 1
fi

DIR=$1
CHART_VERSION=$2
APP_VERSION=$3

OUTPUT_FILE=$(mktemp)

cat $DIR/Chart.yaml \
  | sed -E "s/version: .+/version: $CHART_VERSION/" \
  | sed -E "s/appVersion: .+/appVersion: $APP_VERSION/" \
  > $OUTPUT_FILE

mv $OUTPUT_FILE $DIR/Chart.yaml

cat $DIR/values.yaml \
  | sed -E "s/^  tag: .+$/  tag: $APP_VERSION/" \
  > $OUTPUT_FILE

mv $OUTPUT_FILE $DIR/values.yaml

git diff $DIR
