#!/bin/sh

pgmetrics --host=$SOURCE_HOST --no-password --no-pager --all-dbs --format=json --output=/tmp/pgmetrics_out.json
collection_at=$(grep '"at":' /tmp/pgmetrics_out.json | cut -d":" -f2 | cut -d"," -f1)
sed -i "s:\':\'\':g" /tmp/pgmetrics_out.json
echo "INSERT INTO pgmetrics.raw_metrics (collection_at,metrics_raw, cluster_name) values ($collection_at,'$(cat /tmp/pgmetrics_out.json)'::jsonb,'$SOURCE_HOST')" > /tmp/pgmetrics_insert.sql
psql -U grafana --no-password --file /tmp/pgmetrics_insert.sql
rm -f /tmp/pgmetrics_out.json
rm -r /tmp/pgmetrics_insert.sql
