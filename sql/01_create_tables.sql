-- Marketing Campaign Analysis
-- 01. Create the raw tables and check the imports
--
-- After running this, import ads.csv into ads_raw and ab_test.csv into
-- ab_test (pgAdmin > Import/Export Data, Format csv, Header on).
-- NUMERIC keeps money exact; BOOLEAN holds true or false.

CREATE TABLE ads_raw (
  ad_id INTEGER,
  xyz_campaign_id INTEGER,
  fb_campaign_id INTEGER,
  age TEXT,
  gender TEXT,
  interest INTEGER,
  impressions INTEGER,
  clicks INTEGER,
  spent NUMERIC,
  total_conversion INTEGER,
  approved_conversion INTEGER
);

CREATE TABLE ab_test (
  row_no INTEGER,
  user_id INTEGER,
  test_group TEXT,
  converted BOOLEAN,
  total_ads INTEGER,
  most_ads_day TEXT,
  most_ads_hour INTEGER
);

-- Check both imports. Expected: 1,143 and 588,101
SELECT (SELECT COUNT(*) FROM ads_raw) AS ad_rows,
       (SELECT COUNT(*) FROM ab_test) AS experiment_rows;
