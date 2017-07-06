---
layout: post
title:  "Beginning Testing in Scala"
date:   2017-07-06 12:00:00 -0500
categories: scala scalatest TDD

---
# Philosophy of Testing - Embrace the Blue Sky

![Idaho Clouds]({{ site.url }}/assets/merc_clouds.jpg)

When first learning how to write code I came across many negative viewpoints around testing.  Test Driven Development was the practice of writing tests that make sure your code works. At least, that is what I thought it meant.

Testing was a failsafe, a way to confirm what you already knew, that the code you write functions as intended.

Testing is that, yet it is so much more. It let's you walk outside everyday to a blue and beautify sky, where you can plant new flowers and go for a nice walk.

Test Driven Development lets me define how my methods, classes, and objects should be, even without knowing how to write them yet. Testing should be like walking outside to plant flowers, because we have already check the weather report, know what time of year it is, and know that the flowers need the 50% sunlight next to the shed in order to thrive.  

Programming without defining the function of a particular piece of code is like walking out into a snow storm with a fern, digging in the rock hard soil, and expecting it to grow.  Yes, we can build a shelter around the fern and set up a space heater, but it is way more work. 

Embrace the blue sky, define your path before you begin.

# Beginning Testing in Scala
Testing in Scala can be very straight forward if the code is structured correctly. If the code is poorly structured it can be like planting a fern in a blizzard: tough, painstaking, and ultimately not bery productive. 

Code that is written in a functional way which avoids a few pit-falls can accomplish the majority of test coverage using Unit Testing.

The options for test suites in Scala are [Scala Test][scalatest] and [Scala Spec][scalaspec].  Today I will be focusing on ```ScalaTest```, with ```sbt``` as the build tool.

First, let's make sure the testing environment is ready to go. 



# Configuration for ScalaTest

Configuration is straight forward, adding a few lines to ```build.sbt```,```Dependencies.scala```, and ```global.sbt```.

