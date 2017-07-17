---
layout: post
title:  "Type Generics and Polymorphism in Scala"
date:   2017-07-16 12:00:00 -0500
categories: scala types static-typing polymorphism type-generics
excerpt_separator: <!--more-->

---
![Polymorphic Jaguars]({{ site.url }}/assets/polymorphic-jaguars.jpg)

This post is an examination of polymorphism in Scala, an extension of an earlier post on types.  If you are unfamiliar with types in Scala, I suggest that you read or at least skim the post on types.

# Polymorphism
The word polymorphism has greek roots, and means something that can take multiple forms. If we take a look at the etymology of the word, the meaning is clear.

The root 'poly' means many, 'morphe' means to change, and '-ism' is a greek root suffix used in english to describe an ideology or philosophy.

<!--more-->

Polymorphism in biology is the occurrence of two or more forms of alternative phenotypes in a population of a species. The picture above is an example of polymorphic gene expression in Jaguars, where the dark-morph jaguar has a specific gene expression that produces melanistic variations.

In programming it refers to the ability to use the same interface with multiply types. In object-oriented programming it is called *generics* or *generic programming*.  In functional programming it is more commonly referred to as *polymorphism*.

# Polymorphism in Scala

![Polymorphic Mallards]({{ site.url }}/assets/mallards.jpg)
*The Mallard duck showing sexual polymorphism, exhibiting striking visual differences between the males and females of the species.*

The following method will serve as the use case for our exploration into polymorphic Scala. The method ***print*** will be written with strict typing of both the method argument and the return type. The goal is to have the method print only values and not objects, functions or classes.  This requirement will help to explore polymorphism in Scala.

``` scala
scala> def print(x: String): Unit = println(x)
//> print: (x: String)Unit

scala> print("Scala")
//> Scala
```

This is statically typed scala, and is not polymorphic.  If it was polymorphic we would be able to pass an argument of a different type, and the compiler would accept the input. If we pass in another type, we run into problems.  Let's pass in an integer.

``` scala
scala> print(5)
//> <console>:2: error: type mismatch;
//> found   : Int(5)
//> required: String
//>       print(5)
//>             ^
```

The error message indicates that there is a type mismatch, tells us what was found, what was expected and points to the line and character where the issue presents.  This level of error logging is incredibly helpful and walks you through all errors as long as you solve each one.  Scala really can guide you out of the swamp one step at a time.

We will change the type using ***generic syntax*** to denote the generic type.  The generic parameter is assigned using bracket notation directly after the method name and directly preceeding the arguments. Our generic type will be ***T*** purely for clarity, however you can use any string that does not begin with a number. The Scala style guide suggests upper case letters as Scala is a functional language and it maintains readability. Let's give it a try.

Here is the updated code using ***type generic***, annotated for clarity.

``` scala
def print[T](x: T): Unit: println(x)
//        ^     ^    ^       ^
//generic 」    |    |       |
//argument type(T)   |       |
//      return type  」      |
//        body of the method 」

```

And here is the method declaration and a few tests.

```scala
scala> def print[T](x: T): Unit = println(x)
//> print: [T](x: T)Unit

scala> print(5)
//> 5

scala> print("test")
//> test

scala> print(() => 5)
//> $line6.$read$$iw$$iw$$$Lambda$1055/1010983633@100c567fs
```

As can be seen in the above examples, any type can be passed into the function as it stands, and any value can be passed in as an argument and will be printed to the console.  A Lambda was also able to be passed and printed, which is outside the requirements. In order to limit the acceptable types, we will need to use ***type bounding***, which requires a deeper discussion of type hierarchy.

# Type Hierarchy in Scala, or Unified Types

The type system in Scala is hierarchal, meaning that one type can be a type of another class. For example, ***Int*** is a subtype of ***AnyVal***.  ***AnyVal*** is a subtype of ***Any***.

Here is a map of all the types.  Each type is a *super type* of the type below.

![Scala Type Hierarchy]({{ site.url  }}/assets/ScalaTypeHierarchy.jpg)

# Type Bounding

Type Bounding allows a more strict control of Type Generics by setting a bound, or limit, of the type generic. There are multiple operators which can be used in type ***bounding***, first we will take a look at ***Upper Type Bounds***.

### Upper Type Bounds

Setting an upper bound will limit the types which the compiler will accept.  Looking at the type hierarchy above, ***AnyVal*** has the subtypes of all the types which fit the requirement.  The operator for upper bounds is a left angle bracket followed by a colon ( ***<:*** ).

``` scala
def methodName[TypeGeneric <: UpperBound](variable: TypeGeneric): ReturnType = {
  method body
}
```

Using the above syntax the method with the type generic using upper bounds can be defined, and should fit the requirements.

``` scala
scala> def print[T <: AnyVal](x: T): Unit = println(x)
//> print: [T <: AnyVal](x: T)Unit
```

As the upper bound is ***AnyVal*** the method should not accept a Lambda as an argument.

``` scala
scala> print(()=> 3)
//> <console>:13: error: inferred type arguments [() => Int] do not 
//> conform to method print's type parameter bounds [T <: AnyVal]
//>        print(()=> 3)
//>        ^
//> <console>:13: error: type mismatch;
//>  found   : () => Int
//>  required: T
//>        print(()=> 3)
//>                ^
```

The error is extremely detailed, and affirms that the upper bounds restricted the arguments to the desired input.

### Additional Type Bounding

Additional type bounding will be covered in succeeding posts.  Additional bounding operators can be referenced in the [Scala Documentation's - Tour of Scala][scalaDocumentation]. Below is a list of the additional operators, which will become links to newer posts as the posts are written.

{: .blog-table}

|---------|--------|-------|
| A **>:** B | A lower bounded by B |
| A **=:=** B | A must equal B |
| A **<:<** B | A must be a subtype of B |
| A **<%<** B | A must be viewable as B |




[scalaDocumentation]: http://docs.scala-lang.org/tutorials/tour/tour-of-scala.html