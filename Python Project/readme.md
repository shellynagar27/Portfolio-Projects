# IMDB Data Analysis Project

## Libraries Used:
   * numpy
   * pandas
   * matplotlib
   * seaborn
## Steps Taken
   1. Analyzed Structure of Dataset:
      Used info() function to understand the structure, data types, and non-null values of the dataset.
   2. Counted and Removed Null Values:
      * Counted missing values using isnull().sum().
      * Removed rows with missing values using dropna().
   3. Counted and Removed Duplicate Rows:
      * Identified duplicate rows using duplicated().sum().
      * Removed duplicate rows with drop_duplicates().
   4. Bar Chart for Movie Releases:
      Plotted a bar chart to analyze the number of movies released each year from 1920 to 2024.
   5. Minimum and Maximum Ratings:
      Identified the movies with the minimum and maximum ratings on IMDB.
   6. Categorical Analysis of Movies Based on Ratings:
      * Created bins for categorical analysis of movies based on their ratings.
      * Plotted a bar chart to show the number of movies in each rating category.
   7. Splitting Duration Column:
      Split the duration column to convert the data into minutes.
   8. Dropped Unnecessary Columns:
      Removed columns that were not needed for analysis.
   9. Total Duration vs Count of Movies:
      Plotted the total duration against the count of movies to visualize the distribution.
  10. Variation in Average Ratings Over Time:
      Used a line chart to show how average movie ratings have varied over the years.
  11. Movie Releases by Category:
      Plotted a bar chart to display how many movies were released in each genre/category.
## Key Insights:
   * The analysis provided a clear view of movie releases trends, rating distributions, and popular genres.
   * Visualizations helped in identifying patterns in the movie industry over the years.
