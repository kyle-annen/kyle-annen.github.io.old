---
layout: post
title:  The Builder Pattern
date:   2017-08-20 12:00:00 -0500
categories: patterns java polymorphism
excerpt_separator: <!--more-->
---
![builder1]({{ site.url }}/assets/builder1.jpg)

I often find myself struggling with two of the SOLID design principles of software engineering:

- Single Responsibility
- The Open / Closed Principal

<!--more-->

## Single Responsibility

The Open/Closed Principal states that a class should only have a single responsibility.  As I begin tackling the inevitable new language on a new project, my functions become bloated as I try to hack together something, anything, that works.  

Bloated functions are simple enough to solve, isolating specific functions which you can replace with a sentence to describe the action a block of code is performing.  

This bit of Java over here parsed the HTTP verb out of a http request header. We can refactor this block into a function:

``` java
String getHttpVerb(HttpHeader header) {

}
```

That bit of Scala sums the values and multiplies them by two, it can be refactored into a function:

``` scala

def multiplyByTwo(Int: number): Int = {
  number * 2;
}
```

## The Open / Closed Principle

The open/closed principle states that a class or function should be open to extension by closed to modification.

In more straightforward language, a class or function should be able to accept additional functionality through extension without breaking the rest of the codebase.  The existing code should be closed to modification, in order to preserve the stability of the code base.

This is one of my struggles, building code that is expressive, has a single responsibility and yet adheres to the open/closed principle. 

A colleague recently was kind enough to take time out of a very busy day to share the Builder Pattern with me, and I have since become quite intrigued with the possibilities of the pattern.



## The Builder Pattern

![builder1]({{ site.url }}/assets/builder2.jpg)

The builder pattern is a seemingly complex pattern for the construction of an object.  It was first presented by Joshua Bloch in his ***Effective Java Reloaded*** talks at Java One.

The goal of the pattern is to limit the use of many constructors when few parameters are required and many are optional. 


In Java overloading is defining the same method multiple times with a different types or numbers of arguments. 

This allows polymorphism, different behavior based on what is passed to the function.

Instead of defining the same constructor many times, the builder pattern uses successive constructor calls of a subclass Builder in order to construct and return the Builder object.  Once the construction is sufficient, the `build()` function to return the constructed class.

## Solving a real world problem

HTTP/1.1 is the standard used to outline how communication over HTTP should be conducted.  The following code examples will use the parsing of an HTTP/1.1 request and construction of a RequestParameters used by an HTTP server to generate a response.

## HTTP Request Overview

![builder3]({{ site.url }}/assets/builder3.png) 

A HTTP request is comprised of an initial line, which contains the request type using an HTTP Method Type or HTTP Verb, as well as the requested resource and the protocol version, most commonly HTTP/1.1. Following each line there is a carriage return **\r\n**.  

The succeeding lines represent different optional parameters such as encoding, accepted response types, host designation, and more. Following the header there is a blank line, followed by the body.  The request below does not contain a body.


``` text
GET / HTTP/1.1
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
Host: www.google.com
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive
```

When the above message is sent in bytes or as plain text over HTTP/1.1, it will be received with the carriage return which needs to be parsed out.  It will resemble the line below, depending on how the incoming stream is read.

``` text
GET / HTTP/1.1\r\nUser-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT\r\nHost: www.google.com\r\nAccept-Language: en-us
Accept-Encoding: gzip, deflate\r\nConnection: Keep-Alive\r\n\r\n
```

The last line will have two successive carriage returns. 

## Building a Builder

The goal of the builder pattern is to be able to create an object instance in a way that seems like a functional pattern for those familiar with functional languages. 

``` java 
RequestParameters requestParams =
           new RequestParameters.RequestBuilder(directoryPath)
            .setHttpVerb(httpMessage)
            .setRequestPath(httpMessage)
            .setHost(httpMessage)
            .setUserAgent(httpMessage)
            .setAccept(httpMessage)
            .build();
```

