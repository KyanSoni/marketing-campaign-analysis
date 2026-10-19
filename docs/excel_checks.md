# Excel checks

Before loading the data into PostgreSQL, I worked out the headline marketing numbers by hand in a copy of the ad data (`explore.xlsx`, sheet `Data`). Everything after was checked against them.

| Cell | Formula | What it tells you | Result |
| --- | --- | --- | --- |
| B1 | `=COUNTA(Data!A:A)-1` | Number of ads | 1,143 |
| B2 | `=SUM(Data!I:I)` | Total spend | 58,705.23 |
| B3 | `=SUM(Data!H:H)` | Total clicks | 38,165 |
| B4 | `=SUM(Data!K:K)` | Total sales | 1,079 |
| B5 | `=B3/SUM(Data!G:G)` | Click-through rate | 0.018% |
| B6 | `=B2/B3` | Cost per click | 1.54 |
| B7 | `=B2/B4` | Cost per sale | 54.41 |
| B8 | `=(B4*100-B2)/B2` | Return on investment, at 100 per sale | 83.8% |
| B9 | `=COUNTIF(Data!H:H,0)` | Ads with no clicks | 207 |
| B10 | `=COUNTBLANK(Data!A1:K1144)` | Empty cells | 0 |
| B11 | `=SUMIF(Data!B:B,1178,Data!I:I)/B2` | Campaign 1178's share of spend | 94.8% |

B8 is the key formula: sales times 100 is the money that came in; take away what was spent, then divide by what was spent.

A pivot table of spend and sales by campaign showed Campaign 1178 with about 55,662 spent for 872 sales, against 2,893 for 183 in Campaign 936 and 150 for 24 in Campaign 916.
