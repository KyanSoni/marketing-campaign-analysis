# Cleaning log

Every check comes from [sql/02_checks.sql](../sql/02_checks.sql). Both files were clean; the work was shaping and checking them.

| What I checked | Query | Result | What I did | Why |
| --- | --- | --- | --- | --- |
| Ad rows | 01_create_tables.sql | 1,143 | Kept all | One row per ad |
| Repeated ads | Check A | 0 | Nothing needed | Each ad appears once |
| Ad rows with a blank | Check B | 0 | Nothing needed | No missing values |
| Impossible values (more clicks than views, more sales than enquiries, negative spend) | Check C | 0 | Nothing needed | Clicks, sales and spend are consistent |
| Ads with no clicks | Check D | 207 ads, 212 enquiries, 76 sales, 0 spend | Kept | They cost nothing and still led to sales: people saw them and bought later |
| Experiment rows | Check E | 588,101 | Kept all | One row per person, none repeated |
| Experiment rows with a blank | Check F | 0 | Nothing needed | No missing values |
| Campaign IDs stored as numbers | By eye | 3 campaigns | Turned into names (Campaign 916) | So charts never add the IDs up |
| Value of a sale | Not in the data | 100 per sale | Assumed, with a slider on the dashboard | Needed to work out return |

## Checks against Excel and Power BI

| Measure | Excel | PostgreSQL | Power BI |
| --- | --- | --- | --- |
| Total spend | 58,705.23 | 58,705.23 | 58,705.23 |
| Total sales | 1,079 | 1,079 | 1,079 |
| Cost per click | 1.54 | 1.54 | 1.54 |
| Cost per sale | 54.41 | 54.41 | 54.41 |
| Return at 100 per sale | 83.8% | 83.8% | 83.8% |
