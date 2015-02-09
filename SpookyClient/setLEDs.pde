/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


void setLEDs() {
  boolean strobeThisFrame = sin(millis()*0.01) > 0; //use sin value to turn strobe on/off
  
  switch(ledState) { //switch based on LED state to set LED values
    case LED_STEADY_YELLOW:
      move.set_leds(255,255,0);
      break;
    case LED_STROBE_BLUE:
      if (!strobeThisFrame) { //if don't strobe, turn light off
        move.set_leds(0,0,0);
        break;
      } //else fall through
    case LED_STEADY_BLUE:
      move.set_leds(0,0,255);
      break;
    case LED_STROBE_RED:
      if (!strobeThisFrame) { //if don't strobe, turn light off
        move.set_leds(0,0,0);
        break;
      } //else fall through
    case LED_STEADY_RED:
      move.set_leds(255,0,0);
      break;
    case LED_STEADY_WHITE:
      move.set_leds(255,255,255);
      break;
    case LED_STEADY_GREEN:
      move.set_leds(0,255,0);
      break;
    case LED_OFF:
    default:
      move.set_leds(0,0,0);
  }
}
