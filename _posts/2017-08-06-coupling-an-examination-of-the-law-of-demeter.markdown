---
layout: post
title:  "Coupling: An Examination of the Law of Demeter"
date:   2017-08-06 12:00:00 -0500
categories: coupling adaptive-programming maintainability
excerpt_separator: <!--more-->
---
![berlin]({{ site.url }}/assets/berlinmap.gif)
Coupling refers to how dependent a module is on the functions of other models. Imagine a public transit system that ceased functioning whenever one train goes out of commission.

<!--more-->

The Law of Demeter is a guideline used in the development of software which was initially proposed by Ian Holland of Northeastern University in 1987. 

It is also known as the principle of least knowledge. A generalization of the principle is that an object should have as little knowledge of the structure and properties of another object as possible. 



# An overly simplistic, but useful rule

While nothing in software engineering is black and white or one size fits all, a simple example can be given using dot notation.

The following call breaks this rule, as it must have knowledge of a child's workings.

``` scala
parent.child.performActions(3)
```

A more appropriate invocation would resemble the following.

``` scala
parent.child(3)
```

Here the parent passes the parameter to the child, and it is now in the domain of the child. 

# The onion example

Another way to think about the Law of Demeter is to visualize the different layers of an application. In the diagram below the inner circle is where the data resides.  The next layer of the application is where the business logic resides.  The very top level is the API used for communication with other applications. 

The red arrows represent a leaky abstraction, or an abstraction in which the different layers of the application have to know or understand about a layer that is not next to it. 

The green arrows represent the level of knowledge that is acceptable based on the Law of Demeter.


![onion]({{ site.url }}/assets/couplingOnion.png)


# A mathematical representation of coupling

Coupling in software can be represented mathematically using the input and output data and control parameters, number of global variables and controls used, and number of modules called in a method and the number of times modules call the method. 

A highly coupled method approaches a value of ***1.0*** and a method with a single input variable and a single output variable has a value of ***0.65***.


<div class="formula">$$Coupling(C) = 1 - \frac {1}{d_i + 2c_i + d_o + 2c_o + g_d + 2g_c + w + r}$$</div>

> ###### Pressman, Roger S. Ph.D. (1982). Software Engineering - A Practitioner's Approach - Fourth Edition.

## Variable definitions

For data and control flow coupling:

<span class="formula-def">$$d_i \;\;\;number\,of\, input\, data\, parameters$$</span><br/>
<span class="formula-def">$$c_i \;\;\;number\,of\, input\, control\, parameters$$</span><br/>
<span class="formula-def">$$d_o \;\;\;number\,of\, output\, data\, parameters$$</span><br/>
<span class="formula-def">$$c_o \;\;\;number\,of\, output\, control\, parameters$$</span><br/>

For global coupling:

<span class="formula-def">$$g_d \;\;\; number\, of\, global\, variables\, used\, as\, data$$</span><br/>
<span class="formula-def">$$g_c \;\;\; number\, of\, global\, variables\, used\, as\, control$$</span><br/>

For environmental coupling:

<span class="formula-def">$$w \;\;\;: number\, of\, modules\, called\, (fan-out)$$</span><br/>
<span class="formula-def">$$r \;\;\;: number\, of\, modules\, calling\, the\, module\, under\, consideration\, (fan-in)$$</span><br/>