It is best to use the most up-to-date versions, which can be found in the excellent install guide over at [ScalaTest's install page][scalatest].

# Testing Styles

Scala test offers a few flavors of testing syntax. My experience with testing lead me to pick FunSpec, which resembles Ruby's rSpec and Javascript's Mocha. 

If you prefer other styles of testing, all the offerings can be perused at [ScalaTest's "Selecting a Style" section here.][scalaSelectTest].

### Available Flavors
- FunSuite - similar to xUnit
- FlatSpec - teams moving from xUnit to BDD
- FunSpec - similar to rSpec or Mocha
- WordSpec - similar to specs or specs2
- FreeSpec - un-opinionated, best for teams with BDD experience

# Testable Code Structure
In order for code to be easily tested, two things should be avoided at all cost.  

1. Concrete dependencies -(covered here)
2. Side effects - (will cover in successive articles)

## Concrete Dependencies
A concrete dependencies is when a method explicitly calls an object, method, or value that has not been passed as an argument. The example below, ```printString()```, prints a string to the console.  This is a concrete dependency, we cannot change where the string is rendered as it has a concrete dependency on the native Scala function ```Console.println()```. 

``` scala
def printString(s: String): Unit = println(s)
//=> printString: (s: String)Unit

renderString("Scala Rules!") 
//=> Scala Rules!
```

Great! We can now print to the console.

In order to test ```printString()```, we would have to mock the method using a mocking library like *mockito*.  Since we always want to avoid extraneous libraries and because our code is tested more easily without the concrete dependencies, we will restructure to code so that it is easier to test and more versatile. 

### Testing Without a Mock

If we where to write our test without a mock, what would be the Unit test?  We could try to write a test for the expected outcome of the string, but since our return type is ```Unit```, there is no return. 

Let's write a test as if there was a return. 

``` scala
import org.scalatest.FunSpec

class RenderSpec extends FunSpec {
  describe("printString") {
    it("prints a string to the console") {
      val testString = "Scalatastic"
      val expected = "Scalatastic"
      val actual = printString(testString)

      assert(actual == expected)
    }
  }
}
```

### Failing Test

The test fails, as ```printString()``` does not actually return anything.  How can we test a method that does not return anything? This is the issue with a hard dependency, it is difficult to test as the only outcome is a side-effect of printing.  However, if we refactor our code with a method which takes a callback as an argument, we can change the behavior in our test case.

Here is the refactored ```renderString()``` which has an additional argument for passing a rendering method. When calling the below refactored code, we will pass ```Console.println()``` as the second argument, maintaining the functionality of the original code, while allowing for simple testing with a mock output (no mocking library needed), and removing the hard dependency on ```Console.println()```.

``` scala
def renderString(s: String, output: String => Unit): Unit = output(s)
//=> res1: Any = ()

renderString("Scala Rules!", Console.println()) 
//=> Scala Rules!
//=> res2: Any = ()
```

# Testing RenderString()


Without further ado, we can begin testing our ```RenderString()``` method. First, let's look at the difficulty in testing the functionality of the original ```printString()``` method. To test the method, we would need to be able to know whether the Scala native method ```Console.println()``` had been called. 

Mocking libraries provide ```Spies``` which allow us to see if a method was call, and how many times it was called.  Spies can be avoided by passing in a mocked function which has a different behavior.  Since we have already refactored ```renderString()``` to accept a callback method, we can pass a mocked printing function to ```renderString``` for testing.

The goal is a Unit test, so our mocked printing method will return the string instead of printing it to the console.

``` scala 
def mockPrintln(s: String): String = s
//=> mockPrintln: (s: String)String
```

Now, passing ```mockPrintln()``` to ```renderString()``` as an argument will alter the behavior to return the value instead of printing to the console.  

## Writing the Modified Test

We can write our test based on our expected outcome: we pass the method a ```String``` and expect the same ```String``` to be returned. We will add our mocked method definition to the top of the class, to be used in further tests.

``` scala 
//import the testing library
import org.scalatest.FunSpec

class RenderSpec extends FunSpec {

  def mockPrintln(s: String): String = s

  describe("renderString") {
    it("displays the string passed") {
      val testString = "Scalalicious"
      val expected = "Scalalicious"
      //call the mocked method to return the string
      //instead of printing to the console
      val actual = renderString(testString, mockPrintln)
      assert(actual == expected)
    }
  }
}
```



## Error, type mismatch

![Sad Dog]({{ site.url }}/assets/saddog.jpg)

Don't dispair, failure let's us know our tests or static types are doing their job. Due to the strict typing of the methods, we will have to slightly adjust the ```renderString()``` code in order to allow for a string to be returned.  We will eliminate the return type, as it will vary. We also need to change the ```output: String => Unit```  to ```output: String => Any``` to indicate that the passed function can have different outcomes.

``` scala 
def renderString(s: String, output: String => Any) = output(s)
//=> renderString: (s: String, output: String => Any)Any

renderString("Scalatacular!", println())
//=> Scalatacular!
//=> res3: Any = ()

val result = renderString("Scalatacular!", mockPrintln)
//=> result: Any = Scalatastic!


```

With the allow for varied returns, we can rerun the test, and see that it passes.  With the removal of the concrete dependency on ```Console.println()``` the ```renderString()``` method becomes much easier to test.  

# Blues Skies Ahead



Testing gives us confidence, and by structuring Scala code with static types and comprehensive tests give us the peace of mind to know that everything is working as it should.  Limiting dependencies forces us to write managable and maintainable code.  Embrace testing and the blue skies it will bring to your future.







[scalatest]: http://www.scalatest.org/
[scalaTestInstall]: http://www.scalatest.org/install
[scalaSelectTest]: http://www.scalatest.org/user_guide/selecting_a_style
[scalaspec]: https://etorreborre.github.io/specs2/