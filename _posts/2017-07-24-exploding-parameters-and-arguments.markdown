---
layout: post
title:  "Exploding Parameters and Arguments"
date:   2017-07-23 12:00:00 -0500
categories: scala design
excerpt_separator: <!--more-->
---
![nebulaExplosion]({{ site.url }}/assets/nebula-explosion.jpg)

Some explosions cause the most steadfast minds of our generations and generations of the past to pause in awe and wonder.  Some explosions can make the best minds around you wonder if you are sane or competent.  I hope to inspire awe one day, and perhaps for some I might have in the past.  Today is not that day, but perhaps today I can inspire confidence through my own awe-less explosion.

I have been designing (HA!) an overly complex implementation of Tic Tac Toe in Scala.  Overly complex as the design has exploded out of control, and when using static typing in Scala, the types can become out of control if language features and good design are not taken advantage of. 

If I had known better (and I thought I did) I would never have gotten into this situation.

<!--more-->

Humans adhere to the **7 +/- 2** rule. This means that we can keep in working memory **5-9** items at a time.  While there are methods to increase your working memory capacity by grouping similar items into groups (chunking), it is better to develop tools and practices that ensure we don't need to worry about or working memory limit.  

For example, in my miniMax method for the AI of my Tic Tac Toe game, here is what the old method definition looked like.  Be wary, it is truly hard to look at. 

``` scala
def getComputerMove(
    origBoardState: List[String],
    maxPlayerToken: String,
    minPlayerToken: String,
    currentPlayerToken: String,
    ttTable: TTTable.TranspositionTable,
    difficulty: String): Int = {

  def miniMax(
    currentBoard: List[String],
    depth: Int,
    maxT: String,
    minT: String,
    curT: String): Map[Int, Int]  = {
    ...
  }
  minimax(origBoardState, 1, maxPlayerToken, 
    minPlayerToken, maxPlayerToken)
}
```

Above, ```getComputerMove``` is the method for getting a computer move, which comes in three difficulties and calls the recursive method ```miniMax```.

While it is not the ugliest method call I have ever written, it is also not my proudest.  My goal was to make my method more manageable and maintainable. I want someone who stumbles upon my code to not run in fear, and today when I sat down to increase functionality of the algorithm I wanted to run for the hills.  

It also made it overly difficult to pass new versions of the updated arguments into the recursive function.  I began by abstracting all arguments used in the method and the recursive method into a class that could be initialized each time I need to update the arguments to pass to a recursive function. 

Here is the arguments abstracted into a class that can be initialized.

``` scala
class AIParams(
    board: List[String],
    currDepth: Int,
    maxT: String,
    minT: String,
    curT: String,
    transTable: TTTable.TranspositionTable,
    diff: String) {

    val boardState: List[String] = board
    val currentDepth: Int = currDepth
    val maxToken: String = maxT
    val minToken: String = minT
    val currentToken: String = curT
    val ttTable: TTTable.TranspositionTable = transTable
    val difficulty: String = diff
    val boardSize: Int = boardState.length
  }
```

To initialize the ```AIParams``` class as an object the ```new``` keyword is used like so.

``` scala
val params = new AIParams(board, 1, "X", "O", "X", ttTable, "hard")
```

Here is the new refactored ```getComputerMove``` and ```miniMax``` methods.  What is especially exciting is our type can now be declared as **AIParams**.  The class has become a Static Type! And it fully checks that all values and functions declared in the class are checked for type at compilation.  This was a revelation for me, it will change the way I program forever.

``` scala 
def getComputerMove(compAiParams: AIParams): Score = {
   ...

    def miniMax(aiParams: AIParams, firstMove: Int): Score  = {
      ...
    }
  ...
  miniMax(compAiParams)
}
```

Today I realized what abstraction can truly look like, and I am sure that I am only scratching the surface.