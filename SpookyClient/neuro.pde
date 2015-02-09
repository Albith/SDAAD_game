/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


//neurosky events
void poorSignalEvent(int sig) {
}

public void attentionEvent(int attentionLevel) {
  attention = attentionLevel;
  if (reading) {
    OscMessage msg = new OscMessage("/attention");
    msg.add(attention);
    oscClient.send(msg, serverLocation);
  }
}


void meditationEvent(int meditationLevel) {
  meditation = meditationLevel;
  if (reading) {
    OscMessage msg = new OscMessage("/meditation");
    msg.add(meditation);
    oscClient.send(msg, serverLocation);
  }
}

void blinkEvent(int blinkStrength) {}
public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma){}
void rawEvent(int[] raw){}
