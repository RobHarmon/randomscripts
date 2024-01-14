
WITH
  ltv AS (
    select
      ltv.*,
      acc.name as acc_name,
      acc.shipping_country,
      acc.region,
      app.name as app_name,
      app.platform,
      app.app_slug,
      app.owner_account
    FROM
      ltv
      LEFT JOIN owned_apps AS app ON ltv.app_id = app.app_slug
      LEFT JOIN account AS acc ON acc.id = app.owner_account
  )
SELECT
  ltv.app_name AS "ltv.app_name",
  ltv.media_source AS "ltv.media_source",
  ltv.acc_name AS "ltv.acc_name",
  ltv.shipping_country AS "ltv.shipping_country",
  ltv.region AS "ltv.region",
  ltv.platform AS "ltv.platform",
  COALESCE(
    SUM(
      CASE
        WHEN (ltv.attribution_type = 'install') THEN ltv.clicks_count
        ELSE NULL
      END
    ),
    0
  ) AS "ltv.total_clicks_count",
  COALESCE(
    SUM(
      CASE
        WHEN (ltv.attribution_type = 'install') THEN ltv.impressions_count
        ELSE NULL
      END
    ),
    0
  ) AS "ltv.total_impressions_count",
  COALESCE(SUM(ltv.inappevents_count), 0) AS "ltv.total_inappevents_count",
  COALESCE(SUM(ltv.launches_count), 0) AS "ltv.total_launches_count",
  COALESCE(
    SUM(
      CASE
        WHEN (ltv.attribution_type = 'install') THEN ltv.installs_count
        ELSE NULL
      END
    ),
    0
  ) AS "ltv.total_noi_count"
FROM
  ltv
WHERE
  (
    (
      (ltv.ltv_timestamp_date) >= (TIMESTAMP '2018-03-01')
      AND (ltv.ltv_timestamp_date) < (TIMESTAMP '2018-04-07')
      AND media_source = '2de974d26c1f67fb980e23a460835718'
    )
  )
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6
ORDER BY
  7 DESC;


