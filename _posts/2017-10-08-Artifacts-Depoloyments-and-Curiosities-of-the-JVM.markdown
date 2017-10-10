---
layout: post
title: Artifacts, Deployments, and Curiosities of the JVM
date:   2017-10-08 12:00:00 -0500
categories: JVM
excerpt_separator: <!--more-->
---

Most of my time employed as an apprentice is spent similarly to the few years prior to my apprenticeship, deeply engrossed in code.  I sometimes wondered if once I was employed as a programmer, would the love for programming and tinkering persist, or like some of my other interests wain with time after the new has worn off.

Thankfully I am now more immersed than ever, and convinced that it will take me a very long time indeed to grow tired of programming. The best part of programming is that every day more problems arise that need computer code to fix, and more technologies arise to help with the solution.

Sometimes, however, I do find myself completely baffled with an outcome of a change in code.  This week was one of those times.  This week I entered the weird zone.

<!--more-->

![old-halloween]({{ site.url }}/assets/old-halloween.jpg)

# Creepyy crawliesss

In order to deploy my Java http server, I had to change my groupid from the previous *com.github.kyle-annen* to *org.clojars.kyleannen*.  This was due to a number of reasons, but mostly due to some stringent requirements of Sonatype.

So, off to clojars and simple deployment.  After adjusting the packages and groupids to fit the new repository, I was ready to deploy. However no matter what I tried, I had multiple <span style="color: red; font-weight: bold;">red tests</span>.  Deploying with a <span style="color: red; font-weight: bold;">red state</span> is one of those rules that exist for a reason, so that was a no-go on the go-ahead.

Turns out the JVM had presented me with my very own October scare fest! And since the cause ended up a bit creepy, I thought nice photos from past all hallows eve's could set a proper mood.

![old-halloween2]({{ site.url }}/assets/old-halloween2.jpg)

# Digging deep

After hours of digging, I knew with a sinking sense of dread that I would have to do something that I really detest, retracing my steps.  Enter in the hero of the show: `git diff`.

I began by finding the most recent <span style="color: green; font-weight: bold;">green state</span>. I then painstakingly went through every line of code updated, updating them one at a time, committing and pushing up the commit, and awaiting the 5-10 minutes for TravisCI to run the integration tests.

Did I mention that the test only failed on Travis?

![old-halloween3]({{ site.url }}/assets/old-hallowen3.jpg)

# It gets creepier

After hours of the painful process, I found the cause of the failing tests.  While I detest retracing my steps, I am far more driven to not give up.

The culprit: the new groupid.

The failing test: an integration test that launches an instance of the server on a thread, and interacts with it on a bare-bones client.

I had found the culprit.  Changing the package name to have a different groupid caused the tests to fail.  It took quite a bit more tinkering to realize that due to this groupid change, the server thread was taking longer to spin up and be ready to accept connections on a server socket.

The fix: increase the `Thread.sleep()` to delay the client initiation.

# Even creepier

I had a feeling that this was a strange event.  I could not explain why a different groupid would cause this.  I asked around to see if anyone had seen this before, and sure enough everyone found it as creepy as I did.

Seems like the JVM may be the champion of halloween this year.
