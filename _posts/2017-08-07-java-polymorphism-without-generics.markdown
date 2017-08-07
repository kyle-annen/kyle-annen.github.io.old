---
layout: post
title:  "Overloading Java: polymorphism without type generics"
date:   2017-08-07 12:00:00 -0500
categories: polymorphism java
excerpt_separator: <!--more-->
---


![overload]({{ site.url }}/assets/javaoverload.jpg)

While type generics are an excellent way to keep your code polymorphic and flexible.  In a case where different behavior occurs when various types are passed as an argument, type generics are not the simplest solution. Overloading is the topic of the day.

<!--more-->

# Overload me

Java has a few different ways to implement polymorphism:

- Type Generics
- Abstract Classes 
- Interfaces
- Class Inheritance
- Overriding
- Overloading

Of the avenues for implementing polymorphism in Java, overloading alone has the ability to implement different behavior based on the type of the argument passed into the method.  This is implemented through defining a method multiple times, using a different type of argument. 

If we want different behavior if a string or an integer is passed in, we could use message overloading to implement this behavior.


``` java
public object Polymorph {

  private void print(String s) {  //<-------
    System.out.println(s);
  }

  private void print(int n) {  //<----------
    System.out.println(n + 1);
  }

  public static void main(String [] args) {
    Polymorph test = new Polymorph();
    test.print("test");
    test.print(5);
  }
}
//> test
//> 6
//Process finished with exit code 0
```  

In the above class **Polymorph** two methods have been defined with the same name, **print**.  The two definitions accept different types for the arguments. 

The first will only accept a **String**, and will then print the string to the console. 

The second will only accept an **int** then increment the **int** by one and print the resultant **int** to the console. 

This type of behavior is admittedly not very useful, let's see if we can write a truly useful overloaded class for pretty printing Java.


# Pretty print me

![fifthelement]({{ site.url }}/assets/fifthelement.jpg)

I'll start by defining some features. A pretty printer should absolutely be able to print a single string, the method from the   Next, the integer printing method is pretty useless, we can throw that away as well as rename the class.

Let's also add a class that will print an array of strings, one at a time on their own lines.  This would be useful if we needed to print out many lines at a time.

``` java
public class PrettyPrinter {

  private void print(String s) {
    System.out.println(s);
  }

  private void print(String [] strings) {
    for (String s : strings) {
      System.out.println(s);
    }
  }

  public static void main(String [] args) {
    String[] movies = {
            "Back to The Future",
            "Kindergarten Cop",
            "Big Trouble in Little China",
            "The Fifth Element"};
    PrettyPrinter test = new PrettyPrinter();
    test.print("Movies to Check Out");
    test.print("--------------------");
    test.print(movies);

  }
}

//> Movies to Check Out
//> --------------------
//> Back to The Future
//> Kindergarten Cop
//> Big Trouble in Little China
//> The Fifth Element
//>
// Process finished with exit code 0
```
# Hackerman me

![hackerman]({{ site.url }}/assets/truehackerman.jpg)

Perfect.  Next, I want to be able to print out in color.  Glorious, eighties nostalgic green on black terminal goodness. How else could we hope to match the glory of hackerman?

To do this we add two new methods, both of which accept a second String argument 

``` java 
public class PrettyPrinter {
  private static final String ANSI_RESET = "\u001B[0m";
  private static final String ANSI_GREEN = "\u001B[32m";

  private void print(String s) {
    System.out.println(s);
  }

  private void print(String s, String color) {
    System.out.print(color);
    System.out.println(s);
    System.out.print(ANSI_RESET);
  }

  private void print(String [] strings) {
    for (String s : strings) {
      System.out.println(s);
    }
  }

  private void print(String [] strings, String color) {
    System.out.print(color);
    for (String s : strings) {
      System.out.println(s);
    }
    System.out.print(ANSI_RESET);
  }

  public static void main(String [] args) {
    String[] movies = {
            "Back to The Future",
            "Kindergarten Cop",
            "Big Trouble in Little China",
            "The Fifth Element"};
    PrettyPrinter test = new PrettyPrinter();
    test.print("Movies to Check Out", ANSI_GREEN);
    test.print("--------------------", ANSI_GREEN);
    test.print(movies, ANSI_GREEN);
  }
}
```

Now that there are overload methods which accept a **String** and a **String Array**, both with a color, now we can print out our movie list in all its 80s/90s glory.

<div class="console-emulator">
  <p>Movies to check out</p>
  <p>-------------------</p>
  <p>Back to The Future</p>
  <p>Kindergarten Cop</p>
  <p>Big Trouble in Little China</p>
  <p>The Fifth Element</p>
</div>






