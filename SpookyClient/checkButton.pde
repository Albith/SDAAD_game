/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


void checkButton() {
  int buttons = move.get_buttons();
  
  //check if move button is currently pressed
  if ((buttons & Button.Btn_MOVE.swigValue()) != 0) {
    
    //tell server we've hit the button, if it wasn't down previously
    if (!moveButtonDown) {
      OscMessage buttonMsg = new OscMessage("/input");
      buttonMsg.add("button");
      oscClient.send(buttonMsg, serverLocation);
    }
    //remember that the button is down
    moveButtonDown = true;
    
  } else {
    moveButtonDown = false;
  }
}
