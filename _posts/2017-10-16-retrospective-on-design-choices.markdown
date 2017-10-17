---
layout: post
title: Design Choice Retrospective
date:   2017-10-16 12:00:00 -0500
categories: design
excerpt_separator: <!--more-->
---

The apprenticeship is a very personal experience.  For many the choices that led to apprenticeship at 8th Light where deliberate. For me it was a sustained two year effort and hundreds of hours of self guided learning.

In retrospect, teaching myself the basics of programming was far easier than confronting my own weakness. Working hard day after day is my strength.  The determination to make something work, track down a bug, or push through until the ah-ha moment is my strength.  Curiosity is my strength.

My weakness has been a lack of vision for where design patterns are appropriate, where my methods are error prone, and the speed at which I assimilate new design patters.

In order to truly understand a design pattern like the builder pattern, I need to spend some time with it.

# Less than ideal choices

In the Java HTTP Serve project, I implemented a builder pattern for two objects.  In the server requests are parsed using a builder pattern to produce a RequestParameters Object. The RequestParameters object is routed to a controller based on static and dynamic routeing (static has preference), the controller then constructs a ResponseParameters object (again using a builder pattern) which is then passed back up to the Server.  The server then uses a sending class to dispatch the response.

My weakness comes when I fail to see how the pattern is better than my hacky solution, and I find myself resisting the refactor to a more accepted pattern.  In retrospect I am identifying this as a weakness because the improvements where vast and the refactor took a relatively small amount of time compared to the benefit.

I implemented the builder pattern as it is more flexible than the factory pattern.  In retrospect there was no need for the flexibility.  A factory pattern would have sufficed as each object is instantiated at a single point in time during the life cycle of a request.

Passing the entire request into a factor would have lead to a less leaky abstraction, a more succinct call, and a clearer interface.

# A good choice, but after a poor one

In my Scala Console TicTacToe, the game loop was written in the first week of my apprenticeship.  It works.  That is about the best thing I can say about it.  It is testable, tested, and it works.

For transparency, and also to confront my mistakes, here is the game-loop as it currently stands.  To be completely clear, this give me shivers when I look at it.

```scala
@tailrec def go(
  board: List[String],
  players: Map[Int, (String, String, Int)],
  dialogLang: Map[String, String],
  gameOver: Boolean,
  currentPlayer: Int,
  output: String => Any,
  leftPadding: Int,
  whiteSpace: Int,
  getInput: Int => String,
  loopCount: Int,
  ttTable: TranspositionTable): Map[Int, Boolean] = {

    View.renderWhitespace(output, whiteSpace)

    val fBoard = View.formatBoard(board)
    View.renderBoard(output, fBoard, leftPadding)

    val playerNumAnnounce: String = dialogLang("playerAnnounce") + currentPlayer
    View.renderDialog(output, leftPadding, playerNumAnnounce)

    val validPlays: List[String] = Board.returnValidInputs(board)
    val inputPrompt: String = dialogLang("inputPrompt")
    val invalidPlay: String = dialogLang("invalidPlay")
    val playerType: String = players(currentPlayer)._1
    val userToken: String = players(currentPlayer)._2
    val playerDifficulty: Int = players(currentPlayer)._3
    val difficulty: Int = GameSetup.getDifficulty(board, playerDifficulty)
    val oppToken: String = if(userToken == "X") "O" else "X"
    //get the move value
    val boardMove = if(playerType == "human") {
      //human move
      val humanPlay: String = IO.getValidMove(
      validPlays,
      inputPrompt,
      invalidPlay,
      output,
      getInput,
      leftPadding,
      loopCount)
      humanPlay
    } else {
      //AI computer move
      val compMove = AI.negaMax(
      boardState = board,
      nodeMap = Map(0 -> Map()),
      depth = 0,
      maxToken = userToken,
      minToken = oppToken,
      currentToken = userToken,
      depthLimit = difficulty)
      compMove
    }

    val updatedBoard: List[String] = board.map(
    x => if (x == boardMove.toString) userToken else x
    )

    val gameOver: Boolean = Board.gameOver(updatedBoard)

    if(gameOver) {
      View.renderWhitespace(output, whiteSpace)
      val endBoard: List[List[String]] = View.formatBoard(updatedBoard)
      View.renderBoard(output, endBoard, leftPadding)
      View.renderDialog(output, leftPadding, dialogLang("gameOver"))
      val isWin: Boolean = Board.checkWin(updatedBoard)

      if (isWin) {
        View.renderDialog(output, leftPadding, playerNumAnnounce, dialogLang("win"))
      } else {
        View.renderDialog(output, leftPadding, dialogLang("tie"))
      }

      View.renderWhitespace(output, 5)
      //this is the return value of the game
      Map(currentPlayer -> isWin)
    } else {
      val nextPlayer: Int = if(currentPlayer == 1) 2 else 1
      val newLoopCount = loopCount + 1

      go(
      updatedBoard, players, dialogLang, gameOver = false, nextPlayer, output,
      leftPadding, whiteSpace, getInput, newLoopCount, ttTable)
    }
  }
```
When writing the interface for the core logic of the game, I created a GameState class, which returns an instance of the GameState class for every class function called. This allows more pleasing, less leaky (a lot less leaky) abstraction, and is infinitely easier to understand. 

Here is the game loop logic to progress through a human move and a computer move. Much cleaner.

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

# A new interest, but still a weakness

Design has been the most difficult aspect of programming for me.  I realize that this is my weakness, and it has also evolved into an interest.  I find design patterns utterly fascinating. However, after reading about different patterns I still have to implement each pattern fully before I internalize each.

This is not something I am used to.  Though through my self learning process I would dive in and try to make things work, not learning by reading.  My goal now in my design research is to understand basic implementation and use cases so that in the event I am presented with a use case, I can recognize and implement it.


