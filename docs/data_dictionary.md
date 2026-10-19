# Data dictionary

The two tables are separate in Power BI, with no relationship: they describe different things.

## ads (built in 03_build_ads.sql)

| Column | Type | Meaning |
| --- | --- | --- |
| ad_id | integer | Unique ID for each ad |
| campaign | text | Campaign 916, Campaign 936 or Campaign 1178 |
| age | text | Age group shown the ad: 30-34, 35-39, 40-44 or 45-49 |
| gender | text | Male or Female |
| interest | integer | Code for the audience's interest (meanings not published) |
| segment | text | Campaign, age and gender together; 24 in total |
| impressions | integer | Times the ad was shown |
| clicks | integer | Clicks on the ad |
| spent | numeric | Amount paid for the ad (no currency given) |
| enquiries | integer | People who enquired after seeing the ad |
| sales | integer | People who bought after seeing the ad |

## ab_test (loaded as is in 01_create_tables.sql)

| Column | Type | Meaning |
| --- | --- | --- |
| row_no | integer | Row number from the file (not used) |
| user_id | integer | Unique ID for each person |
| test_group | text | `ad` if the person saw adverts, `psa` if they saw a public service announcement instead |
| converted | boolean | True if the person bought |
| total_ads | integer | Number of ads the person saw |
| most_ads_day | text | Day of the week they saw the most ads |
| most_ads_hour | integer | Hour of the day they saw the most ads |

## Marketing measures

| Measure | Formula | Overall |
| --- | --- | --- |
| Click-through rate | clicks ÷ impressions | 0.018% |
| Cost per click | spend ÷ clicks | 1.54 |
| Sales per 100 clicks | sales ÷ clicks × 100 | 2.83 |
| Cost per sale | spend ÷ sales | 54.41 |
| Revenue | sales × sale value (100, assumed) | 107,900 |
| Return on investment | (revenue − spend) ÷ spend | 83.8% |

Every rate divides one total by another. Averaging the per-ad rates gives a cost per sale of 40.55, which is wrong: it treats an ad that spent 2 the same as one that spent 600, and skips every ad with no sale.
