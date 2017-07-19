---
layout: post
title:  "Traits, Inheritance and Abstract Classes"
date:   2017-07-17 12:00:00 -0500
categories: scala traits class abstraction 
excerpt_separator: <!--more-->
---


![Monolith Monsters]({{ site.url }}/assets/monsters.jpg)



Traits, abstract classes and classes can all be used to create a new class which draws from the others. Think of it like mixing and matching, but with some rules about what you can do with each.

The goal, create abstraction without having your code become a monolithic monster!

It took quite a while to wrap my head around the concept, so here is the most straight forward explanation I can give.
<!--more-->
# Classes

A class is the easiest of the three to comprehend. Everything in Scala is an object, so is a class. The difference between a class and a singleton object (an object that is declared on its own) is that a class is used to instantiate an object. It can also be used as a static type in Scala's type checking system. This makes it more powerful than a singleton object, as you can have multiple instantiations running around on different threads without interfering with one another.

It may help to think of a class as a recipe, and an object the outcome of the recipe.  In our case, a recipe for a monster...

On the flip side, if you reference an object in your codebase, and run multiple tests on that object (as you absolutely should), different threads may run tests simultaneously and be accessing the same object at the same time.  This is not a problem if you code is immutable, but if there is any mutability then each thread will be mutating and your tests will be polluted.

If you refactor the object to a class, you will also need to add instantiation of the class as well, but each new instance of the class will not interact with each other unless directed to do so.  Let's create a class called Monster which can be alive, or not. It will also be able to move We will instantiate Monster with the val blob.

``` scala
class Monster {
  val isAlive: Boolean = true
  val canMove: Boolean = true
}
//> defined class Monster

val blob = new Monster
//> blob: Monster = Monster@71cb3139

blob.canMove
//> res1: Boolean = true

blob.isAlive
//> res2: Boolean = true
```

Wonderful, now we have a blob that can move and is alive.

![The Blob]({{ site.url }}/assets/blob.jpg)

# Traits

A trait in Scala is used to share values, fields and interfaces between classes.  It is something we can add onto a class.  Let's create an example and add it to our monster.  How about tentacles?


``` scala
trait Tentacles {
  val hasTentacles: Boolean = true
  val tentacleCount: Int = 4
}
//> defined trait Tentacles
```

Perfect, now to instantiate an object of the **class Monster** with the **trait Tentacles**.

``` scala 
val yog = new Monster with Tentacles
//> yog: Monster with Tentacles = $anon$1@2903c6ff
```

Great, lets give yog a checkup, just to make sure the object has inherited the all vals from the **trait Tentacles**.

``` scala
yog.isAlive
//> res7: Boolean = true

yog.canMove
//> res8: Boolean = true

yog.hasTentacles
//> res9: Boolean = true

yog.tentacleCount
//> res10: Int = 4
```

![Yog the Planet Killer]({{ site.url }}/assets/yog_monster_from_space.jpg)

# Abstract Classes

The main reason to use an abstract class is if you want a class that requires constructor arguments, meaning that you want to pass arguments to the abstract class when creating a class object instance. One caveat is that you can only have use one abstract class at a time. 

One important thing that we need to consider when making monster is the size, that cannot be left to chance.

Here is an abstract class, we will use the class name **Size**. Lets also give it a body in the size class, just for fun.

``` scala 
abstract class Size(s: String) {
  val size: String = s
  val hasBody: Boolean = true
}
```

Now we can redefine our monster class to extend Size with **cosmic**, because if we are going to make monster, why not make them big?

``` scala
class Monster extends Size("Cosmic") {
  val isAlive: Boolean = true
  val canMove: Boolean = true
}
//> defined class Monster
```

Now we are rip-roarin' and ready to go. Let's make our magnum opus.

``` scala
val cthulhu = new Monster with Tentacles
//> cthulhu: Monster with Tentacles = $anon$1@3bec5821
```

The **class Monster extends** the abstract class **Size** taking a constructor argument **("Cosmic")** **with Tentacles** trait. 

Which is exactly the syntax need to construct Cthulhu.

**val cthulhu = new Monster extends Size("Cosmic") with Tentacles**

Let's give him a quick checkup to see if he was created appropriately.

``` scala
cthulhu.isAlive
//> res11: Boolean = true

cthulhu.canMove
//> res12: Boolean = true

cthulhu.hasTentacles
//> res13: Boolean = true

cthulhu.size
//> res14: String = Cosmic
```

Everything looks cosmic, monstery, tenticaly, and alive. 

I hope this may have clarified a subject that took me way to long to comprehend, and hopefully it was a bit more colorful that a manual.  Here's the glorious creation...

![Cthulhu the Destroyer]({{ site.url }}/assets/cthulhu.jpg)




