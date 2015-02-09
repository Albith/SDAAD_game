/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


String[] states = {"CONNECTING", "READYING", "FACEOFF", "PLAYING"};

void drawStateInfo() { //640,480
  background(255);
  fill(0);
  text(oscP5.ip(), (width/2)-50, 20);
  text(states[gameState+3], width-130,20);
  for(int i = 0; i < playersConnected; i++) {
    int yRef = (i*200)+40;
    pushStyle();
    
    if (gameState == READYING) {
      if (players[i].ready) fill(255,255,0);
    } else if (gameState == PLAYING) {


      //2.5.2015 Updated UI code for the new playing mode.
      
        if (players[i].shield)       //Player has the shield, will paint a full color.
        {
              
                if (ball.holder == players[i]) {
                fill(0,0,255);        //Player has the ball, fill with blue
                } 
                else {
                  fill(255,0,0);      //Player loses the ball, fill with red.
                } 
        
        } 
      
      else                       //Player doesn't have a shield, will strobe the light
        {                        
        
            int flash = 0;
            if (sin(millis()*0.01) > 0) {
              flash = 200;
            }
            if (ball.holder == players[i]) {   //Player has the ball, strobes blue.
              fill(0,0,50+flash);
            } else {                           //Player loses the ball, strobes red.
              fill(50+flash,0,0);
            }
     
        }
    
    
    }
    
    if (players[i].human) {
      text("Player "+i, 20, yRef);
    } else {
      text("Player "+i+" (CPU)", 20, yRef);
    }
    text("Meditation: "+players[i].meditation, 20, yRef+20);
    text("Attention: "+players[i].attention, 20, yRef+40);
    text("Wins: "+players[i].wins, 20, yRef+60);
    ellipse(160, yRef, 40,40);
    popStyle();
    
  }
  //show 10 most recent game events
  int k2 = 1;
  for (int k = gameEvents.size()-1; k > gameEvents.size()-11 && k>=0; k--) {
    text(gameEvents.get(k).eventTimeString(), 280, height-(k2*20));
    k2++;
  }
}
