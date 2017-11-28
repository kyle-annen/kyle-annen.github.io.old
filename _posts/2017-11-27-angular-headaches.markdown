---
layout: post
title: Angular Headaches
date:   2017-11-27 12:00:00 -0500
categories: front-end
excerpt_separator: <!--more-->
---

![headache]({{ site.url  }}/assets/headache.jpg)

Front end frameworks for single page applications have become common with the rise of popularity of Angular, Vue.js and React. All are quite powerful, and have their own way of dealing with the various challenges presented when dealing with front-end applications such as dealing with state, componetizing functional groups, and handling the routing of the application in order to simulate navigation between pages.

Recently I have worked on a number of projects, some of which utilize Angular (Angular 2/3/4, not AngularJS) and I have encountered a few gotchas that I think are worth relating.

<!--more-->

## Component Inheritance

Keeping it DRY with Angular is not always as straight-forward as it would first seem. Component inheritance is very appealing, however after dealing with the complexity of testing in Angular, it becomes more about the ability to test a component rather than small-to-medium reductions in code duplication.

It would seem that the Angular style guide and file structure where created with these difficulties in mind, however now that I have seen difficulties with the sub classing of Angular components it will change how I decide to move forward with Angular component inheritance.

## Testing with TestBed

I have also encountered some significant difficulties when a component is tested without utilizing TestBed. The types and extensive inheritance throughout an Angular application makes the manual creation of mocks extremely time consuming and inefficient. At first it seems simple, yet eventually the realization dawns that the inheritance chain is too deep to quickly create mocks.

With the brief insight gained from attempting to create a mock in one test, I can only guess that TestBed was created to alleviate this exact issue.

## Read the Errors

The times where I was very stuck, trying inane things time and time again and going down rabbit holes were without fail caused by either not reading the error logs or by not asking for colleague assistance when I was stuck.

## Listen to Yourself

Similar to the above, and also similarly as unrelated to the specifics of Angular, it is important to listen to yourself when a work-around, compromise or bad feeling about a block of code sets in. Each of the time I or my pair had this feeling we later rewrote the block, most often out of necessity.

Turns out there is a reason for the dread. Workarounds and hacks don't adhere to good coding practices and end up causing more pain, and likely do not adhere to Solid design principles.
