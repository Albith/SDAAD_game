/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/

class AI {
  int difficulty = 2;
  AI() {
    int diff = AI_DIFFICULTY;
    if (diff > 3) diff = 3; //constraining input in case of weird input
    if (diff < 1) diff = 1;
    difficulty = diff;
  }
  int generateValue() {
    return int(random(55+(difficulty*15)));
  }
}
