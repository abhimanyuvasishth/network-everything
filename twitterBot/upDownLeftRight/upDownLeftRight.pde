float x1,y1,x2,y2,x3,y3,x4,y4,x5,y5;
float w = 150;
float h = 80;

import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

void setup(){
 size(700,500);
 background(255);
 stroke(0);
 noFill();
 x1 = 300; x2 = 100; x3 = 500; x4 = 300;y5=500;
 y1 = 100; y2 = 300; y3 = 300; y4 = 300;x5=300;
 String portName = Serial.list()[2];
 myPort = new Serial(this, portName, 9600);
}

void draw(){
 background(255);
 fill(255);
 rect(x1,y1,w,h);
 rect(x2,y2,w,h);
 rect(x3,y3,w,h);
 rect(x4,y4,w,h);
 rect(x5,y5,w,h);
 fill(100,0,0);
 text("STOP", x4+w/2-20, y4+h/2);
 text("FORWARD", x1+w/2-30, y1+h/2);
 text("LEFT", x2+w/2-20, y2+h/2);
 text("RIGHT", x3+w/2-20, y3+h/2);
 
 if(mousePressed){
  if(mouseX>x1 && mouseX <x1+w && mouseY>y1 && mouseY <y1+h){
   println("up");
   myPort.write('w');
   delay(200);
  }
  if(mouseX>x2 && mouseX <x2+w && mouseY>y2 && mouseY <y2+h){
   println("left");
   myPort.write('a');
   delay(200);
  }
  if(mouseX>x3 && mouseX <x3+w && mouseY>y3 && mouseY <y3+h){
   println("right");
   myPort.write('d');
   delay(200);
  }
  if(mouseX>x4 && mouseX <x4+w && mouseY>y4 && mouseY <y4+h){
   println("STOP");
   myPort.write('x');
   delay(200);
  }
  if(mouseX>x5 && mouseX <x5+w && mouseY>y5 && mouseY <y5+h){
   println("STOP");
   myPort.write('x');
   delay(200);
  }
 } 
}