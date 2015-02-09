/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/

String serverIP = "127.0.0.1"; //type server IP between "s


final int THROW_THRESHOLD = 400; //relatively abstract, arbitrary number for accelerometer reading to need to exceed for a gesture message to server

// **** ------

import io.thp.psmove.*; //import move library
import neurosky.*; //import neurosky library
import org.json.*; //import json things for neurosky

PSMove move; //declare move controller object
boolean moveButtonDown = false; //keep track of move button's state
boolean psButtonDown = false; //ditto, PS button
int vibration = 0; //how much to vibrate controller, 0-255

final int LED_OFF = -2; //for pre-/post-game, loss
final int LED_STEADY_YELLOW = -1; //for ready
final int LED_STEADY_WHITE = 0; //for face-off
final int LED_STROBE_RED = 1; //no shield or ball
final int LED_STROBE_BLUE = 2; //ball, no shield
final int LED_STEADY_RED = 3; //shield, no ball
final int LED_STEADY_BLUE = 4; //shield and ball *UNCHANGED*
final int LED_STEADY_GREEN = 5; //winner
int ledState = LED_OFF; //keep track of player state given from server, off to start

ThinkGearSocket neuroSocket; //declare ThinkGearSocket object
//declare, initialize attention/meditation values
int attention=0; 
int meditation=0;
boolean reading=false; //we don't properly read att/med immediately, so here's a flag

boolean chanceAccuracy = false; //will find out how to use vibration from server based on accuracy model
int vibrationThreshold = 50; //if not chance-based, only vibrating when will hit... find out actual value from server

import oscP5.*; //import libraries necessary for oscP5 networking
import netP5.*;

OscP5 oscClient; //declare osc client object
//port for server to receive messages from clients
int serverListenPort = 32001;
//port clients need to have open
int myListenPort = 12001;
//hold onto server location
NetAddress serverLocation;

void setup() { //at beginning...
  frameRate(20); //framerate can be low, better to communicate with server less often
  size(20,20); //we're not looking at any graphics with our client, so make a small window
  move = new PSMove(0); //initialize "move" to 0th (1st) controller connected
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this); //initialize socket object
  oscClient = new OscP5(this, myListenPort);
  serverLocation = new NetAddress(serverIP,serverListenPort);
  try { //start up socket object
    neuroSocket.start();
  } 
  catch (java.net.ConnectException e) {
    println("ThinkGear issue."); //print something in case of problem
  }
  println("client waiting for solid att/med data"); //just printing a note that we won't connect immediately
}

void draw() { //every frame...
  //if we're not "properly reading" att/med values, make sure that is still true
  if (!reading && meditation != 0 && attention !=0) { //med/att will both be 0 if we're not really reading
    //so, if we think we're not reading but med/att aren't both 0, we should be
    reading = true;
    println("client done waiting");
    //connect to game
    OscMessage connectMsg = new OscMessage("/connect");
    connectMsg.add("trying to connect!");
    oscClient.send(connectMsg, serverLocation);
  }
  
  while (move.poll() != 0) {}
  
  //check accelerometer data
  checkAccel();
  
  //check move's buttons
  checkButton();
  
  //set LEDs
  setLEDs();
  
  //update move's LEDs and rumble (setting and updating LEDs are different)
  if (chanceAccuracy) {
    vibration = floor(map(attention, 0, 100, 0, 255));
  } else {
    if (attention >= vibrationThreshold) {
      vibration = 255;
    } else {
      vibration = 0;
    }
  }
  //don't vibrate if we don't have the ball
  if (ledState == LED_STEADY_RED || ledState == LED_STROBE_RED) vibration = 0;
  move.set_rumble(vibration); 
  move.update_leds();
}



void stop() { //housekeeping for when we shut down
  neuroSocket.stop();
  super.stop();
}
