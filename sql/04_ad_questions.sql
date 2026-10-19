-- Marketing Campaign Analysis
-- 04. The marketing maths rules, then questions 1 to 8 on the ad data
--
-- Return on investment assumes each sale is worth 100 (not in the data).

-- Rule 1. Divide the totals, never average the rates.
-- Expected: 40.55 (wrong) and 54.41 (the true cost per sale)
SELECT ROUND(AVG(spent / NULLIF(sales, 0)), 2) AS average_of_ratios,
       ROUND(SUM(spent) / SUM(sales), 2)       AS ratio_of_totals
FROM ads;

-- Rule 2. Guard every division with NULLIF so a zero gives a blank, not an error.
-- Expected: 6.24, 15.81 and 63.83
SELECT campaign,
       ROUND(SUM(spent) / NULLIF(SUM(sales), 0), 2) AS cost_per_sale
FROM ads
GROUP BY campaign
ORDER BY campaign;

-- Rule 3. Multiply by 100.0, not 100: whole numbers divide into a whole number.
-- Expected: 0 (wrong) and 0.018
SELECT SUM(clicks) / SUM(impressions) AS without_decimal,
       ROUND(100.0 * SUM(clicks) / SUM(impressions), 3) AS with_decimal
FROM ads;

-- Q1. Totals and overall return
SELECT SUM(impressions) AS impressions,
       SUM(clicks) AS clicks,
       ROUND(SUM(spent), 2) AS spend,
       SUM(enquiries) AS enquiries,
       SUM(sales) AS sales,
       ROUND(100.0 * SUM(clicks) / SUM(impressions), 3) AS ctr_pct,
       ROUND(SUM(spent) / SUM(clicks), 2) AS cost_per_click,
       ROUND(SUM(spent) / SUM(sales), 2) AS cost_per_sale,
       ROUND(100.0 * (SUM(sales) * 100 - SUM(spent)) / SUM(spent), 1) AS roi_pct
FROM ads;

-- Q2. Performance by campaign
SELECT campaign,
       COUNT(*) AS ads,
       ROUND(SUM(spent), 2) AS spend,
       SUM(clicks) AS clicks,
       SUM(sales) AS sales,
       ROUND(SUM(spent) / NULLIF(SUM(clicks), 0), 2) AS cost_per_click,
       ROUND(SUM(spent) / NULLIF(SUM(sales), 0), 2) AS cost_per_sale,
       ROUND(100.0 * (SUM(sales) * 100 - SUM(spent)) / NULLIF(SUM(spent), 0), 1) AS roi_pct
FROM ads
GROUP BY campaign
ORDER BY roi_pct DESC;

-- Q3. Share of spend against share of sales (SUM(...) OVER () = grand total)
SELECT campaign,
       ROUND(100.0 * SUM(spent) / SUM(SUM(spent)) OVER (), 1) AS share_of_spend_pct,
       ROUND(100.0 * SUM(sales) / SUM(SUM(sales)) OVER (), 1) AS share_of_sales_pct
FROM ads
GROUP BY campaign
ORDER BY share_of_spend_pct DESC;

-- Q4. Cost per sale and return by age group
SELECT age,
       ROUND(SUM(spent), 2) AS spend,
       SUM(sales) AS sales,
       ROUND(SUM(spent) / NULLIF(SUM(sales), 0), 2) AS cost_per_sale,
       ROUND(100.0 * (SUM(sales) * 100 - SUM(spent)) / NULLIF(SUM(spent), 0), 1) AS roi_pct
FROM ads
GROUP BY age
ORDER BY age;

-- Q5. Cost per sale and return by gender
SELECT gender,
       ROUND(SUM(spent), 2) AS spend,
       SUM(sales) AS sales,
       ROUND(SUM(spent) / NULLIF(SUM(sales), 0), 2) AS cost_per_sale,
       ROUND(100.0 * (SUM(sales) * 100 - SUM(spent)) / NULLIF(SUM(spent), 0), 1) AS roi_pct
FROM ads
GROUP BY gender
ORDER BY gender;

-- Q6. Return by interest (interests with at least 1,000 spend)
SELECT interest,
       ROUND(SUM(spent), 2) AS spend,
       SUM(sales) AS sales,
       ROUND(SUM(spent) / NULLIF(SUM(sales), 0), 2) AS cost_per_sale,
       ROUND(100.0 * (SUM(sales) * 100 - SUM(spent)) / NULLIF(SUM(spent), 0), 1) AS roi_pct
FROM ads
GROUP BY interest
HAVING SUM(spent) >= 1000
ORDER BY roi_pct DESC;

-- Q7. Spend on ads that produced no sale
SELECT COUNT(*) AS ads_with_no_sale,
       ROUND(SUM(spent), 2) AS spend_on_them,
       ROUND(100.0 * SUM(spent) / (SELECT SUM(spent) FROM ads), 1) AS share_of_spend_pct
FROM ads
WHERE sales = 0;

-- Q8. The audiences to cut: 24 segments from most to least expensive per sale,
-- with running totals of spend and sales. Read down running_spend_pct until it
-- passes 30: everything above that line is the cut.
WITH seg AS (
  SELECT segment,
         SUM(spent) AS spend,
         SUM(sales) AS sales,
         SUM(spent) / NULLIF(SUM(sales), 0) AS cost_per_sale
  FROM ads
  GROUP BY segment
)
SELECT segment,
       ROUND(spend, 2) AS spend,
       sales,
       ROUND(cost_per_sale, 2) AS cost_per_sale,
       ROUND(100.0 * SUM(spend) OVER (ORDER BY cost_per_sale DESC NULLS FIRST, segment)
             / SUM(spend) OVER (), 1) AS running_spend_pct,
       ROUND(100.0 * SUM(sales) OVER (ORDER BY cost_per_sale DESC NULLS FIRST, segment)
             / SUM(sales) OVER (), 1) AS running_sales_pct
FROM seg
ORDER BY cost_per_sale DESC NULLS FIRST, segment;
