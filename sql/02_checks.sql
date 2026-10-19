-- Marketing Campaign Analysis
-- 02. Data checks on both files
--
-- Each check fills a row of docs/cleaning_log.md.

-- Check A. Repeated ads. Expected: 0
SELECT COUNT(*) - COUNT(DISTINCT ad_id) AS duplicate_ads
FROM ads_raw;

-- Check B. Ad rows with any blank value. Expected: 0
SELECT COUNT(*) AS rows_with_a_blank
FROM ads_raw
WHERE NOT (ads_raw IS NOT NULL);

-- Check C. Values that cannot be true. Expected: 0
SELECT COUNT(*) AS impossible_rows
FROM ads_raw
WHERE clicks > impressions
   OR approved_conversion > total_conversion
   OR spent < 0;

-- Check D. Ads with no clicks. Expected: 207 ads, 212 enquiries, 76 sales, 0 spend
SELECT COUNT(*) AS zero_click_ads,
       SUM(total_conversion) AS their_enquiries,
       SUM(approved_conversion) AS their_sales,
       SUM(spent) AS their_spend
FROM ads_raw
WHERE clicks = 0;

-- Check E. Experiment rows and repeated users. Expected: 588,101 and 0
SELECT COUNT(*) AS experiment_rows,
       COUNT(*) - COUNT(DISTINCT user_id) AS duplicate_users
FROM ab_test;

-- Check F. Experiment rows with any blank value. Expected: 0
SELECT COUNT(*) AS rows_with_a_blank
FROM ab_test
WHERE NOT (ab_test IS NOT NULL);
