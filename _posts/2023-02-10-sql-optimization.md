---
layout: post
title: SQL Optimization  
date: 2023-02-13 00:00:00 
description: SQL optimization is the process of improving the performance of Structured Query Language (SQL) statements used in a database management system.
image:
  path: /assets/img/sql-optimization.png 
tags: [Productivity, Optimization, SQL] # add tag
categories: [Software Development]
published: true
---
SQL optimization is the process of improving the performance of Structured Query Language (SQL) statements used in a database management system. It is a critical aspect of database administration and development, as it can have a significant impact on the speed and efficiency of data retrieval and manipulation operations. In this article, we will explore some of the key concepts and techniques used in SQL optimization.

### 1. Indexing
One of the most important techniques for optimizing SQL statements is indexing. An index is a data structure that allows for faster searching and retrieval of data from a table. Indexes are created on specific columns in a table, and they allow the database management system to quickly find the rows that match a certain condition, without having to scan the entire table.

To optimize a query, it is important to create indexes on columns that are frequently used in the WHERE clause of SQL statements. It is also important to choose the appropriate type of index for the data in the column. For example, a column that contains only unique values may be better suited for a unique index, while a column with many duplicate values may benefit from a non-unique index.

### 2. Normalization
Another important aspect of SQL optimization is normalization. Normalization is the process of organizing data into separate tables, with each table containing only the data required to support a specific aspect of the application. The goal of normalization is to reduce data redundancy, minimize data anomalies, and improve data integrity.

Normalization can greatly improve the performance of SQL statements by reducing the amount of data that needs to be processed. When data is stored in normalized tables, it is easier to write efficient SQL statements that retrieve only the data that is needed, rather than processing large amounts of irrelevant data.

### 3. Caching
Caching is a technique that involves storing data in memory so that it can be quickly retrieved, rather than reading it from disk each time it is needed. Caching can significantly improve the performance of SQL statements, as it reduces the amount of time required to retrieve data from disk and increases the speed of data retrieval.

In database management systems, caching is typically implemented at the query level, where results from frequently executed queries are stored in memory for fast retrieval. This can greatly improve the performance of applications that execute the same SQL statements multiple times.

### 4. Query Tuning
Query tuning is the process of modifying SQL statements to make them run faster and more efficiently. This can be done by optimizing the structure of the SQL statements themselves, such as using the appropriate join type, or by adjusting the configuration of the database management system to improve performance.

To optimize a query, it is important to understand how the database management system executes SQL statements and the impact of different query structures on performance. For example, a join operation that retrieves data from multiple tables can be optimized by using an index on the columns being joined, or by using a different type of join operation that is more efficient for the specific data set.

## Quick Tips to Note

### 1. regexp_extract
The `regexp_extract` function in SQL can be used to replace the traditional `CASE-WHEN-LIKE` statement for pattern matching. This function allows you to extract a specific portion of a string that matches a regular expression pattern. The regexp_extract function is faster and more efficient than using a CASE-WHEN-LIKE statement, as it is optimized for regular expression pattern matching.

Here is an example of how to use the regexp_extract function to extract a specific portion of a string in a column:
```sql
WITH data AS (
  SELECT 'first_name' AS col_name, 'John Doe' AS value UNION ALL
  SELECT 'last_name' AS col_name, 'Doe John' AS value UNION ALL
  SELECT 'email' AS col_name, 'johndoe@example.com' AS value
)

SELECT col_name, value, 
       regexp_extract(value, '(^[^ ]+) ([^ ]+)', 1) AS first_name, 
       regexp_extract(value, '(^[^ ]+) ([^ ]+)', 2) AS last_name
FROM data
```
In this example, the `regexp_extract` function is used to extract the first name and last name from the `value` column. The regular expression pattern `'(^[^ ]+) ([^ ]+)'` is used to match the first word in the string as the first name, and the second word in the string as the last name. The `1` and `2` parameters in the `regexp_extract` function indicate which capture group to extract.

It is also possible to use the `regexp_extract` function to perform the same pattern matching that would normally be done with a `CASE-WHEN-LIKE` statement. Here is an example:
```sql
WITH data AS (
  SELECT 'John Doe' AS name UNION ALL
  SELECT 'Jane Doe' AS name UNION ALL
  SELECT 'Jim Smith' AS name
)

SELECT name, 
       regexp_extract(name, '^John', 0) AS first_name
FROM data
```
In this example, the `regexp_extract` function is used to match the `'^John'` pattern in the `name` column. If the string starts with `'John'`, the `regexp_extract` function will return the matched string, otherwise it will return `NULL`. This can be used as a replacement for the traditional `CASE-WHEN-LIKE` statement, as it performs the same pattern matching operation.

### 2. regexp_like
The `regexp_like` function in SQL can be used to replace the traditional `LIKE` clause for pattern matching. The `regexp_like` function uses regular expressions to match patterns in strings, whereas the LIKE clause uses simple pattern matching with wildcard characters (e.g. `%` and `_`).

