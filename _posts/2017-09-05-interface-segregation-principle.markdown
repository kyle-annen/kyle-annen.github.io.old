---
layout: post
title:  Solid - interface segregation principle
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

The Interface segregation principle states that no client depend on methods it does not use. 

<!--more-->

In simpler terms this means that an interface should be as simple as the simplest client which needs to implement it. To achieve more complex interfaces a we compose new interfaces to specifically fit the new client needs. We can also implement multiple interfaces through composition.

As an example, lets create an interface for printing to the console.  

``` java
public interface Printable {
  void print();
}
```

Now say we have additional requirements for interfaces to Get, Set and Print. We can define the additional behavior in a new interface.

``` java
public interface GetSetPrintable {
  void print();
  Integer get();
  void set(Integer value);
}
```

Now we can define an object that implements GetSetPrintable, but breaks the interface segregation principle.

``` java
public class SetGetConstant implements GetSetPrintable {
  Integer constant = 50;
  @Override
  void print() { }
  @Override
  public Integer get() { return this.constant; }
  @Override
  public void set(Integer value) { this.constant = value; }
}
```

The above class does not implement `print` in any usable fashion.  Instead we can separate out GetSetPrintable.

``` java
public interface Printable {
  void print();
}
```

``` java
public interface Getable {
  public Integer get();
}
```

``` java
public interface Settable {
  public void set(Integer value)
}
```

Now we can properly redefine SetGetConstant using multiple implementations through composition of the more discretely defined interfaces.

``` java
public class SetGetConstant implements Getable, Settable {
  Integer constant;
  public SetGetConstant(Integer constant) {
    this.constant = constant;
  }
  @Override
  public Integer get() { return this.constant; }
  @Override
  public void set(Integer value) { this.constant = value; }
}
```

Now the class `SetGetConstant` adheres to the interface segregation principle. 