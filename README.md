ToSequel
========

The primary objective of tosequel is to make the conversion of a formatted file
to SQL statements as painless as possible.

Too many hours are spent fixing CSV files, modifying tables, or filtering data
in order to load sample data into a table. Mostly by trial and error.

ToSequel will take a CSV file, determine the required column width, create
appropriate DDL statements, and create escaped insert statements to load the data.
