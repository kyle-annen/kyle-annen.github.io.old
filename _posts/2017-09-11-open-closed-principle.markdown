---
layout: post
title: Solid - Open/Closed Principle
date:   2017-09-11 12:00:00 -0500
categories: Solid
excerpt_separator: <!--more-->
---

The Solid principles of software design are five principles that make up the pneumonic SOLID. Each of the letters stand for a different principle of object oriented design.

<span class="formula">$$S = Single\;responsibility\;principle$$</span><br/>
<span class="formula">$$O = Open/closed\;principle$$</span><br/>
<span class="formula">$$L = Liskov\;substitution\;principle$$</span><br/>
<span class="formula">$$I = Interface\;segregation\;principle$$</span><br/>
<span class="formula">$$D = Dependency\;inversion\;principle$$</span>


The Open/Closed principle states that software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification.

This premise is simple to state, but difficult to put into practice.  It can be achieved through polymorphism, use of well defined interfaces, and by implementing good design practices.

In this short blog we will look at some short examples of code which violates this principle, and the ways we can avoid violating it.

<!--more-->

The simplest example of a violation of the open closed principle is when one class calls another class explicitly. This is refered to as a hard dependency and is generally something to be avoided.

In this example we will use a class called traveler who can take different type of transportation. First we will integrate with the Bus class.

``` java
class Traveler {
        Car car = new Car();

        void travelToTerminal(Bus bus) {
                Location busTerminal = bus.getTerminaLocation();
                commutLocally(busTerminal);
        }

        void waitPatiently(Bus bus) {
                Thread.sleep(10000);
                LocalDateTime busDepartureTime = bus.getDepartureTime();
                LocalDateTime timeNow = new LocalDateTime().now("GMT+8");
                Integer minutesTillBoarding = timenow - busDepartureTime;
                if( minutesTillBoarding < 10 ) {
                        bus.checkTicket();
                        bus.board();
                } else {
                        this.waitPatiently(bus);
                }
        }

        private void commuteLocally(Location location) {
                car.enter();
                car.drive(location);
                car.park();
                car.exit();
        }
}
```

``` java
class Bus {
        Location getTerminalLocation() {
        }

        void checkTicket() {
        }

        void board(){
        }

        LocalDateTime getDepartureTime() {
        }


}

```

Perfect.  We now have a traveler that can go to the terminal, wait for the bus, and board the bus on time. Now our product manager lets us know that our traveler has to take Elon's new Hyperloop.  Super cool, and super painful because we violated the open closed principle. To solve this we can change the traveler to accept and interface for transportation instead of relying on the bus or messy if / else loops to determine what to transportation method to use.


Interface defined for transportation:

``` java
public interface Transportation {

        Location getTerminalLocation() {
        }

        void checkTicket() {
        }

        void board(){
        }

        LocalDateTime getDepartureTime() {
        }
}
```
And here is our reworked Bus and Hyperloop, implementing the Transportation interface.


``` java
class Bus {
        @Override
        public Location getTerminalLocation() {
        }

        @Override
        public void checkTicket() {
        }

        @Override
        public void board(){
        }

        @Override
        public LocalDateTime getDepartureTime() {
        }
}

```

``` java
class Hyperloop implements Transportation {
        @Override
        public Location getTerminalLocation() {
        }

        @Override
        public void checkTicket() {
        }

        @Override
        public void board(){
        }

        @Override
        public LocalDateTime getDepartureTime() {
        }
}

```

And finally we can change the Traveler class to rely on the interface and not a specific implementation of the interface. After the changes below the traveler can not have features added (closed to modification) but it can accept any form of transportation which implements the Transportation interface (opend to extension).

``` java
class Traveler {
        Car car = new Car();

        void travelToTerminal(Transportation transpo) {
                Location terminal = transpo.getTerminaLocation();
                commutLocally(terminal);
        }

        void waitPatiently(Transportation transpo) {
                Thread.sleep(10000);
                LocalDateTime transpoDepartureTime = transpo.getDepartureTime();
                LocalDateTime timeNow = new LocalDateTime().now("GMT+8");
                Integer minutesTillBoarding = timenow - transpoDepartureTime;
                if( minutesTillBoarding < 10 ) {
                        transpo.checkTicket();
                        transpo.board();
                } else {
                        this.waitPatiently(transpo);
                }
        }

        private void commuteLocally(Location location) {
                car.enter();
                car.drive(location);
                car.park();
                car.exit();
        }
}
```

