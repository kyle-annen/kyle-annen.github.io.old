---
layout: post
title:  Not Your Grandad's CIDR - Classless Inter-Domain Routing
date:   2017-09-04 12:00:00 -0500
categories: Solid
excerpt_separator: <!--more-->
---

![ciderpress]({{ site.url }}/assets/ciderpress.jpg)


CIDR, or Classless Inter-Domain Routing is used to allocate blocks of IP addreses and for IP address routing.  CIDR is a classless solution to the issues with classful network scheme of allocating IP addresses which dominated the first decade of the internet.

While this is a brief overview of what CIDR is and why it exists, it is also incredibly opaque if one does not have a background in networking technologies.

In this blog we will be covering what CIDR is, the problems to which CIDR was the cure, and finally an overview of CIDR notation.

<!--more-->


![gentlemen]({{ site.url  }}/assets/gentlemen.jpg)

# Classful domain routing

From 1986 to 1993 IP addresses where allocated in ranges based on the most significant bits of the IP address, which is the bits furthest to the left of the IP address. IP address's where broken up into three main classes, Class A, Class B, and Class C.

Class A was classified as all networks in which the most significant bit was 0.  We can look at the example IP address below.

```
1.0.0.0
```

This IP address is in the Class A range, which begins at `0.0.0.0` and ends with `127.255.255.255`. This range is defined by the most significant bit in the IP address being 0.  If we convert the IP address to binary instead of decimal, it is easier to see what is meant by the most significant bit.

```
Starting Range:
0000 0000.0000 0000.0000 0000.0000 0000
```

```
Ending Range:
0111 1111.1111 1111.1111 1111.1111 1111
```

The `0` all the way to the left of the IP addresses is the most significant bits, and reserves half of all IP addresses to a total of 128 networks.  If this seems low, your instincts are correct.  This limitation proved untenable within the first few years, and by the early 90s plans where being layed to offer a solution to the limitations set forth by classful domain addressing.


### Bit-wise representation

In the following table:
* **n** indicates a bit used for the network ID.
* **H** indicates a bit used for the host ID.
* **X** indicates a bit without a specified purpose.

Class A
```
  0.  0.  0.  0 = 00000000.00000000.00000000.00000000
127.255.255.255 = 01111111.11111111.11111111.11111111
                  0nnnnnnn.HHHHHHHH.HHHHHHHH.HHHHHHHH
```

Class B
```
128.  0.  0.  0 = 10000000.00000000.00000000.00000000
191.255.255.255 = 10111111.11111111.11111111.11111111
                  10nnnnnn.nnnnnnnn.HHHHHHHH.HHHHHHHH
```

Class C
```
192.  0.  0.  0 = 11000000.00000000.00000000.00000000
223.255.255.255 = 11011111.11111111.11111111.11111111
                  110nnnnn.nnnnnnnn.nnnnnnnn.HHHHHHHH
```

Class D
```
224.  0.  0.  0 = 11100000.00000000.00000000.00000000
239.255.255.255 = 11101111.11111111.11111111.11111111
                  1110XXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX
```

Class E
```
240.  0.  0.  0 = 11110000.00000000.00000000.00000000
255.255.255.255 = 11111111.11111111.11111111.11111111
                  1111XXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX
```
> Sourced from wikipedia


# A problem with scale

![problem with scale]({{ site.url }}/assets/problemwithscale.jpg)

If we examine the different groups as allocated by Class, and we think about the types of organizations and entities that exist in our society, we can see that there is a very large mismatch between the class sizes as defined by the classful system.

The largest block contains three full octet blocks worth of addresses.  This means that organizations with Class A allocations of IP addresses had 65,536 address at their disposal, a number to large for most organizations.  The smallest block is 8 bits, or 256 possible addresses, which is too small for most enterprises.  The linking to powers of two inherent to the binary address allocation by the least significant bit was simple in implementation but lacked any real addressing of the issues to come with a growing internet.

# Introducing CIDR

Classless inter-domain routing is based on variable length subnet masking (VLSM). Variable length subnet masking allows a network to be logically sized more appropriately based on the needs of the network.

Why do we care? CIDR notation is a method currently used in many cloud technologies to specify ranges of addresses. You can think of CIDR notation as the IP analog to RegEx and Strings, we can use a CIDR block to match a range of addresses.

CIDR notation uses the Decimal Dot Notation (similar to IP addresses in decimal dot notation) followed by a forward slash and a number indicating the number of leading 1 bits of the routing mask.

For example the following CIDR notation:

```
192.168.100.0/22
```
This CIDR block represents the IPv4 addresses 1024 IPv4 addresses from `192.168.100.0` to `192.168.103.255`.

The number following the slash in the CIDR block represents the host portion of the address.  Since there are 32 bits in an IPv4 address, we can take the total number of bits and subtract the number in the slash notation to find the number of addresses that are addresses in the above CIDR block.

```
32 - 22 = 10
```

That mean there sre 10 bits worth of addresses available. In binary `11 1111 1111`, and in decimal this is 1023, plus the zero value is 1024 total variations.

CIDR blocks can be used to set up specific routing tables in cloud technology, and is utilized by AWS extensibly.

# Interesting examples

A CIDR block can be used to indicate a range of addresses that are allowed to access a port. AWS uses this type of notation to set security groups permissions.  In order to allow all IP addresses, we would start with the lowest IP address `0.0.0.0` and uses CIDR notation to indicate that all bits of the IP are able to be addressed.

```
0.0.0.0/0
```

The above block indicates all IP addresses on the internet, and could be used to give wide open access to a port when configuring AWS security groups. Similarly you can assign a CIDR block that only allows a single address, by setting the number after the slash to leave no bits available. 

```
192.168.1.2/32
```

The CIDR block above refers to only the single IP address 192.168.1.2.

