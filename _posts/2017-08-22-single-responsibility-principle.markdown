---
layout: post
title:  Solid - single responsibility principle
date:   2017-08-28 12:00:00 -0500
categories: Solid
excerpt_separator: <!--more-->
---

The Solid principles of software design are five principles that make up the pneumonic SOLID. Each of the letters stand for a different principle of object oriented design.

<span class="formula">$$S = Single\;responsibility\;principle$$</span><br/>
<span class="formula">$$O = Open/closed\;principle$$</span><br/>
<span class="formula">$$L = Liskov\;substitution\;principle$$</span><br/>
<span class="formula">$$D = Dependency\;inversion\;principle$$</span>


The single responsibility principle states that a class or method should only be responsible for one thing, or only have one reason to change. 

The single responsibility can often be stated in a written sentence, simple to write and simple to understand.  This is "smell test" for the single responsibility principle. If the sentence is a run-on or a compound sentence it most likely has more than one responsibility. 

A single responsibility not only makes for more readable code, it also allows for simple unit testing.  There should be limited inputs and a single output ideally.  

If we use tools as an analogy, a single responsibility tool is very good at one type of use. It is better to build a tool set with pieces you can reuse in different places than to rebuild a tool for each task.

![tools]({{site.url}}/assets/pottery-tools.jpg)

# Single responsibility in action

To give a working example to elucidate the single responsibility principle we will build an class to grab weather information from an API.  The goal is to check the weather as it is, at the exact moment the tool is run, in the location it is run from.

To start, we will use the open weather map API to get the weather data.  We will also need a way to access the location of the computer running the command line application.  We will also need a way to display the weather info, as well as a main class to run the program.  So far it looks like four classes may make it to the final version of our app.

First, we will start by writing a ***WeatherGetter*** class to grab the weather data from OpenWeatherMap.

``` java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

public class WeatherGetter {

  String getWeatherData(String city) throws IOException {
    String weatherApiBaseUrl = "http://api.openweathermap.org/data/2.5/weather?q=";
    String apiKey = "&APPID=<your_api_key_here>";
    String apiFullUrl = weatherApiBaseUrl + city + apiKey;
    URL requestURL = new URL(apiFullUrl);
    URLConnection weatherConnection = requestURL.openConnection();
    BufferedReader weatherReader =
            new BufferedReader(new InputStreamReader(weatherConnection.getInputStream()));
    StringBuilder weatherData = new StringBuilder();
    String line;

    while ((line = weatherReader.readLine()) != null) {
      weatherData.append(line);
    }
    weatherReader.close();
    String result = weatherData.toString();

    return result;
  }
}
```

The code above does one thing, it gets the weather data from the API.  It has one output and one input. It is not coupled, and relies on no other portion of the code we are going to write.

However, if we where to describe getWeatherData in one sentence it does not really fit our rule.  

> The function getWeatherData creates the URL request for the API, creates a connection to the URL, uses a string builder and buffered reader to get the JSON for the weather and creates a string that is returned. 

There are pieces of code that can be broken out.  Here we are going to separate out functionality as much as possible.

The first function to separate out is building the request API. We will also move the API key to a constructor.

``` java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

public class WeatherGetter {
  String apiKey;

  WeatherGetter(String _apiKey) {
    this.apiKey = _apiKey;
  }

  String getWeatherData(String city) throws IOException {

    URL requestURL = this.buildRequestURL(city);
    URLConnection weatherConnection = requestURL.openConnection();
    BufferedReader weatherReader =
            new BufferedReader(new InputStreamReader(weatherConnection.getInputStream()));
    StringBuilder weatherData = new StringBuilder();
    String line;

    while ((line = weatherReader.readLine()) != null) {
      weatherData.append(line);
    }
    weatherReader.close();
    String result = weatherData.toString();

    return result;
  }

  URL buildRequestURL(String city) throws MalformedURLException {
    String weatherApiBaseUrl = "http://api.openweathermap.org/data/2.5/weather?q=";
    String apiKeyArgument = "&APPID=";
    String apiFullUrl = weatherApiBaseUrl + city + apiKeyArgument + apiKey;
    return new URL(apiFullUrl);
  }
}
```

The next step is to separate out the reading of the response. With the code below, if we where to surmise the purpose of each function the sentence should come out close to the name of the function. 

The function ***buildRequestUrl*** builds a request URL.

> If there is only one reason now that this function should change, that is if the API changes.  If the API changes, now this is the only function that will have to be changed in the future.

The function ***getUrlResponse** uses the request URL and gets the response from the API (1 input, 1 output).

> There is now only one reason to change this function, and that is if the API provider moves away from a Rest API.  

The function ***getWeatherData*** uses the two helper methods, so is more complex, yet the syntax is succinct and clear. 

> This function should only need to change if we need to add more steps to the process. Perhaps we want to return a Java object instead of a JSON string.  We would then need to add a ***parseJsonWeatherData*** function and then adjust the ***getWeatherData*** to parse the JSON prior to returning.



``` java
import java.io.*;
import java.net.*;

public class WeatherGetter {
  String apiKey;

  WeatherGetter(String _apiKey) {
    this.apiKey = _apiKey;
  }

  String getWeatherData(String city) throws IOException {
    URL requestUrl = this.buildRequestURL(city);
    return this.getUrlResponse(requestUrl);
  }

  URL buildRequestURL(String city) throws MalformedURLException {
    String weatherApiBaseUrl = "http://api.openweathermap.org/data/2.5/weather?q=";
    String apiKeyArgument = "&APPID=";
    String apiFullUrl = weatherApiBaseUrl + city + apiKeyArgument + apiKey;
    return new URL(apiFullUrl);
  }

  String getUrlResponse(URL requestUrl) throws IOException {
    URLConnection weatherConnection = requestUrl.openConnection();
    BufferedReader weatherReader =
            new BufferedReader(new InputStreamReader(weatherConnection.getInputStream()));
    StringBuilder weatherData = new StringBuilder();
    String line;
    while ((line = weatherReader.readLine()) != null) {
      weatherData.append(line);
    }
    weatherReader.close();
    String result = weatherData.toString();
    return result;
  }
}
```








