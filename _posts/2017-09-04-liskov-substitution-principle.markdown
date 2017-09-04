---
layout: post
title:  Solid - Liskov substitution principle
date:   2017-09-04 12:00:00 -0500
categories: Solid
excerpt_separator: <!--more-->
---

The Solid principles of software design are five principles that make up the pneumonic SOLID. Each of the letters stand for a different principle of object oriented design.

<span class="formula">$$S = Single\;responsibility\;principle$$</span><br/>
<span class="formula">$$O = Open/closed\;principle$$</span><br/>
<span class="formula">$$L = Liskov\;substitution\;principle$$</span><br/>
<span class="formula">$$I = Interface\;segregation\;principle$$</span><br/>
<span class="formula">$$D = Dependency\;inversion\;principle$$</span>

The Liskov Substitution principle states that functions that use pointers to base classes must be able to use objects of derived classes without knowing it. 

<!--more-->
In other words, we can define an abstract class, then every function or method that takes an implementation of the abstract class can not care about which implementation of the abstract class it is taking. 

So if we are to envision the functions of a program as either tubes which liquid can flow through or grates that spheres can roll down, the Liskov Substitution Principle is easier to understand. 

We start by implementing two abstract classes. `abstract Liquid` and `abstract Sphere`.  

The functions that take the class Liquid have tubes and keep the liquid from spilling.  The functions that take the sphere have grates that allow the sphere to roll down the grates, and yet a liquid would fall through the grates. 

When either sphere or liquid are extended, they still have to have the same behavior defined in the abstract classes in order for the new classes to not break the methods defined to handle the abstract classes.

The Liskov substitution principle outlines a way to make sure your program can be extended without changing the behavior of the existing functionality.  It is a way to make the codebase have more integrity and longevity. 

If we build our methods to always assume that any `Liquid` has the method `flow` and any `Sphere` has the method `roll`, then regardless of the type of class we define that implements `Sphere` or `Liquid`.
