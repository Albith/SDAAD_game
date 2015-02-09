/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/

class GameEvent {
  int hour;
  int minute;
  int second;
  String event;
  GameEvent(String e) {
    event = e;
    hour = hour();
    minute = minute();
    second = second();
  }
  String eventTimeString() {
    return hour+":"+minute+":"+second+" - "+event;
  }
}
