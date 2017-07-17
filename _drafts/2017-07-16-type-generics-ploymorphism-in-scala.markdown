---
layout: post
title:  "Type Generics - Polymorphism in Scala"
date:   2017-07-07 12:00:00 -0500
categories: scala types static-typing polymorphism type-generics
excerpt_separator: <!--more-->

---
![Polymorphic Jaguars]({{ site.url }}/assets/polymorphic-jaguars.jpg)

This post is an examination of polymorphism in Scala, an extension of an earlier post on types.  If you are unfamiliar with types in Scala, I suggest that you read or at least skim the post on types.

# Polymorphism
The word polymorphism has latin roots, and means something that can take multiple forms. If we take a look at the etymology of the word, the meaning is clear.

The root 'poly' means many, 'morph' means to change, and '-ism' is a greek root suffix used in english to describe an ideology or philosophy.

Polymorphism in biology is the occurrence of two or more forms of alternative phenotypes in a population of a species. The picture above is an example of polymorphic gene expression in Jaguars, where the dark-morph jaguar has a specific gene expression that produces melanistic variations.

In programming it refers to the ability to use the same interface with multiply types. In object-oriented programming it is called *generics* or *generic programming*.  In functional programming it is more commonly referred to as *polymorphism*.

# Polymorphism in Scala

The following method will serve as the use case for our exploration into polymorphic Scala. The method ***doubleIt*** will be written with strict typing of both the method argument and the return type.

``` scala
scala> def doubleIt(s: String): String = s * 2
doubleIt: (s: String)String

scala> doubleIt("TigersAndBearsOhMy")
res0: String = TigersAndBearsOhMyTigersAndBearsOhMy
```

This is staticaly typed scala, and is not polymorphic.  If it was polymorphic we would be able to pass an argument of a different type, and the compiler would accept the input. If we pass in another type, we run into problems.  Let's pass in an integer.

``` scala
cala> doubleIt(5)
<console>:9: error: type mismatch;
 found   : Int(5)
 required: String
              doubleIt(5)
                       ^
```

The error message indicates that there is a type missmatch, tells us what was found and what was expected and points to the line and character where the issues presents.  This level of error logging is incredibly helpful and walks you through all errors as long as you solve each one.  Scala really can guide you out of the swamp one step at a time.

We will change the type using ***generic sytax*** to denote the generic type.  The generic parameter is assigned useing bracket notation directly after the method name and directly preceeding the arguments. Our generic type will be ***T*** purely for clarity, however you can use any string that does not begin with a number. The Scala style guide suggests upper case letters as Scala is a functional language and it maintains readability. Let's give it a try.

``` scala
cala> def doubleIt[T](value: T) = value * 2
<console>:7: error: value * is not a member of type parameter T
       def doubleIt[T](value: T) = value * 2

```

This error raises an issue of Types and Inheritence. Let's change the return value to a tuple of the value and itself, and further along we can come back and address Types, Type Hierarchy, and Type Bounds (type bounds is the solution to this error).

Here is the updated code using a tuple return, annotated for clarity.

``` scala
def doubleIt[T](x: T): (T, T): (x, x)
//           ^     ^    ^       ^
//   generic 」    |    |       |
//argument type(T) 」   |       |
//      return tuple(T) 」      |
//           body of the method 」

```

And here is the method declaration and a few tests.

```scala
scala> def doubleIt[T](x: T): (T, T) = (x, x)
doubleIt: [T](x: T)(T, T)

scala> doubleIt("Jaguar")
res0: (String, String) = (Jaguar,Jaguar)

scala> doubleIt(5)
res1: (Int, Int) = (5,5)

scala> doubleIt(true)
res3: (Boolean, Boolean) = (true,true)

scala> doubleIt(() => true)
res5: (() => Boolean, () => Boolean) = (<function0>,<function0>)
```

As can be seen in the above examples, any type can be passed into the function as it stands, though our goal was to double a string or a number. To get what we really want we need to use Type bounds, but first, a primer on type hierarchy.

# Type Hierarchy in Scala, or Unified Types

The type system in Scala is hierarchal, meaning that one type can be a type of another class. For example, ***Int*** is a subtype of ***AnyVal***.  ***AnyVal*** is a subtype of ***Any***.

Here is a map of all the types.  Each type is a *super type* of the type below.

![Scala Type Hierarchy]({{ site.url  }}/assets/ScalaTypeHierarchy.jpg)

# Type Bounding







