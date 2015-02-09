/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


//Audio Includes
  import ddf.minim.* ;
  Minim minim;

//Device objects and sounds.
AudioPlayer startup,readying, ballGrab, getShield;
AudioPlayer loseShield, throwAndMiss, P1Win, P2Win;//lose;

//Starts Audio.
void startAudio()
{
   //Setting up audio.
    minim = new Minim(this) ;
      startup = minim.loadFile("Sounds/StartUp.wav") ;
      readying = minim.loadFile("Sounds/GetReady.wav") ;
      ballGrab = minim.loadFile("Sounds/Connect1.wav") ; 
      getShield = minim.loadFile("Sounds/getShield.wav") ;
      loseShield = minim.loadFile("Sounds/Break.wav") ;
      throwAndMiss = minim.loadFile("Sounds/Miss3.wav") ;
      P1Win= minim.loadFile("Sounds/Full_Player1Wins.wav") ;
      P2Win= minim.loadFile("Sounds/Full_Player2Wins.wav") ;
}


  
  
  


