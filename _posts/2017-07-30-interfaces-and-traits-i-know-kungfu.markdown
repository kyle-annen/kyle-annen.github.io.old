---
layout: post
title:  "Java Interfaces vs Scala Traits: I Know Kung Fu"
date:   2017-07-30 12:00:00 -0500
categories: scala design
excerpt_separator: <!--more-->
---

![KungFu]({{ site.url }}/assets/kungfu.jpg)

Scala is often billed as the better Java.  When exploring abstraction in Scala and Java, it may be confusing that the language features that provide this abstraction are named in a way that may be confusing. 

Scala and Java both have classes. Today I will be discussing how to define a common interface, or how to define how a class should implement a common set of values and methods. 
<!--more-->
In Scala these are called **Traits**.  A class implements a **Trait** in order to have a common interface.  This would be like defining the methods which an API must implement.  

In Java this is called an **Interface**. 

_________



## Scala Traits
There are a few differences.  In Scala, **Traits**:

1. Do not take parameters
2. Can have values
3. Can have implemented methods

____



## Java Interfaces

In Java, **Interfaces** are more restricted, and mainly used to define how an interface should be implemented.  Java **Interfaces**:

1. Do not take parameters
2. May only have fields (no values)
3. May only have method signatures, not implementations


## Java Definition and Implementation

Here is a KungFu interface that defines the functions a class *must* define if it is going to implement the interface.

``` java
interface KungFu {
    void craneKick();
    void snakeCreepsThroughTheGrass();
    void repulseMonkey();
}
```

And here we have the Neo class implementing the KungFu interface.

``` java 
class XiaoLin implements KungFu {
    public void craneKick(String s) {
        System.out.print("Kicks Apprentice!\n");
    }

    public void snakeCreepsThroughTheGrass() {
        System.out.print("Whhhhhooooosh. Monk dodges!\n");
    }

    public void repulseMonkey() {
       System.out.print("Blocks many blows.\n");
    }


    public static void main(String []args) {
        KungFu monk = new XiaoLin();
        monk.craneKick();
        monk.snakeCreepsThroughTheGrass();
        monk.repulseMonkey();
    }
}
```

# Scala Definition and Implementation

![savate]({{ site.url }}/assets/savate.jpg)

Alternatively a Trait in Scala can have values and method implementations.  The name was chosen specifically to not confuse the two quite similar implementations of abstraction.

``` scala
trait Savate {
  val avant: String
  val arriere: String
  def median(s: String): Unit = println("Francios kicks you in the stomach.")
}

class FX extends Savate {
  val avant: String = "Kick in the face!"
  val arriere: String = "Crossover kick!"
}
```
