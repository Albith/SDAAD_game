/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


//below, constants for sending info to clients conveniently
final int LED_OFF = -2; //for pre-/post-game, loss
final int LED_STEADY_YELLOW = -1; //for ready
final int LED_STEADY_WHITE = 0; //for face-off
final int LED_STROBE_RED = 1; //no shield or ball
final int LED_STROBE_BLUE = 2; //ball, no shield
final int LED_STEADY_RED = 3; //shield, no ball
final int LED_STEADY_BLUE = 4; //shield and ball
final int LED_STEADY_GREEN = 5; //winner

void updateClientLEDStates()  {
  //loop through players to update LEDs
  for (int i = 0; i < players.length; i++) {
    println(i+":a1");
    int state = -99;
    if (players[i].human) {
      println(i+":a2");
      if (gameState==FACEOFF) {
        state = LED_OFF;
      } else if (gameState==PLAYING) {
        println(i+":a4");
        if (players[i].shield) {
          if (ball.holder == players[i]) {
            state = LED_STEADY_BLUE;
          } else {
            state = LED_STEADY_RED;
          }
        } else { //no shield
          if (ball.holder == players[i]) {
            state = LED_STROBE_BLUE;
          } else {
            state = LED_STROBE_RED;
          }
        } // end if no shield
      }
      //println("server sending player "+i+" LED state "+state);
      OscMessage stateMsg = new OscMessage("/ledState");
      stateMsg.add(state);
      oscP5.send(stateMsg, players[i].ip, broadcastPort);
    }// end if human player
  } //end loop through players
}