The code above uses a class defined using the builder pattern **RequestParameters**, with a subclass **RequestBuilder**. The initial instantiation of the Request builder instantiates with a constructor, taking the only required parameter which is the **directoryPath**. 

  The **directoryPath** is the root directory that the web server is serving. It is used to locate the resources on the server which are being requested.

The builder could also be instantiated and not built, if there is more building steps to be completed at another time. The above code would then look like the below.

``` java
RequestParameters.RequestBuilder requestParams =
           new RequestParameters.RequestBuilder(directoryPath)
            .setHttpVerb(httpMessage)
            .setRequestPath(httpMessage);
```

At some point the `.build()` function can be called in order to complete the construction of the **RequestParameters** object.

``` java
RequestParameters finalRequestParamsObject = requestParams.build();
```

So, as a brief overview, we have an instantiation of a subclass, which has constructor functions and a build function which returns the instantiation of the parent class object.

Here is the complete code for the builder pattern described above. 

``` java 
import java.util.ArrayList;
import java.util.Arrays;

public class RequestParameters {
  //final RequestParameters object parameters
  private final String directoryPath;
  private final String httpVerb;
  private final String requestPath;
  private final String host;
  private final String userAgent;
  private final String[] accept;

  //Constructor that accepts the builder object
  private RequestParameters(RequestBuilder builder) {
    this.directoryPath = builder.directoryPath;
    this.httpVerb = builder.httpVerb;
    this.requestPath = builder.requestPath;
    this.host = builder.host;
    this.userAgent = builder.userAgent;
    this.accept = builder.accept;
  }

  //getter methods for the resultant RequestParameters object
  String getDirectoryPath() { return directoryPath; }

  String getHttpVerb() { return httpVerb; }

  String getRequestPath() { return requestPath; }

  String getHost() { return host; }

  String getUserAgent() { return userAgent; }

  String[] getAccept() { return accept; }

  //Request builder subclass
  public static class RequestBuilder {
    private final String directoryPath;
    private String httpVerb;
    private String requestPath;
    private String host;
    private String userAgent;
    private String[] accept;
    
    //Constructor for the only required parameter
    public RequestBuilder(String directoryPath) {
      this.directoryPath = directoryPath;
    }

    //subsequent setters for optional parameters
    public RequestBuilder setHttpVerb(ArrayList<String> httpMessage) {
      String initialLine = httpMessage.get(0);
      this.httpVerb = initialLine.split(" ")[0].trim();
      return this;
    }

    public RequestBuilder setRequestPath(ArrayList<String> httpMessage) {
      String initialLine = httpMessage.get(0);
      this.requestPath = initialLine.split(" ")[1].trim();
      return this;
    }
    
    //setters with parsing next
    public RequestBuilder setHost(ArrayList<String> httpMessage) {
      String host = null;
      for(String line: httpMessage) {
        String headerField = line.split(" ")[0];
        if(headerField.equals("Host:")) {
          host = line.split(" ")[1].trim();
        }
      }
      this.host = host;
      return this;
    }

    public RequestBuilder setUserAgent(ArrayList<String> httpMessage) {
      String userAgent = null;
      for(String line: httpMessage) {
        String headerField = line.split(" ")[0];
        if(headerField.equals("User-Agent:")) {
          String[] userAgentList = line.split(" ");
          String[] noHeaderFieldList =
                  Arrays.copyOfRange(userAgentList, 1, userAgentList.length);
          userAgent = String.join(" ", noHeaderFieldList).trim();
        }
      }
      this.userAgent = userAgent;
      return this;
    }

    public RequestBuilder setAccept(ArrayList<String> httpMessage) {
      String[] accept = null;
      for(String line: httpMessage) {
        String headerField = line.split(" ")[0];
        if(headerField.equals("Accept:")) {
          String[] AcceptList = line.split(" ");
          accept = Arrays.copyOfRange(AcceptList, 1, AcceptList.length);
        }
      }
      this.accept = accept;
      return this;
    }

    //final build function
    public RequestParameters build(){ return new RequestParameters(this); }
  }
}
```





