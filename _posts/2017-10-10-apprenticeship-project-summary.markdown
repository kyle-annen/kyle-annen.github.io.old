---
layout: post
title: Apprenticeship Project Overview
date:   2017-10-10 12:00:00 -0500
categories: JVM
excerpt_separator: <!--more-->
---

# General Structure

![apprenticeship]({{ site.url }}/assets/ApprenticeProjects.png)

<!--more-->

# Main Dependencies
-------
### Tic Tac Toe: Scala <img src="https://travis-ci.org/kyle-annen/scala-tictactoe.svg?branch=master"/><a href='https://coveralls.io/github/kyle-annen/scala-tictactoe?branch=scoverage'><img src='https://coveralls.io/repos/github/kyle-annen/scala-tictactoe/badge.svg?branch=scoverage' alt='Coverage Status' /></a>


<strong><a href="https://github.com/kyle-annen/scala-tictactoe">Github</a> -- <a href="https://clojars.org/repo/org/clojars/kyleannen/tictactoe/">Clojars Artifact</a></strong>

<strong>Clojars artifact:</strong>

org.clojars.kyleannen.tictactoe

This repository contains the TicTacToe core functionality along with a Game class that runs a console TicTacToe game. The program is written in Scala, and uses only ScalaTest and Scalatastic for testing and sytax checking.  No other third part libraries are utilized.

The AI logic used is a tail recursive, depth-first implementation of NegaMax. For board sizes in excess of 3x3, a progressive depth limiting strategy is utilized. The game is playable at board sizes up to 10x10 without issues.

The public interface is exposed through the GameState class. On initialization, the GameState object contains all the information needed to progress to the next round of hte game.  Each method within the GameState class performs a logical progression of the GameState, and returns an updated GameState object.  This means that the functions can be called successively on a GameState object using dot notation, which results in a concise and transparent game progression function, which also returns an instance of the GameState object.

The GameState.progressGameState() function advances the game state with the indicated human move and the resultant AI move, while checking validity of inputs and for an end-game state. This exposes the functionality of the game logic drastically over the console implementation, and allows for a fairly straight forward dependency use case.

```scala
def progressGameState(): GameState = {
    this.validateGameState()
      .checkGameOver()
      .placeHumanMove()
      .checkGameOver()
      .setComputerMove()
      .placeComputerMove()
      .checkGameOver()
      .checkWinner()
      .checkTie()
      .addMessages()
  }
```


Requirements for the TicTacToe in Scala:
- Console TicTacToe playable Human vs. Human
- 100% Test Coverage for Human vs. Human
- Option to play as Computer or Human
- Unbeatable Computer Player
- Computer will win whenever possible
- Computer will not give up, play to the end
- Integration with TravisCI
- Game playable in Chinese
- Be able to replay or quit game
- Add Easy Difficulty
- Add Moderate Difficulty
- Playable on 4x4 board
- 4x4 Computer vs. Computer to finish in under 30s
- Rewrite MiniMax to use tail recursion.
- Expose core functionality

### JavaServer: Java <img src="https://travis-ci.org/kyle-annen/java-server.svg?branch=master"/>
<strong><a href="https://github.com/kyle-annen/java-server">Github</a> -- <a href="https://clojars.org/repo/org/clojars/kyleannen/javaserver/">Clojars Artifact</a></strong>

org.clojars.kyleannen.javaserver

The JavaServer is a multi-threaded general purpose server which fulfills portions of the HTTP/1.1 specifications. A simple server can be written in Clojure, Scala or Java with the JavaServer artifact as a pom/gradle/lein/sbt dependency.

Here is a bare-bones implementation that checks for a PORT Environment variable. Commented out lines are optional configurations.

```scala
import org.clojars.kyleannen.javaserver.{ConfigureServer, Router}

import scala.util.Properties

object BareBonesServer {
  def start(): Unit = {
    val router = new Router()
//  router.add("GET", "/", new ControllerDirectory)
//  router.disableDirectoryRouting()
//  router.disableFileRouting()
    val port: String = Properties.envOrElse("PORT", "3434")
    val args: Array[String] = Array("-p", port)
    val server = new ConfigureServer().configure(args, router)
    server.run()
  }

  def main(args: Array[String]): Unit = {
    start()
  }
}
```

Requirements for Java Http Server:
- Run from a .jar file
- Server can be started on any port
- Utilize TCP
- Implement Code Coverage Tool
- Only third party library is JUnit
- Cannot use built in JDK server
- Maven as build tool
- TravisCI Integration
- Implement "Hello World"
- Implement "Ping Pong"
- Serve a directory
- Default to working directory, or
- Serve a specified directory
- Serve a .pdf that displays in browser
- Serve a .png that displays in browser
- Download a clicked file other than html, png, pdf, jpg
- Serve a form, when filled displays the form result
- Complete 10,000 requests at 100 concurrency (10MB file)
- Complete 10,000 requests at 100 concurrency (100MB file)
- Complete 10,000 requests at 100 concurrency (1GB file)
- Flat-line memory usage for 10,000 request at 100 concurrency (1GB file)
- Add a shutdown hook
- Expose core functionality