Here is an example of how to use the `regexp_like` function to match patterns in a column:
```sql
WITH data AS (
  SELECT 'John Doe' AS name UNION ALL
  SELECT 'Jane Doe' AS name UNION ALL
  SELECT 'Jim Smith' AS name
)

SELECT name
FROM data
WHERE regexp_like(name, '^J[oi].* D[oe]$');
```
In this example, the `regexp_like` function is used to match names that start with `'J'` followed by `'o'` or `'i'`, and end with `' D[oe]'`. This regular expression pattern is much more specific and flexible than what can be achieved with the `LIKE` clause.

Using the `regexp_like` function can be more efficient than using the `LIKE` clause, as it is optimized for regular expression pattern matching. Additionally, it can provide a more concise and readable way to express pattern matching operations in your SQL code.

### 3. Always order your JOINs from largest tables to smallest tables
```sql
SELECT * FROM 
large_table
JOIN
small_table
ON small_table.id = large_table.id
```
In the above example we are ordering our JOIN to start with the table with many columns.

### 4. Convert long list of IN clause into a temporary table
When working with a long list of values in an `IN` clause, the query can become slow and unwieldy. In such cases, it can be more efficient to store the list of values in a temporary table and use a `JOIN` operation to compare values in the main table.

Here's an example of how you can convert a long list of values in an `IN` clause into a temporary table:
```sql
CREATE TEMPORARY TABLE temp_table (value INT);

INSERT INTO temp_table (value)
VALUES (1), (2), (3), ..., (N);

SELECT *
FROM main_table
JOIN temp_table ON main_table.column = temp_table.value;
```

In this example, we first create a temporary table `temp_table` with a single column `value` to store the list of values. We then insert the values into the temporary table using the `INSERT` statement. Finally, we use a `JOIN` operation to compare the values in the main table with the values stored in the temporary table.

By using a temporary table, we can simplify the query and reduce the overhead of a long list of values in an `IN` clause. This can result in faster query execution and improved performance for your SQL queries.

### 5. Avoid subquesries in WHERE clause
Using subqueries in the WHERE clause can have a negative impact on the performance of your SQL queries. This is because subqueries can be slow and can result in additional overhead in the form of additional query execution.

Here are some tips to avoid using subqueries in the WHERE clause:

1. Use JOINs instead of subqueries: If you need to compare values from two different tables, consider using a JOIN operation instead of a subquery. Joining tables can be more efficient than using a subquery, as it allows the database to process the comparison in a single query.

2. Use INNER JOINs: If you only need to return rows that have matching values in both tables, consider using an INNER JOIN. This will limit the number of returned rows to only those that have matching values in both tables, reducing the amount of data that needs to be processed.

3. Avoid using multiple subqueries: If you need to use multiple subqueries in the WHERE clause, consider using a single subquery instead. This can help reduce the overhead of multiple query executions and improve the performance of your SQL code.

4. Use pre-calculated values: If you need to perform calculations or transformations in the WHERE clause, consider using pre-calculated values instead of subqueries. This can reduce the overhead of additional query executions and improve the performance of your SQL code.

5. Use indexing: If you are using subqueries in the WHERE clause to search for specific values in a table, consider using indexing to improve the performance of your SQL code. An index can help the database quickly locate the desired values, reducing the overhead of additional query executions.

### 6. Use approx_distinct() instead of count(distinct) for very large datasets
When working with large datasets, using the `COUNT(DISTINCT)` function can result in slow query performance. In such cases, you can use the `APPROX_DISTINCT()` function instead to estimate the number of unique values in a column.

The `APPROX_DISTINCT()` function uses a statistical approximation algorithm to estimate the number of unique values in a column. This results in faster query execution and can be a more efficient solution when working with very large datasets.

Here's an example of how you 
```sql
SELECT APPROX_DISTINCT(column_name)
FROM table_name
```
Keep in mind that the `APPROX_DISTINCT(`) function is not an exact representation of the number of unique values in a column and the result may have some variability. However, it can provide a good estimate for large datasets and can significantly improve the performance of your SQL queries

### 7. Group By by the attribute/column with the largest number of unique entities/values
When using the GROUP BY clause, it is important to choose the right grouping column to ensure that the result of the query is meaningful and accurate. The performance of the query can also be impacted by the choice of the grouping column.

A good rule of thumb is to group by the attribute or column that has the largest number of unique entities or values. This is because grouping by a column with a large number of unique values reduces the number of groups and can result in faster query execution.
```sql
SELECT 
    category,
    sub_category,
    itemId,
    sum(price)
FROM
    table1
GROUP BY
    category, sub_category, itemId
```
In the above example, that a poor way to do the grouping, this because the column with the hightest unique values is itemId and not the category A proper way would be as below:
```sql
SELECT 
    category,
    sub_category,
    itemId,
    sum(price)
FROM
    table1
GROUP BY
    itemId, sub_category, category 
```


In conclusion, SQL optimization is a critical aspect of database administration and development that can greatly impact the performance of data retrieval and manipulation operations. By using techniques such as indexing, normalization, query tuning, and caching, database administrators and developers can ensure that their SQL statements are optimized for maximum performance and efficiency.