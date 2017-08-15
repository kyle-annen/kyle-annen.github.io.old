---
layout: post
title:  A/B Testing Breakdown
date:   2017-08-13 12:00:00 -0500
categories: testing telemetry data
excerpt_separator: <!--more-->
---

![doc]({{ site.url }}/assets/doc.jpg)

When companies claim to be data-driven, they are most likely speaking about testing and basing decisions on statistical analysis. 

It is one thing to claim being data-driven and to actually adhere to good statistical practices and experimental patterns. So what is an A/B test, how do we go about setting one up, and how do we test in a way that actually produces reliable results?

That is precisely what this blog is about!  

<!--more-->

# A/B testing

A/B testing, or split testing, is a form of experimental testing which uses two groups of randomly selected populations which are given different version of something to use. 

The results on usage are gathered, the statistical models applied, and a confidence ratio is given to determine if the results are statistically significant. 

It is extremely important to adhere to confidence ratios, as humans are apt to mistake correlation for causation, which has given the rise to numerous statistical formulas to assist in determining validity of outcomes. 

# A/B testing in e-commerce

Companies all over the world use A/B testing to improve conversion rate, usability and functionality of websites. 

A few companies that test voraciously are Amazon, Booking.com, and Etsy.  A/B testing in e-commerce is accomplished by serving two varying versions of a website or particular function of a website at random to a statistically significant population.  The versions which shows statistically significant benefits is adopted and the whole shebang starts again.

# Rules A/B testing

### 1. Define what success will be.

Prior to any testing, success must be defined before any data is given.  This could be determined by the about of revenue a feature would bring in compared to the cost to roll out the feature, or it could be used to prioritize between competing new features.  Once it is decided, the success definition cannot and should not change. 

An example of defining success could be a minimum of +5% conversion rate.

### 2. Find the minimum sample size

It is extremely important that the sample size be significant.  In order for significance, it must be randomly selected and have a minimum population. An awesome tool mat by Evan Miller can be used to explore the minimum sample size for an A/B test. [You can find his tool here.][sample-size]

### 3. Setup the A/B serving software and telemetry

A/B software is widely available which will serve two different versions of the website to the sample populations.  Some options are:

- [Split - Rails][split]
- [express-ab - JavaScript][expressab]
- [Proctor (indeed) - Java][proctor]
- [Many, many more.][more]

Telemetry is data emitted on event, which can be gathered and analyzed later.  This should be when someone exits a sales funnel, enters a sales funnel, and progresses further down the sales pipeline.  As with the A/B frameworks, many libraries exist to make telemetry emission as simple as a single line of code. 

Examples: 

- [Wasabi - Intuit - (Java)][wasabi]
- [Feature - Etsy (PHP)][feature]
- [Sixpack (Python)][sixpack]
- [Abba (Javascript)][abba]
- [Vanity (Rails)][vanity]

### 4. Run the tests to completion, do not observe

The test have to be run to completion.  Observing tests in real time is generally not a good idea, and tests should never be stopped early. 

### 5. Use a T-Test

A T-Test is used to compare two sets of outcomes and assigns a certainty to the outcome of the test. If the outcomes are too similar, then there is not significant outcome and the change is not worthwhile.

# Further reading 

Here are a few excellent posts about A/B testing if this post has piqued your curiosity. 

[A-B Testing Guide - Conversion Sciences][cs]

[Ultimate Guide to A/B Testing][sm]




[sample-size]: http://www.evanmiller.org/ab-testing/sample-size.html
[split]: https://github.com/splitrb/split
[expressab]: https://github.com/omichelsen/express-ab
[proctor]: https://github.com/indeedeng/proctor
[more]: https://www.google.com/search?safe=active&q=ab+testing+plugin&oq=ab+testing+plugin&gs_l=psy-ab.3..0j0i22i30k1l3.3754.4583.0.4820.6.6.0.0.0.0.103.511.4j2.6.0....0...1.1.64.psy-ab..0.6.509.X03gHL-TS3c
[cs]: https://conversionsciences.com/blog/ab-testing-guide/
[sm]: https://www.smashingmagazine.com/2010/06/the-ultimate-guide-to-a-b-testing/
[wasabi]: https://github.com/intuit/wasabi
[feature]: https://github.com/etsy/feature
[sixpack]: https://github.com/seatgeek/sixpack
[abba]: https://github.com/maccman/abba
[vanity]: https://github.com/assaf/vanity
