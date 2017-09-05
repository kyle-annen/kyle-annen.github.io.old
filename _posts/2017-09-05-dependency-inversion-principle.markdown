---
layout: post
title: Solid - dependency inversion principle
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

The dependency inversion principle states that high level modules should not depend on low level modules; both should depend on abstractions. Abstractions should not depend on details.  Details should depend upon abstractions.
<!--more-->
The simplified version is through relying on concepts instead of implementation, relying on the behavior of interfaces, you reduce couping and reduce depending on implementations.

The dependency inversion means that our methods that would have previously relied on classes which implement an interface, we now rely on the lower level abstractions, freeing up the implementation.


Here is an implementation of a plane class, and airport class and a jet class.  This is a bad example of dependency inversion, in order to have the airport manage the jet, both the manager and the unit tests have to be replaced. 

``` java 
class Plane {

	public void fly() {
	}
}

class AirPort {
	Plane plane;

	public void setPlane(Plane plane) {
		this.plane = plane;
	}

	public void launchPlane() {
		plane.fly();
	}
}

class Jet {
	public void fly() {
	}
}
```

Here is a cleaner implementation using an aircraft interface, which many new planes can be added without requiring a change to the airport class or to the unit tests.

``` java
interface Aircraft {
	public void fly();
}

class Plane implements Aircraft{
	public void fly() {
	}
}

class Jet  implements Aircraft{
	public void fly() {
	}
}

class Airport {
	Aircraft aircraft;

	public void setAircraft(Aircraft aircraft) {
		this.aircraft = aircraft;
	}

	public void launchAircraft() {
		Aircraft.fly();
	}
}
```
