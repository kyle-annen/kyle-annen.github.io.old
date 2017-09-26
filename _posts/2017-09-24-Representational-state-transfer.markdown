---
layout: post
title: Representational state transfer
date:   2017-09-24 12:00:00 -0500
categories: networking
excerpt_separator: <!--more-->
---

REST, or representational state transfer, is a method of communicating between nodes on a network using stateless textual representations of resources using a uniform set of operations.

<!--more-->

Roy Fielding developed REST as a compliment to HTTP/1.1, and defined it's implementation in his 2000 PHD dissertation at UC Irvine. The dissertation outlines the architecture of the web and a stateless standard of communication.  The dissertation, "Architectural Styles and the Design of Network-based Software Architectures", is incredibly in depth and serves as one of the foundations for our thought patterns around modern stateless communication. While many of the ideas and descriptions are widely shared among the tech community in daily discourse, it is intriguing and informing at a more foundational level to read the thought patterns of the visionaries of the modern internet.

The dissertation is available in it's entirety [here][ucpaper].


>  Throughout the HTTP standardization process, I was called on to defend the design choices of the Web. That is an extremely difficult thing to do within a process that accepts proposals from anyone on a topic that was rapidly becoming the center of an entire industry. I had comments from well over 500 developers, many of whom were distinguished engineers with decades of experience, and I had to explain everything from the most abstract notions of Web interaction to the finest details of HTTP syntax. That process honed my model down to a core set of principles, properties, and constraints that are now called REST.

>>  Roy Fielding

# Architectual constraints

There are six main constraints described in the dissertation. As REST is not a technology, standard, but rather a set of guiding principles outlining behavior of stateless communion, the constraints below serve to promote many of the standards and practices in use today.

### Client-server architecture

Separating the client and server into independent components allows not only a separation of concerns, it also allows them to develope and evolve independently.

### Statelessness

Elimination of any persistent state on the server between request and all data necessary for the transaction is contained within the client request. Any persistent state is transferred to a database in order to facilitate authentication, but no persistent state should be in the server. This state of the application sent to the client should contain all the links to represent any request the client is able to make in order to initiate the next transaction.

### Cacheability

As cacheing was beginning to proliferate, the dissertation outlines how each transaction should contain information regarding now it should be cached, and when the caching should expire. Any information that changes rapidly should not be cached, whereas information that changes infrequently should be cached for a greater period of time. This provides for potentially huge savings in the number of transactions on highly requested resources.

### Layered system

A client should not know how many hopes are between it and the server, this allows for increased security and the possibility of load balancing.

### Code on demand

Code on demand was stated as optional in the dissertation, however the modern web has taken this notion and gone bananas.  Code on demand is the nature of the modern web, even simple websites have complex one page applications. React, Angular, Vue and Ember (to name a few) make up massive swaths of todays internet ecosystem. Seems like this is not so optional anymore.

### Uniform interface

This includes the use of HTML, XML, JSON.  Then definition of a uniform interface allows of abstraction and independence for the servers internal data representation. This simplifies the clients architecture and allows for wider information exchange, the democratization of information.

[ucpaper]:https://www.ics.uci.edu/~fielding/pubs/dissertation/fielding_dissertation.pdf
