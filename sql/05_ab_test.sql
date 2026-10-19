-- Marketing Campaign Analysis
-- 05. The A/B test: questions 9 to 11
--
-- The 'ad' group saw adverts; the 'psa' group saw a public service
-- announcement in the same place. If the ad group bought more often,
-- the ads are the reason.

-- Q9. Did the ad group buy more often? (converted::int turns true into 1)
SELECT test_group,
       COUNT(*) AS users,
       SUM(converted::int) AS buyers,
       ROUND(100.0 * SUM(converted::int) / COUNT(*), 2) AS conversion_pct
FROM ab_test
GROUP BY test_group;

-- Q10. Is the difference real? Two-proportion z-test.
-- A z-score above 1.96 means less than a 5% chance the gap is luck.
-- Expected: 2.55% against 1.79%, lift 43.1%, z-score 7.37
WITH g AS (
  SELECT SUM(CASE WHEN test_group = 'ad' THEN 1 ELSE 0 END)::numeric AS n_ad,
         SUM(CASE WHEN test_group = 'ad' AND converted THEN 1 ELSE 0 END)::numeric AS x_ad,
         SUM(CASE WHEN test_group = 'psa' THEN 1 ELSE 0 END)::numeric AS n_psa,
         SUM(CASE WHEN test_group = 'psa' AND converted THEN 1 ELSE 0 END)::numeric AS x_psa
  FROM ab_test
),
r AS (
  SELECT x_ad / n_ad AS p_ad,
         x_psa / n_psa AS p_psa,
         (x_ad + x_psa) / (n_ad + n_psa) AS p_all,
         n_ad, n_psa
  FROM g
)
SELECT ROUND(100 * p_ad, 2) AS ad_pct,
       ROUND(100 * p_psa, 2) AS psa_pct,
       ROUND(100 * (p_ad - p_psa), 2) AS difference_points,
       ROUND(100 * (p_ad - p_psa) / p_psa, 1) AS lift_pct,
       ROUND((p_ad - p_psa) / SQRT(p_all * (1 - p_all) * (1 / n_ad + 1 / n_psa)), 2) AS z_score
FROM r;

-- Q11. On which day do ads work best?
SELECT most_ads_day,
       COUNT(*) AS users,
       ROUND(100.0 * SUM(converted::int) / COUNT(*), 2) AS conversion_pct
FROM ab_test
WHERE test_group = 'ad'
GROUP BY most_ads_day
ORDER BY conversion_pct DESC;
