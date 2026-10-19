-- Marketing Campaign Analysis
-- 03. Build the tidy ads table
--
-- 'Campaign ' || id  turns 916 into "Campaign 916", so charts treat it as a name
-- gender             M/F spelled out as Male/Female
-- segment            one label per campaign, age and gender mix (24 in total)
-- enquiries, sales   clearer names for total_conversion and approved_conversion
-- fb_campaign_id is left out because it is not needed.

CREATE TABLE ads AS
SELECT ad_id,
       'Campaign ' || xyz_campaign_id AS campaign,
       age,
       CASE WHEN gender = 'M' THEN 'Male' ELSE 'Female' END AS gender,
       interest,
       'Campaign ' || xyz_campaign_id || ', ' || age || ', ' ||
         CASE WHEN gender = 'M' THEN 'Male' ELSE 'Female' END AS segment,
       impressions, clicks, spent,
       total_conversion AS enquiries,
       approved_conversion AS sales
FROM ads_raw;

-- Check. Expected: 1,143 ads, 58,705.23 spent, 1,079 sales
SELECT COUNT(*) AS ads, ROUND(SUM(spent), 2) AS spend, SUM(sales) AS sales
FROM ads;
