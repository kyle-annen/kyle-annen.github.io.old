---
layout: post
title:  "Recursion Showdown: Tail vs Head"
date:   2017-07-31 12:00:00 -0500
categories: scala recursion tail-recursion
excerpt_separator: <!--more-->
---
![showdown]({{ site.url }}/assets/showdown.jpg)


In implementing the AI for a TicTacToe game, I was prompted to transition from a head recursive algorithm to a tail recursive one.

And you know what that mean folks, a gosh darn showdown at high noon! We are going to pit these two lilly livered (and a bit long winded) algorithms against one another and see if they have any grit.

First things first, why should we care? Tail recursion does not increase the call stack, or the number of method calls that have to be stored in memory prior to executing the code. 
<!--more-->
Mathematically **head recursion** would look something like the function below.  After evaluating **f(x)**, we add one.  Then evaluate the wrapping function with the result, add one again, and continue until there are no more wrapping functions.  This type of call is extremely memory intensive, as it has to hold all the values and methods in memory until the result is found. 

``` mathematica
f(f(f(f(x)+1)+1)+1)+1)
```

## Head Recursion

A **head recursive** algorithm performs an operation on the recursive call. Here is the pseudo-code for a minimax head recursion, pulled from the Wikipedia article for the [MiniMax][minimax] algorithm.  



``` java
function minimax(node, depth, maximizingPlayer)
     if depth = 0 or node is a terminal node
         return the heuristic value of node

     if maximizingPlayer
         bestValue := −∞
         for each child of node
             v := minimax(child, depth − 1, FALSE)
             bestValue := max(bestValue, v)  //<-computation on result
     else    (* minimizing player *)
         bestValue := +∞
         for each child of node
             v := minimax(child, depth − 1, TRUE)
             bestValue := min(bestValue, v) //<-computation on result
         return bestValue
```

The portion that makes the above pseudo-code **head recursive** is highlighted with comment arrows. The two commented lines **min** or **max** the result of the Minimax call, which means that the recursive calls are not at the end of each logical path, so they are not in the tail position. 

## Tail Recursion

On the other hand, a tail recursive call has only the recursion call in the tail position, meaning that the value returned is the value returned by the recursive call.  Mathematically a tail recursion call would look more like this.

``` mathematica 
f(f(f(f(f(x)))))
```

Here is a **tail recursive** function from [ScalaExcercises.org][tailrecursion] which does not perform any operations on the result of the recursive call.  I have added the tail call recursion annotation that will allow the Scala compiler to throw an error if the method is not tail call optimized (**@tailrec**).

``` scala 
@tailrec def gcd(a: Int, b: Int): Int =
  if (b == 0) a else gcd(b, a % b) //<--- no operation, only return
```


I have modified a method from [StackOverflow][stackoverflow] in order to test the execution time on an empty 3x3 board.

``` scala 
def time[R](block: => R): R = {
    val t0 = System.nanoTime()
    val result = block
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) / 1000000 + "ms")
    result
}
```

# Showdown
Without further ado, here are the surprising results.  

***Head Recursive MiniMax***

Elapsed time: 2923ms

***Tail Recursive NegaMax***

Elapsed time: 5572ms

It turns out that the while the implementations are somewhat similar, there is not a large time saving in the tail recursive version. There are a few possible reasons why it was actually slower.

### Large Memory

The computer I used to run the tests has a large amount of RAM, 16GB.  It is possible that the amount of ram is throwing enough resources at the inefficient algorithm (in terms of memory usage) to not have a noticeable effect. 

### Extensive Tree Manipulation

In order to not simply map over the various states, it is necessary to not only keep track of where you are in the decision tree, you must also track where you have been. Many supporting methods were written in order to help with the decision tree, which is referred to as the NodeMap in the code below.


