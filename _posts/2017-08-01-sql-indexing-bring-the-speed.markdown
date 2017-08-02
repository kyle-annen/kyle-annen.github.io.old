---
layout: post
title:  "SQL Indexing - Bring the SPEED"
date:   2017-08-01 12:00:00 -0500
categories: sql database indexing db
excerpt_separator: <!--more-->
---

![sr71]({{ site.url }}/assets/sr71.jpg)

For most full stack developers, indexes are added when data aggregation or retrieval slows to a crawl.  

So, what actually happens when an **index** is created, and what situations merit the creation of an index?

<!--more-->

# Querying without an index

![bookpile]({{ site.url }}/assets/bookpile.jpg)

When a query is run, the database software has to find records that match the query.  Without an index it will simply have to check every record.  

This is like searching through a stack of books at the store pictured above, one at a time. 

Generally when building a full stack application the initial data in the database is quite small, so searching the entire data set may not take noticeably less time than a more optimized search method. 

If we look at the complexity of a linear search (like a non-indexed query) we see that it is linear. 


  ```O(n)```


This means that a linear query that executes in 0.05 seconds on the test database will perform differently on the production database which will be a thousand times larger and take 50 seconds to execute.

If the query has to be performed often, it may be time to optimize the database with indexing. 

# Indexed query speed

Creating and index in a SQL database or other ORM (Object Relational Mapping database) changes how the data is accessed.  

When index is created on a column, the database creates a data structure that stores the values in the target column. Commonly this is a B-Tree.  

***Small Aside***

## B-Tree

![boeing]({{ site.url }}/assets/1971boeing.jpg)
***Boeing 747 Qantas 1971***

The B-Tree was created by Rudolf Bayer and Ed McCreight in 1971 while working at Boeing Research Labs. The name was crafted over lunch. Ed explains his naming descision best.

> Bayer and I were in a lunchtime where we get to think [of] a name. And ... B is, you know ... We were working for Boeing at the time, we couldn't use the name without talking to lawyers. So, there is a B. [The B-tree] has to do with balance, another B. Bayer was the senior author, who [was] several years older than I am and had many more publications than I did. So there is another B. And so, at the lunch table we never did resolve whether there was one of those that made more sense than the rest. What really lives to say is: the more you think about what the B in B-trees means, the better you understand B-trees.

>> Ed McCreight, 2013

*If you would like to know more about Rudolf Bayer's works, there is a Scholarpedia article which he curated himself in 2008. It can be read over at [Scholarpedia.org][B-tree]*

*Ed McCreight can be reached through his website if you would like to take a first hand interest his works. You can find him at [McCreight.com][mccreight].*

## B-Tree Complexity

![btree]({{ site.url }}/assets/btree.png)

A B-Tree is a tree data structure that self-balances and has a log complexity. This means that the search time through the treed is drastically reduce. 

The graphic above is a representation of how a B-Tree search functions.

Below is the Big-O notation for a B-Tree search.

```O(log n)```

While the mathematical representation of search time is nice, sometimes it is truly helpful to see a graph of the execution time as values increase.  The execution time would be the y-axis, and the record count would be the x-axis. It is very apparent that the B-Tree, which is the blue line, is much faster. 

![graph]({{ site.url }}/assets/bigograph.png)

_Caveat: This is a purely mathematical graph, a real life graph of execution time will have more variability. However the illustration is useful to understand the vast difference in efficiently._

[B-tree]: http://www.scholarpedia.org/article/B-tree_and_UB-tree
[mccreight]: http://www.mccreight.com/people/ed_mcc/index.htm
