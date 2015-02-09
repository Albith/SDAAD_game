/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/



// **** customization
final boolean SOLO_TESTING = true;
final int AI_DIFFICULTY = 1; //value 1-3 for AI difficulty, if applicable (3 hardest)
final boolean AI_NEVER_GETS_SHIELD = false; //true if you want AI to never get shield

final boolean START_WITH_SHIELD = false; //do players start with shield?
final int MEDITATION_THRESHOLD = 70; //minimum meditation value to turn shield on
//new idea: shield expires after a period of time if meditation falls below threshold
final int SHIELD_TIMER = 5000; //how many milliseconds shield lasts before needing to be re-engaged, use -1 if shield shouldn't expire

final int MINIMUM_GESTURE_STRENGTH = 600; //how hard a gesture must be to be an attack

final boolean PROBABILITY_ACCURACY = true; //is accuracy chance-based?
final int ATTENTION_THRESHOLD = 50; //minimum attention value to hit opponent (if not chance-based)

final boolean RANDOM_START = false; //give ball 100% randomly? (face-off if not)
final int FACEOFF_MIN = 2000; //minimum faceoff delay, in milliseconds
final int FACEOFF_MAX = 6000; //maximum faceoff delay, in milliseconds

// **** -----------------------------------------------------------------------------------

int faceoffTime; //time in millis for "puck drop"

final int CONNECTING = -3; //constants for gameState
final int READYING = -2;
final int FACEOFF = -1;
final int PLAYING = 0;
int gameState = CONNECTING;

import oscP5.*; //import necesary oscP5 libraries, for networking
import netP5.*;
OscP5 oscP5; //declare oscP5 object
//port for server to receive messages from clients
int listeningPort = 32001;
//port clients need to have open
int broadcastPort = 12001;


Player[] players; //declare arraylist of players
Ball ball; //declare ball object

int playersConnected = 0; //players actually connected (incl. AI)

ArrayList<GameEvent> gameEvents; //record game events in this
int maxGameEvents = 512; //max game events before some get thrown out

void setup() { //at beginning...
  size(700,480);    //Made the window slightly larger.
  gameEvents = new ArrayList<GameEvent>(); //make array list for game log
  oscP5 = new OscP5(this, listeningPort); //initialize oscP5 server object
  players = new Player[2]; //make array of 2 players
  int i = 0; //create counter for populating player array
  if (SOLO_TESTING) { //instantiate AI player if we need one
    players[i] = new Player();
    players[0].id = 0;
    playersConnected++;
    players[0].makeAI(); //create AI player
    gameEvents.add(new GameEvent(" - AI Player 0 created."));
    i++;
  }
  while (i < 2) { //populate player array with 1 or 2 human spots
    players[i] = new Player();
    i++;
  }
  
  startAudio();
}

void draw() { //every frame...
  
  switch (gameState) { //general, "framely" behavior based on game state
    case CONNECTING:
      if (playersConnected == 2) {
        gameState=READYING;
      }
      break;
    case READYING:
      for (int i = 0; i < players.length; i++) {
        if (!players[i].human) players[i].ready = true;
      }
      if (players[0].ready && players[1].ready) {
        if (RANDOM_START) {
          initGame(floor(random(2)));
        } else {
          faceoffTime = millis()+int(random(FACEOFF_MIN, FACEOFF_MAX));
          gameState=FACEOFF;
          updateClientLEDStates();
        }
      }
      break;
    case FACEOFF:
      if (millis() >= faceoffTime && faceoffTime > 0) {
        OscMessage faceoffGoMsg = new OscMessage("/ledState");
        faceoffGoMsg.add(LED_STEADY_WHITE);
        for (int i = 0; i < players.length; i++) {
          if (players[i].human) {
            oscP5.send(faceoffGoMsg, players[i].ip, broadcastPort);
          }
        }
        faceoffTime = -1; //this being -1 means it has passed
      }
      break;
    case PLAYING:
      for (int i = 0; i < players.length; i++) {
        players[i].update();
      }
      break;
    default:
      //
  }
  
  //display info
  drawStateInfo();
  
  //delete game events if necessary
  while (gameEvents.size() > maxGameEvents) {
    gameEvents.remove(0);
  }
}

void initGame(int holderID) {
  ball = new Ball();
  ball.holder = players[holderID];
  faceoffTime = 0;
  gameState = PLAYING;
  updateClientLEDStates();
}
