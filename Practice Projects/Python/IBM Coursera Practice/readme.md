# Automobile Data Analysis Project 
---
## Libraries Used:
---
   * numpy
   * pandas
   * matplotlib
   * seaborn
   * sklearn.pipeline
   * sklearn.preprocessing

## Steps Taken:
---
   1. Header Creation for Dataset:
      Defined headers for the dataset to facilitate data processing.
   2. Replacing '?' with NaN:
      Replaced all '?' entries with NaN to handle missing values more effectively.
   3. Evaluating Missing Values:
      * Used isnull() to evaluate missing values in the dataset.
      * Counted missing values in each column.
   4. Calculating and Replacing Mean Values:
      * Calculated the mean value for the "normalized-losses," "bore," "horsepower," and "peak-rpm" columns.
      * Replaced NaN with mean values in these columns.
   5. Calculating Most Common Type for Number of Doors:
      Used .idxmax() to determine the most common number of doors.
   6. Dropping Rows Without Price Data:
      Removed all rows that lacked price data to ensure accurate analysis.
   7. Data Type Conversion:
      Converted the data type of certain columns for further analysis, e.g., converting "highway-mpg" to "highway-L/100km."
   8. Data Normalization and Binning:
      Applied data normalization and binning techniques to standardize data.
   9. Histogram of Horsepower:
      Plotted the histogram of horsepower to visualize its distribution.
  10. Correlation Analysis:
      Calculated correlations between numeric values and created a correlation heatmap.
  11. Linear Regression Analysis:
      * Explored positive linear regression by plotting "engine-size" vs. "price."
      * Investigated negative linear regression by plotting "highway-mpg" vs. "price."
      * Analyzed weak linear relationships by plotting "peak-rpm" vs. "price."
  12. Box Plots for Categorical Variables:
      Used box plots to visualize categorical variables and identify outliers, e.g., "body-style" vs. "price," "engine-location" vs. "price," and "drive-wheels" vs. "price."
  13. Descriptive Statistical Analysis:
      Employed the describe() function for statistical analysis of the dataset.
  14. Grouping and Pivot Tables:
      Learned the concept of grouping and created pivot tables in Python.
  15. Correlation Types:
      Explored different correlation types such as Pearson correlation and p-value concepts.
  16. Residual Plots:
      Created residual plots to assess the fit of regression models.
  17. Multiple Linear Regression:
      Implemented multiple linear regression to understand relationships between multiple variables.
  18. Polynomial Regression and Pipelines:
      Learned polynomial regression and how to use pipelines for efficient data processing.
  19. Evaluation Metrics:
      Studied R-squared and Mean Squared Error (MSE) for model evaluation.
  20. Model Selection:
      Determined when to use Simple Linear Regression (SLR), Multiple Linear Regression (MLR), and Polynomial Fit based on the data.

## Key Insights:
   * The analysis provided a comprehensive understanding of various factors affecting car prices.
   * Visualizations and statistical models highlighted important trends and relationships within the dataset.
