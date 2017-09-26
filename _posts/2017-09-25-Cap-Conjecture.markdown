---
layout: post
title: CAP theorem
date:   2017-09-25 12:00:00 -0500
categories: networking
excerpt_separator: <!--more-->
---

The CAP theorem states that it is impossible for a distributed data store to simultaneously provide more that tow of of three guarantees.

<!--more-->

### Consistency

Every read receives the most recent write or an error.

### Availability

Every request receives a response - without a guarantee that it contains the most resent result.

### Partition Tolerance

The system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes.

## Common misconceptions

The CAP conjecture is commonly misunderstood as a necessity to choose to abandon one of these at all times. The choice between consistency and availability is only necessitated when a network failure occurs. If there is no compromise in the network no trade-off has to be accepted.

## Explanation

1. Availability is achieved by replication of the data across different machines.

2. Consistency is achieved by updating several nodes before allowing further reads.

3. Total partitioning (or the complete isolation of one part of the system to another) is rare. When this happens there is a choice between high Availability (on nodes which allow updating on one node before all nodes, like NoSQL) and high Consistency (on systems that lock all the nodes before reads, like SQL Databases).

With the advent of cloud computing and high parity due to product offerings like CDNs, availability zones, auto-scaling, fault tolerant server clustering, and server management tools like Cowboy, the frequency of network partitioning is declining.

However, based on the recent AWS outages due to one developers bad commit and other large interruptions, the CAP conjecture still holds water.
