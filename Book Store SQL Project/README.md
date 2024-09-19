
# Book Store Sales Data Analysis

In this project, I conducted a thorough analysis of book store sales and staff data to gain insights into various aspects of the business.


## Tool used
MySQL

## Steps Taken
1. book_store_sales database is created
2. all csv files are imported
3. ER (entity relationship diagram) is built.
4. Questions were answered using- joins, view, Common Table Expression (CTE), windows functions like- row_number(), dense_rank(), and recursive queries

## Questions which are answered using sql queires

* __Easy__
   1. Which book is the most expensive, mention it's category and 
      brand?
   2. Which is the most bought book?
   3. Who are the top 5 customers?
   4. Create a view called "ContactList" that consists of a book's title, along with the brand name.
&nbsp;
  - - - -
* __Moderate/Advanced__

    5. What are the most expensive books according to category and 
       brand name?
   6. What are the most popular books in each city?
   7. What books are least preferred by the readers according to 
      category?
   8. Generate a hierarchical tree of the staff. For each employee 
      showcase all the employee’s working under them (including 
      themselves) 
   9. show staff details along with their managers nam

## ER Diagram-
![Data Model]([http://url/to/image.png](https://drive.google.com/file/d/1cXwABR9GJ60u93sGIHx9xyN_T7UVd9FS/view?usp=sharing))

## Analysis:
   1. Sales Data Analysis:
       * Category: Examined sales figures across different book categories to identify the most and least popular genres.
       * Brand: Analyzed sales performance by book brands to determine which publishers had the highest sales.
       * Customer: Assessed customer purchase patterns to identify high-value customers and understand their preferences.
       * City: Evaluated sales distribution across various cities to determine regional sales trends and identify key markets.
   2. Staff Data Analysis:
      Utilized recursive queries to analyze the hierarchical relationships within the store’s staff, such as reporting structures and supervisory roles.
   3. Entity Relationship Diagram (ERD):
      Constructed an ERD to illustrate the relationships between different tables in the database, such as sales, staff, customers, and products. This helped in 
      understanding the data structure and ensuring efficient data management

 ## Key Learnings
1. How to create Entity Relationship Diagram
2. How to create view
3. Recursive query use case

## Outcome
The combined analysis of sales and staff data provided comprehensive insights into the operational and financial aspects of the book store, aiding in strategic decision-making and performance optimization.
      
