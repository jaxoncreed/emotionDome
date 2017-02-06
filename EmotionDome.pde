/**
 * ProcessingEpocOsc1
 * by Joshua Madara, hyperRitual.com
 * demonstrates Processing + Emotiv EPOC via OSC
 * uses EPOC's Cognitiv Left and Right to move a circle
 * left or right
 */
 
import oscP5.*;
import netP5.*;

public float cogLeft = 0;
public float cogRight = 0;
public boolean blinking = false;
int circleX = 240;

OscP5 oscP5;

void setup() {
  size(480, 360);
  frameRate(30);
  smooth();
  
  //start oscP5, listening for incoming messages on port 7400
  //make sure this matches the port in Mind Your OSCs
  oscP5 = new OscP5(this, 7400);
}

void draw() {
  if (blinking) {
    background(255, 255, 255);
  } else {
    background(0); 
  }
  
  // draw graph ticks
  int i;
  for (i = 1; i <= 11; i++) {
    stroke(map(i, 1, 11, 0, 255));
    float tickX = map(i, 1, 11, 60, 420);
    line(tickX, 250, tickX, 269);
    line(tickX, 310, tickX, 329);
  }
  noStroke();
  
  // draw bar graph
  drawBarGraph(cogLeft, 270);
  drawBarGraph(cogRight, 290);
  
  // determine whether to move circle left or right
  if((cogLeft >= 0.5) && (circleX >= 0)) {
    circleX -= 5;
  } else if ((cogRight >= 0.5) && (circleX <= 480)) {
    circleX += 5;
  }
  
  // draw circle
  fill(color(25, 249, 255));
  ellipse(circleX, 150, 90, 90);
}

void drawBarGraph(float cogVal, int barY) {
  if(cogVal >= 0.5) {
    fill(color(22, 255, 113));
  } else {
    fill(color(255, 0, 0));
  }
  float len = map(cogVal, 0.0, 1.0, 0, 360);
  rect(61, barY, len, 20);
}

void oscEvent(OscMessage theOscMessage) {
  // This will tell you what the pattern is
  // println(theOscMessage.addrPattern());
  // check if theOscMessage has an address pattern we are looking for
  if(theOscMessage.checkAddrPattern("/COG/LEFT") == true) {
    // parse theOscMessage and extract the values from the OSC message arguments
    cogLeft = theOscMessage.get(0).floatValue();
  } else if (theOscMessage.checkAddrPattern("/COG/RIGHT") == true) {
    cogRight = theOscMessage.get(0).floatValue();
  } else if (theOscMessage.checkAddrPattern("/EXP/BLINK") == true) {
    blinking = (float) theOscMessage.arguments()[0] == 1.0;
  }
}
