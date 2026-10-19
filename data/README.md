# Data

The data is not stored in this repository. Download both files from Kaggle (a free account is needed):

- **Ad data:** Sales Conversion Optimization
  https://www.kaggle.com/datasets/loveall/clicks-conversion-tracking
- **Experiment data:** Marketing A/B Testing
  https://www.kaggle.com/datasets/faviovaz/marketing-ab-testing

## How to prepare them

1. Download and unzip both files.
2. Rename the ad file (usually `KAG_conversion_data.csv`) to `ads.csv` and the experiment file (`marketing_AB.csv`) to `ab_test.csv`.
3. Do not open and save them in Excel; import the untouched files.
4. Run the files in [../sql](../sql) in number order, importing both CSVs after `01_create_tables.sql`.

## About the data

The two files come from different companies. In this project's story they belong to the same one, and the value of a sale (100) is an assumption.
