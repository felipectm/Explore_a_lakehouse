bq query --use_legacy_sql=false \
'
#standardSQL
CREATE OR REPLACE EXTERNAL TABLE `thelook_gcda.product_returns`
OPTIONS (
format ="PARQUET",
uris = ['gs://sureskills-lab-dev/DAC2M2L4/returns/returns_*.parquet']
);
'

bq query --use_legacy_sql=false \
'
#standardSQL
SELECT COUNT(*) AS row_count
FROM `thelook_gcda.product_returns`;
'

bq query --use_legacy_sql=false \
'
#standardSQL
SELECT *
FROM `thelook_gcda.product_returns`
ORDER BY status_date desc
LIMIT 10;
'

bq query --use_legacy_sql=false \
'
#standardSQL
SELECT dc.name, pr.*
FROM `thelook_gcda.product_returns` AS pr
INNER JOIN `thelook_gcda.distribution_centers` AS dc
ON dc.id = pr.distribution_center_id;
'

bq query --use_legacy_sql=false \
'
#standardSQL
SELECT
dc.name AS distribution_center,
p.category,
COUNT(*) AS product_return_count
FROM `thelook_gcda.product_returns` AS pr
INNER JOIN `thelook_gcda.distribution_centers` AS dc
ON dc.id = pr.distribution_center_id
INNER JOIN `thelook_gcda.products` p
ON p.id = pr.product_id
WHERE p.category = "Jeans"
GROUP BY dc.name, p.category;
'

bq load --autodetect --source_format=CSV $DEVSHELL_PROJECT_ID:thelook_gcda.shirt_price_update gs://sureskills-lab-dev/DAC2M2L4/price_update/price_update_shirts.csv
