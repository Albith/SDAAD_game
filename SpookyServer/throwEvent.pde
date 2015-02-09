/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


void throwEvent(Player thrower) { //when a player throws
  Player target = players[1-thrower.id];
  boolean hit = false; //assume no hit, find out below
  if (thrower.human) {
    OscMessage thrownLED = new OscMessage("/ledState");
    if (thrower.shield) {
      thrownLED.add(LED_STROBE_BLUE);
    } else {
      thrownLED.add(LED_STROBE_RED);
    }
    oscP5.send(thrownLED, thrower.ip, broadcastPort);
  }
  if (PROBABILITY_ACCURACY) {
    int dieRoll = floor(random(100));
    hit = thrower.attention >= dieRoll;
  } else {
    hit = thrower.attention >= ATTENTION_THRESHOLD;
  }
  if (hit) {
    if (target.shield) {
      target.shield = false;
      gameEvents.add(new GameEvent("Player "+thrower.id+" throws, hits, and knocks out the shield of Player "+target.id+"!"));
      loseShield.play(0);
  

    } else {
      thrower.wins++;
      gameEvents.add(new GameEvent("Player "+thrower.id+" throws, hits, and wins!"));
      gameState = READYING; //readying on game over
      //lose.play(0);
      
      if(thrower.id==1)
        P1Win.play(0);
      else 
        P2Win.play(0);
      
    }
  } else {
    gameEvents.add(new GameEvent("Player "+thrower.id+" throws and misses!"));
    throwAndMiss.play(0);
    

 
  }
  
  if (gameState == PLAYING) {
    ball.holder = target;
    updateClientLEDStates();
  } else if (gameState == READYING) {
    OscMessage victoryMsg = new OscMessage("/ledState");
    OscMessage lossMsg = new OscMessage("/ledState");
    victoryMsg.add(LED_STEADY_GREEN);
    lossMsg.add(LED_OFF);
    if (thrower.human) {
      oscP5.send(victoryMsg, thrower.ip, broadcastPort);
    }
    if (target.human) {
      oscP5.send(lossMsg, target.ip, broadcastPort);
    }
    for (int i = 0; i < players.length; i++) {
      players[i].resetPlayer();
    }
  }
   
}
