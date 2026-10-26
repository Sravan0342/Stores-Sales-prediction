[Stores-Sales-prediction_README.md](https://github.com/user-attachments/files/33942081/Stores-Sales-prediction_README.md)
# Store Sales Prediction

An R project that predicts a department store's sales totals and compares several regression and machine learning models. Built for BANA 6610 (Statistics for Business Analytics).

## Dataset

- **File:** [`Store.csv`](Store.csv), 1,030 transactions with 16 variables, created for this project
- **Store locations:** Commerce City, Greeley and Louisville
- **Variables include:** invoice number, location, date, time, customer type (member or non-member), gender, product category, price per unit, quantity, 7% tax, total, payment method, cost before tax, gross margin, gross income and rating points

## Workflow

1. **Data preparation:** checked for missing values (none), cleaned column names with `janitor`, removed empty rows and columns, dropped duplicates and converted categorical columns to factors
2. **Exploratory analysis:** summary statistics, bar charts by location, scatter plots and correlation analysis (for example, quantity vs. gross income)
3. **Regression modeling:**
   - **SISO** (single input, single output): `total ~ price_unit`
   - **MISO** (multiple inputs, single output): several models adding quantity, location, time, gross income and rating points
   - Models compared with AIC; the main model is `total ~ price_unit + quantity`
   - A GLM version of the main model
4. **Machine learning models** with 10-fold cross-validation in `caret`, using RMSE as the metric:
   - Decision tree (CART)
   - k-Nearest Neighbors (kNN)
   - Random forest
5. **Model comparison** using `resamples()`, then predictions from each model

## Tech stack

R with `caret`, `tidyverse`, `dplyr`, `tidyr`, `ggplot2`, `janitor`, `psych`, `car`, `caTools`, `Amelia`, `scales`, `magrittr`

## How to run

1. Install the packages listed above, for example:
   ```r
   install.packages(c("caret", "tidyverse", "janitor", "psych", "car", "caTools", "Amelia", "scales", "randomForest"))
   ```
2. In `R code.R`, update the `setwd()` line to the folder that contains `Store.csv`.
3. Run the script in R or RStudio.

## Repository contents

| File | Description |
|---|---|
| `R code.R` | Data cleaning, analysis and modeling script |
| `Store.csv` | Store sales dataset |
| `Detailed_report.pdf` | Written report with outputs and interpretation |
| `SISO, MISO, KNN MEANS on sales prediction.pptx` | Presentation slides |

## Author

Sravan Tallam
