/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


class Player {
  boolean shield = START_WITH_SHIELD; //start with shield if players start with shield
  int meditation = 0;
  int attention = 0;
  int id = -1; //so player knows its index
  int wins = 0;
  int lastShieldEngage = -SHIELD_TIMER;
  boolean human = true;
  boolean ready = false;
  String ip = "";
  AI ai;
  void makeAI() {
    ai = new AI();
    human = false;
  }
  void resetPlayer() {
    ready = false;
    shield = START_WITH_SHIELD;
  }
  void update() {
    if (!human) updateAIVals();
    if (!shield && meditation >= MEDITATION_THRESHOLD) {
      if (human || !AI_NEVER_GETS_SHIELD) {
        shield = true;
        lastShieldEngage = millis();
        updateClientLEDStates();
        gameEvents.add(new GameEvent("Player "+id+" puts up a shield!"));
        getShield.play(0);
      }
    }
    if (SHIELD_TIMER != -1) {
      if (shield && millis() > lastShieldEngage+SHIELD_TIMER && meditation < MEDITATION_THRESHOLD) {
        shield = false;
        updateClientLEDStates();
        gameEvents.add(new GameEvent("Player "+id+"'s shield expires!"));
      }
    }
    if (!human && ball.holder == this && random(600) < ai.difficulty) {
      throwEvent(this);
    }
    
  }
  void updateAIVals() {
    meditation = ai.generateValue();
    attention = ai.generateValue();
  }
}