# Tail Recursive NegaMax Code
``` scala
@tailrec def negaMax(
    boardState: List[String],
    nodeMap: NodeMap,
    depth: Int,
    maxToken: String,
    minToken: String,
    currentToken: String,
    depthLimit: Int): Position = {
    val allScored: Boolean = isDepthFinished(nodeMap(depth))
    if(nodeMap(0).size == 0) {
      val newOpenMoves = generateOpenMoves(boardState)
      val newNodeMap = generateNodeMap(newOpenMoves,0,Map())
      negaMax(boardState,newNodeMap,depth,maxToken, minToken, currentToken, depthLimit)
    } else if(allScored && depth == 0) {
      val bestMove = nodeMap(0).maxBy(_._2.value)._1
      bestMove
    } else if(allScored) {
      val previousBoardState = rollBackBoard(boardState, depth, nodeMap)
      val scoreDepthAndPrunedNodeMap = setDepthScore(nodeMap, depth, maxToken == currentToken)
      val changeToken = if(currentToken == maxToken) minToken else maxToken
      negaMax(
        previousBoardState, 
        scoreDepthAndPrunedNodeMap, 
        depth - 1, 
        maxToken, 
        minToken, 
        changeToken, 
        depthLimit)
    } else {
      if (depth >= depthLimit) {
        val position: Position = getFirstOpenPosition(nodeMap, depth)
        val rawScore: Int = (1000 - depth.toInt - 2)
        val depthLimitScore: Int = if(maxToken == currentToken) rawScore else rawScore * -1
        val depthScore: Score = new Score(position, depthLimitScore, "depthLimit", true)
        val depthLimitNodeMap = updateScore(depth, position, nodeMap, depthScore)
        negaMax(
          boardState, 
          depthLimitNodeMap, 
          depth, 
          maxToken, 
          minToken, 
          currentToken, 
          depthLimit)
      } else {
        val position: Position = getFirstOpenPosition(nodeMap, depth)
        val tempBoard = updateBoard(boardState, position, currentToken)
        val tempNodeMap = updateScore(depth, position, nodeMap, new Score(position, 0, "current", false))
        val isWin: Boolean = Board.checkWin(tempBoard)
        val isTie: Boolean = Board.checkTie(tempBoard)
        if (isWin || isTie) {
          val leafScore = getLeafScore(position, depth, tempBoard, currentToken == maxToken)
          val newNodeMap = updateScore(depth, position, tempNodeMap, leafScore)
          negaMax(boardState, newNodeMap, depth, maxToken, minToken, currentToken, depthLimit)
        } else {
          val changeToken = if(currentToken == maxToken) minToken else maxToken
          val deeperOpenMoves = generateOpenMoves(tempBoard)
          val deeperNodeMap = generateNodeMap(deeperOpenMoves, depth + 1,tempNodeMap)
          negaMax(
            tempBoard, 
            deeperNodeMap, 
            depth + 1, 
            maxToken, 
            minToken, 
            changeToken, 
            depthLimit)
        }
      }
    }
  }

Elapsed time: 5572ms

```

# Head Recursive MiniMax
``` scala

    def miniMax(
      currentBoard: List[String],
      depth: Int,
      maxT: String,
      minT: String,
      curT: String): Map[Int, Int]  = {

      val depthLimit = setDepthLimit(boardSize, difficulty, depth)
      val openMoves = Board.returnValidInputs(currentBoard).map(x => x.toInt - 1)

      val scores = openMoves.map(move =>
        if(depth >= depthLimit) {
          val depthLimitScore = if(curT == maxT) -1000 + depth + 2 else 1000 - depth - 2
          Map(move -> depthLimitScore)
        } else if(curT == maxT) {
          val maxScore = 1000 - depth
          val maxBoardMove: List[String] = currentBoard.map(x => if(x == (move+1).toString) curT else x)
          val maxWin = Board.checkWin(maxBoardMove)
          val maxTie = Board.checkTie(maxBoardMove)
          if(maxWin) {
            Map(move -> maxScore)
          } else if(maxTie) {
            Map(move -> 0)
          } else {
            val checkTransTable = TTTable.checkTransposition(maxBoardMove, ttTable, maxT, minT, "max")
            if(checkTransTable._1 == true) {
              Map(move -> checkTransTable._2)
            } else {
              val mmResult = miniMax(maxBoardMove, depth + 1, maxT, minT, minT)
              val mmScore = mmResult(mmResult.keys.head)
              Map(move -> mmScore)
            }
          }
        } else {
          val minScore = -1000 + depth
          val minBoardMove: List[String] = currentBoard.map(x => if(x == (move+1).toString) curT else x)
          val minWin = Board.checkWin(minBoardMove)
          val minTie = Board.checkTie(minBoardMove)
          if(minWin) {
            Map(move -> minScore)
          } else if(minTie) {
            Map(move -> 0)
          } else {
            val checkTransTable = TTTable.checkTransposition(minBoardMove, ttTable, maxT, minT, "min")
            if(checkTransTable._1 == true) {
              Map(move -> checkTransTable._2)
            } else {
              val mmResult = miniMax(minBoardMove, depth + 1, maxT, minT, maxT)
              val mmScore = mmResult(mmResult.keys.head)
              Map(move -> mmScore)
            }
          }
        }
      )

      val mapScores = scores.flatten.toMap

      if(curT == maxT) {
        val v = -1001
        val maxTupleScore = mapScores.maxBy(_._2)
        val maxMapScore = Map(maxTupleScore._1 -> maxTupleScore._2)
        alphaBeta.alpha = List(maxTupleScore._2, alphaBeta.alpha.toInt, v).max
        if(alphaBeta.beta <= alphaBeta.alpha) {
          Map(maxTupleScore._1 -> v)
        } else {
          maxMapScore
        }
      } else {
        val v = 1001
        val minTupleScore = mapScores.minBy(_._2)
        val minMapScore = Map(minTupleScore._1 -> minTupleScore._2)
        alphaBeta.beta = List(minTupleScore._2, alphaBeta.beta.toInt, v).max
        if(alphaBeta.beta <= alphaBeta.alpha) {
          Map(minTupleScore._1 -> v)
        } else {
          minMapScore
        }
      }
    }

  Elapsed time: 2922.966766ms
  ```


[stackoverflow]: https://stackoverflow.com/questions/9160001/how-to-profile-methods-in-scala
[minimax]: https://en.wikipedia.org/wiki/Minimax
[tailrecursion]: https://www.scala-exercises.org/scala_tutorial/tail_recursion