# Specialized Servers
-------
### File Form Directory Server <img src="https://travis-ci.org/kyle-annen/file-directory-form-server.svg?branch=master"/>

<strong>Dependencies:</strong> JavaServer

<strong><a href="https://github.com/kyle-annen/file-directory-form-server">Github</a> -- <a href="https://clojars.org/repo/org/clojars/kyleannen/filedirectoryformserver/">Clojars Artifact</a> -- <a href="https://dry-eyrie-10707.herokuapp.com/">Directory</a> -- <a href="https://dry-eyrie-10707.herokuapp.com/form">Form</a> -- <a href="https://dry-eyrie-10707.herokuapp.com/resources">File</a></strong>

org.clojars.kyleannen.filedirectoryformserver

The File Form Directory Server implements the dynamic directory routing, dynamic file routing, and the form funtions of the JavaServer and exposes them through a browser window.


### Html Tic Tac Toe Server <img src="https://travis-ci.org/kyle-annen/webtictactoe.svg?branch=master"/>

<strong>Dependencies:</strong> JavaServer, TicTacToe

<strong><a href="https://github.com/kyle-annen/webtictactoe">Github</a> -- <a href="https://clojars.org/repo/org/clojars/kyleannen/webtictactoe/">Clojars Artifact</a> -- <a href="https://young-shelf-68199.herokuapp.com/">Heroku Deploy</a></strong>

org.clojars.kyleannen.webtictactoe

A static HTML server that serves up a static TicTacToe game.  The open spaces are links which submit the game parameters through url parameters. A custom controller and a additional Scala object are used to interact with the TicTacToe artifact, generate updated HTML for the next state of the game, and pass the new game board static HTML page back to the client.

### JSON TicTacToe Server <img src="https://travis-ci.org/kyle-annen/jsonserver.svg?branch=master"/>

<strong>Dependencies:</strong> JavaServer, TicTacToe

<strong><a href="https://github.com/kyle-annen/jsonserver">Github</a> -- <a href="https://clojars.org/repo/org/clojars/kyleannen/jsonserver/">Clojars Artifact</a></strong>

org.clojars.kyleannen.jsonserver

<strong>API Endpoint:</strong> https://protected-anchorage-62016.herokuapp.com/

The JSON TicTacToe Server utilizes the JavaServer and TicTacToe to implement a JSON API that accepts a JSON payload and responds with the subsequent game state in a JSON response.

Example JSON payload request:

```json
{
  "board":
    "1,2,3,4,5,6,7,8,9",
  "move":
    "1"
}
```

Example JSON Response:

```json
{
  "board":
    "X,2,3,4,5,O,7,8,9",
  "messages":
    [
      "Please select an open space."
    ]
}
```



# Servers with JSON API Dependencies
------

### Vanilla JS TicTacToe (JsonTicTacToe) <img src="https://travis-ci.org/kyle-annen/jsontictactoe.svg?branch=master"/>

<strong>Dependencies:</strong> JavaServer

<strong>API Dependency:</strong> TicTacToe JsonServer

<strong><a href="https://github.com/kyle-annen/jsontictactoe">Github</a> -- <a href="https://clojars.org/repo/org/clojars/kyleannen/jsontictactoe/">Clojars Artifact</a> -- <a href="https://mysterious-badlands-66536.herokuapp.com/">Live (Heroku)</a></strong>

org.clojars.kyleannen.jsontictactoe

The artifact deployed to heroku is a static file server based on the JavaServer with limited routes and directory serving disabled. The Vanilla JS TicTacToe game utilizes prototypes to build a module which displays the game state and accepts clicks as a trigger to initiate the JSON Request to the JSON TicTacToe server.

The response is handled asynchronously via a call back, which updates the game board and messages variables in the module, and renders the updated game board and messages.

### Angular TicTacToe <img src="https://travis-ci.org/kyle-annen/angular-tic-tac-toe.svg?branch=master"/>


<strong>Dependencies:</strong> JavaServer

<strong>API Dependency:</strong> TicTacToe JsonServer

<strong><a href="https://github.com/kyle-annen/angular-tic-tac-toe">Github</a> -- <a href="https://clojars.org/repo/org/clojars/kyleannen/angulartictactoe/">Clojars Artifact</a> -- <a href="https://desolate-harbor-39385.herokuapp.com/">Live (Heroku)</a></strong>

org.clojars.kyleannen.angulartictactoe

Note: If you are using HTTPS Anywhere, you will need to disable for the API to finish the call.

The artifact deployed to heroku is a static file server based on JavaServer with limited routes and directory server disabled.  The Angular 2 application is built using `ng build` and deployed with SBT.  The Angular app portion is a very simple Angular application that updates component values based on a JSON Request and Response from the JSON TicTacToe Server.
