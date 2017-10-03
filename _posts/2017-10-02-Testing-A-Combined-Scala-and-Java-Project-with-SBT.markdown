---
layout: post
title: Testing a Combined Scala and Java Project with SBT
date:   2017-10-02 12:00:00 -0500
categories: Testing Scala Java
excerpt_separator: <!--more-->
---

Scala, aside from offering a attractive blend of functional and statically typed syntax, it also offers inter-operability with Java. The ability to utilize the extensive ecosystem of Java makes it easy to adopt in most use cases.

While the inter-operability has significant up sides, there are some pains when setting up continuous integration when implementing a mixed project.

Utilizing libraries is a breeze, as we don't have to test the code that we don't own.  However, when implementing both Scala and Java within a project we do have to ensure there is sufficient automated testing in place.

<!--more-->

# Behind the curve

Currently JUnit 5 is unsupported through the libraries that integrate JUnit testing with SBT.  For the time being it is best to use JUnit 4, which greatly simplifies the integration process.

# org.novacode.junit-interface

The simplest integration is the JUnit-Interface library.  With this dependency there is no need to include any other dependencies to begin testing JUnit 4 with SBT.

### Dependency and additional settings

Here is the adjustments to the build.sbt necessary for integration.  The first line sets options for the JUnit framework which allows test logging on success, so that we know our JUnit tests are running.  The two libraries used as dependencies are the JUnit Integration and ScalaTest.

``` sbt
testOptions += Tests.Argument(TestFrameworks.JUnit, "-v")

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "3.0.1" % "test",
  "com.novocode" % "junit-interface" % "0.11" % "test")
```

### Folder structure

Contrary to most documentation, this method requires that the JUnit test be contained in the same directory as the ScalaTest tests. Now when SBT is run through a continuous integration tool like Travis or Jenkins, the Java tests are run along with the Scala tests, and will cause a red state if a Java test fails.

```
project
│
└───src
│   │
│   └───java/org/groupid/artifactid/
│   │    │   ExampleJavaClass1.java
│   │    │   ExampleJavaClass2.java
│   │
│   └───scala/org/groupid/artifactid/
│        │   ExampleScalaClass1.scala
│        │   ExampleScalaClass2.scala
│
└───test
    │
    └───scala/org/groupid/artifactid/
         │   ExampleJavaClass1Test.java
         │   ExampleJavaClass2Test.java
         │   ExampleScalaClass1Spec.scala
         │   ExampleScalaClass2Spec.scala
```

