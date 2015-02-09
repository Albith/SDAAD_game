/*Spooky Dodgeball at a Distance
Created for LMC 6399, Discovery & Invention course, Spring 2015, Georgia Institute of Technology.
Developed by Devin Wilson & Albith Delgado.
*/


void checkAccel() {
  float [] ax = {0.f}, ay = {0.f}, az = {0.f};
  move.get_accelerometer_frame(io.thp.psmove.Frame.Frame_SecondHalf, ax, ay, az);
  int absAll = floor(abs(ax[0])*100)+floor(abs(ay[0])*100)+floor(abs(az[0])*100);
  if (absAll > THROW_THRESHOLD) {
     OscMessage throwMsg = new OscMessage("/input");
     throwMsg.add("gesture");
     throwMsg.add(absAll);
     oscClient.send(throwMsg, serverLocation);
  }
}
