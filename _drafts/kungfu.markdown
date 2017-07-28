---
layout: post
title:  "Java Interfaces vs Scala Traits: I Know Kung Fu Now"
date:   2018-07-30 12:00:00 -0500
categories: scala design
excerpt_separator: <!--more-->
---



``` java
interface StrongSuperhero {
    void smash();
    void leap();
    void flex();
}
```

``` java 
class Hulk implements StrongSuperhero {
    public void smash() {
        System.out.print("Hulk Smash!\n");
    }

    public void leap() {
        System.out.print("Whhhhhooooosh. Hulk leaps through your monitor!\n");
    }

    public void flex() {
       System.out.print("Hulk rips what little is left of his shirt.\n");
    }


    public static void main(String []args) {
        StrongSuperhero redHulk = new Hulk();
        redHulk.smash();
        redHulk.leap();
        redHulk.flex();

    }

}
```
