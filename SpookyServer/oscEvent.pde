/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


void oscEvent(OscMessage incoming) { //when osc messages come in
  if (incoming.addrPattern().equals("/connect") && gameState == CONNECTING) { //player connecting
    players[playersConnected].ip = incoming.netAddress().address();
    players[playersConnected].id = playersConnected;
    gameEvents.add(new GameEvent("Player "+playersConnected+" connected."));
    
    playersConnected++;
    //let player know accuracy model so they can vibrate the move properly
    OscMessage accuracyModelMsg = new OscMessage("/accuracyModel");
    if (PROBABILITY_ACCURACY) {
      accuracyModelMsg.add("chance");
    } else {
      accuracyModelMsg.add("threshold");
      accuracyModelMsg.add(ATTENTION_THRESHOLD);
    }
    oscP5.send(accuracyModelMsg, incoming.netAddress().address(), broadcastPort);
  } else { //handle all non-connection messages
    //which player is communicating?
    String clientIP = incoming.netAddress().address();
    int clientID = -1;
    for (int i = 0; i < playersConnected; i++) { //find index of messaging client
      if (players[i].ip.equals(clientIP)) {
        clientID = i;
      }
    }
    //figured out index
    if (incoming.addrPattern().equals("/input")) { //player sending input
      if (incoming.get(0).stringValue().equals("gesture")) {
        if (gameState == PLAYING) {
          if (ball.holder.id == clientID && incoming.get(1).intValue() >= MINIMUM_GESTURE_STRENGTH) {
            throwEvent(ball.holder);
          }
        }
      } else if (incoming.get(0).stringValue().equals("button")) {
        gameEvents.add(new GameEvent("Player "+clientID+" button"));
        switch (gameState) {
          case READYING:
            players[clientID].ready = true;
            OscMessage readyLED = new OscMessage("/ledState");
            readyLED.add(LED_STEADY_YELLOW);
            oscP5.send(readyLED, players[clientID].ip, broadcastPort);
            gameEvents.add(new GameEvent("Player "+clientID+ " readied"));
            readying.play(0);

            
            break;
          case FACEOFF:
            int faceoffWinner = -1;
            if (faceoffTime == -1) { //-1 means it has passed
              faceoffWinner = clientID;
              
              gameEvents.add(new GameEvent("Player "+clientID+ " grabbed the ball!"));
              ballGrab.play(0);
          
            } else { //jumped the gun
              faceoffWinner = 1-clientID;
              gameEvents.add(new GameEvent("Player "+clientID+ " went for the ball too early! Ball to opponent!"));
            }
            initGame(faceoffWinner);
            break;
          case PLAYING:
            /*if (ball.holder.id == clientID) {
              throwEvent(ball.holder);
            }*/
            break;
          default:
            //nothing
        }
        
      }
    } //end (if "/input")
    if (incoming.addrPattern().equals("/meditation")) {
      players[clientID].meditation = incoming.get(0).intValue();
    }
    if (incoming.addrPattern().equals("/attention")) {
      players[clientID].attention = incoming.get(0).intValue();
    }
  }
}
