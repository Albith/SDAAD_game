/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


void oscEvent(OscMessage incoming) { //when osc message comes in
  if (incoming.addrPattern().equals("/accuracyModel")) {
    if (incoming.get(0).stringValue().equals("chance")) {
      chanceAccuracy = true;
    } else {
      vibrationThreshold = incoming.get(1).intValue();
    }
  }
  if (incoming.addrPattern().equals("/ledState")) {
    ledState = incoming.get(0).intValue();
  }
}
