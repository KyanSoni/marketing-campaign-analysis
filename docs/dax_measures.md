# Power BI model and measures (DAX)

Power BI connects straight to PostgreSQL (Get data > PostgreSQL database, Import mode) and loads `ads` and `ab_test`. The two tables have no relationship.

## Sale value slider (what-if parameter)

Modeling > New parameter > Numeric range: name `Sale Value`, minimum 50, maximum 200, increment 10, default 100. Power BI creates the measure `Sale Value Value`, which holds the slider's current value.

## Ad measures (stored in the ads table)

Measure names start with "Total" because a measure cannot share a name with a column (`clicks`, `sales`).

```dax
Total Spend = SUM(ads[spent])
Total Clicks = SUM(ads[clicks])
Total Sales = SUM(ads[sales])
Cost per Click = DIVIDE([Total Spend], [Total Clicks])
Cost per Sale = DIVIDE([Total Spend], [Total Sales])
Revenue = [Total Sales] * [Sale Value Value]
ROI = DIVIDE([Revenue] - [Total Spend], [Total Spend])
Share of Spend = DIVIDE([Total Spend], CALCULATE([Total Spend], ALLSELECTED(ads)))
Share of Sales = DIVIDE([Total Sales], CALCULATE([Total Sales], ALLSELECTED(ads)))
```

## Experiment measures (stored in the ab_test table)

```dax
Users = COUNTROWS(ab_test)
Buyers = CALCULATE(COUNTROWS(ab_test), ab_test[converted] = TRUE())
Conversion Rate = DIVIDE([Buyers], [Users])
```

## Card labels

These show numbers in full on the cards (for example 58,705 rather than 59K).

```dax
Spend Label = FORMAT([Total Spend], "#,0")
Sales Label = FORMAT([Total Sales], "#,0")
```

## How they work

- Every rate divides one total by another. Dragging a ready-made rate column onto a chart would average it and give the wrong answer.
- `ALLSELECTED(ads)` means "the total for everything the slicers currently allow", so each campaign's share is a share of what is selected.
- Moving the slider to 50 drops ROI to about −8%: at 50 per sale, the ads lose money.
