---
layout: post
title:  "A Introduction to Types in Scala"
date:   2017-07-07 12:00:00 -0500
categories: scala types static-typing 

---

# Static Typing in Scala - Rock Solid

![Glacier National Park]({{ site.url }}/assets/static-type-mountains.jpg)

Before I had used static typing languages that where static typed look cumbersome, verbose, inflexible and overall very unappealing. The flexibility of Javascript es6 made everything seem possible.  It made me feel like I could do anything, build anything, that everything I wrote was good enough.  It worked, didn't it? Why would it not be right...

After having spent a few weeks with Scala, using static types throughout my project, I have come to realize that static typing actually give me more power.  I have to sit and think about each line of code, about the purpose of every method.  It has made me introspective about the significance of the code I produce, made me examine why I choose one path over another.  It has truly made me better.

# Why Types

Static types allow the compiler to throw an error, instead of waiting until runtime to throw an error.  

Why do we care? Catching errors at compile time 

# This Is Not The Greatest Guide, It Is Only a Tribute

![Tribute]({{ site.url }}/assets/tribute.jpg)

This post is purely meant as a general overview of types, and mostly a long winded exploration of my thoughts.  If you are looking for a more in depth look at Type Hierarchy and Abstract Types, an excellent article by ***Konrad "ktoso" Malawski*** can be found here: [Scala’s Types of Types][scalatypeoftypes].

# Type Ascription
Type Ascription is how we explicitly define a type in Scala.  If you do not use Type Ascription the compiler will attempt to guess, or infer, the Type. 

For the following exercises I will be using the Scala REPL, if you have Scala installed you can simply open a terminal and type: 

``` bash
$ scala
```

If we assign an integer to the variable num in scala REPL, we can see the outcome is Type Ascription of type ***Int*** to the variable ***num*** of value ***1***.

``` scala
scala> val num = 1
//> num: Int = 1
```

Alternatively, we can use Type Ascription to explicitly set the type. The syntax is for a ***colon*** directly following the variable, a ***space***, then the ***type***.

In the example below, we will use the type ***String***.

``` scala 
scala> val text: String = "Scalabrasaurus"
//> text: String = Scalabrasaurus
```

# Wait, why are they useful?

Let's try the same variable, type ascription and this time use an incorrect assignment. Let's use an integer.

``` scala
scala> val text: String = 1
//> <console>:11: error: type mismatch;
//>  found   : Int(1)
//>  required: String
//>        val text: String = 1
//>                           ^
``` 

Now, there's the power. This error will throw very specific indications of what violates the explicit Type Ascription that is assigned using static typing.  It forces us to ensure we are not passing values around willy-nilly.  

If you have ever seen a British Queue vs a Chinese Mob waiting for the bus, this is somewhat like the former; everything in its place. 

Perfect.  Let's get organized.  

# Types and Methods

It becomes more complex when defining a method, as we can assign static types to both the arguments and the return value of the method.  

Here is an example.

``` scala 
def methodEx(arg1: Int, arg2: String): String = arg1 * arg2
```

Here is the same method, re-written to be descriptive of purpose, the purpose being to repeat a given string ***(s)*** a certain number of times ***(n).***

``` scala 
scala> def repeatString(s: String, n: Int): String = s * n
//> repeatString: (s: String, n: Int)String

scala> repeatString("GoGetEmScala--", 3)
//> res1: String = GoGetEmScala--GoGetEmScala--GoGetEmScala--
```

What if we could use a method as an argument? Yup, we absolutely can. The Types need to be set in the argument portion of the receiving method. For this method we will use our repeat string method as a passed argument.  We will define ```modifyString()``` which will accept a function that will wrap around a string, and then add html tags on either side.  Seems somewhat useful.

``` scala
def modifyString(s: String, modifier: String => String): String = {
  "<p>" + modifier(s) + "</p>"
}
```

First, that is a ton of ***String*** Type Ascriptions. The more time you spend with Types the more this is comforting that verbose.

Firstly we have the argument Ascriptions:

1. ```s: String``` 
- ascribes the ***String*** type to the argument ***s***
2. ```modifier: String => String```
- ascribes a ***String*** input with a ***String*** output for the passed method
3. ```modifyString(): String``` 
- ascribes a return type of ***String*** for the main method

Let's see it in action.
``` scala
scala> modifyString("Scalarnado is coming!", repeatString)
//> <console>:14: error: type mismatch;
//>  found   : (String, Int) => String
//>  required: String => String
//>        modifyString("Scalarnado is coming!", repeatString)
```

# Dang, Let's Try Again

Based on the feedback from the REPL, we need to adjust our Type Ascription for the passed modifier method. We will change it from:

```modifier: String => String```

to

```modifier: (String, Int) => String```

This has to be done, as ```repeatString()``` accepts a ***String*** and an ***Int***.

``` scala
def modifyString(s: String, modifier: (String, Int) => String): String = {
  "<p>" + modifier(s) + "</p>"
}
```

Right, right... Give the REPL another shot at it.

``` scala 
scala> def modifyString(s: String, modifier: (String, Int) => String): String = {
     |   "<p>" + modifier(s) + "</p>"
     | }
//> <console>:12: error: not enough arguments for method apply: (v1: String, v2: Int)//> //> String in trait Function2.
//> Unspecified value parameter v2.
//>   "<p>" + modifier(s) + "</p>"
//>                   ^
```
Here the REPL informs us that we have another error, it seems we forgot the ***Int*** value when we called the ```modifier()``` method argument.  We can fix that.

``` scala
def modifyString(s: String, modifier: (String, Int) => String): String = {
  "<p>" + modifier(s, 3) + "</p>"
}
``` 

And if we run it all again in the REPL:

``` scala 
scala> def modifyString(s: String, modifier: (String, Int) => String): String = {
     |   "<p>" + modifier(s, 3) + "</p>"
     | }
//> modifyString: (s: String, modifier: (String, Int) => String)String

scala> modifyString("Scalarnado is coming, hopefully...", repeatString)
//> res1: String = <p>Scalarnado is coming, hopefully...Scalarnado is coming, hopefully...Scalarnado is coming, hopefully...</p>
```

Finally.  However, without Static Typing and Type Ascription it may have taken longer, and we would have less clues as to what we need to change in our code.  

# Build With Stone, Not Sand

![Petra]({{ site.url }}/assets/petra.jpg)

I sure hope that when I am gone, something that I make can live on to benefit future generations.  Use of Static Types and a focus on writing code for others, instead of writing code for a given task, we can have a change of passing something on that will be useful. 

I will leave you with a Chinese proverb which is probably overused, or based on the continuously negligent way we force the world to bend to our will, under appreciated. 

# “The best time to plant a tree was 20 years ago. The second best time is now.”






















[scalatypeoftypes]: http://ktoso.github.io/scala-types-of-types/