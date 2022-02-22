#!/bin/sh

pgmetrics --no-password --no-pager --all-dbs --format=json --output=/tmp/pgmetrics_out.json
collection_at=$(grep '"at":' /tmp/pgmetrics_out.json | cut -d":" -f2 | cut -d"," -f1)
sed -i "s:\':\'\':g" /tmp/pgmetrics_out.json
psql -U grafana --no-password --command="INSERT INTO pgmetrics.raw_metrics (collection_at,metrics_raw) values ($collection_at,'$(cat /tmp/pgmetrics_out.json)'::jsonb)"
