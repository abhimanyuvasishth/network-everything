// We'll use SoftwareSerial to communicate with the XBee:
#include <SoftwareSerial.h>
// XBee's DOUT (TX) is connected to pin 2 (Arduino's Software RX)
// XBee's DIN (RX) is connected to pin 3 (Arduino's Software TX)
SoftwareSerial XBee(10, 11); // RX, TX
int ledVal = 0;
float oneRotation = 2112;
int rxPin=3;
int txPin=4;
int ddPin=5; //device detect
int sensorbytes[2]; //array to store encoder counts
int angle;
const float pi=3.1415926;
#define left_encoder (sensorbytes[0])
#define right_encoder (sensorbytes[1])

void turnLeft(float delayT){
  Serial.write("turningright");
  Serial1.write(byte(137));
  Serial1.write(byte(0x01));
  Serial1.write(byte(0x90));
  // RADIUS
  Serial1.write(byte(0x00));
  Serial1.write(byte(0x01));
  delay(delayT);
  top();
  Serial.write("done");
}

void turnRight(float delayT){
  Serial.write("turningleft");
  Serial1.write(byte(137));
  Serial1.write(byte(0x01));
  Serial1.write(byte(0x90));
  // RADIUS
  Serial1.write(byte(0xFF));
  Serial1.write(byte(0xFF));
  delay(delayT);
  top();
  Serial.write("done");
}

void top(){
  Serial.write("forward");
  Serial1.write(byte(137));
  Serial1.write(byte(0x00));
  Serial1.write(byte(0xFA));
  // RADIUS
  Serial1.write(byte(0x00));
  Serial1.write(byte(0x00));
  delay(100);
  Serial.write("done");
}

void stopthis(){
  Serial.write("stopping");
  Serial1.write(byte(173));
  Serial.write("done");
}

void setup(){
  XBee.begin(9600);
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  pinMode(3, INPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(19, OUTPUT);
  Serial1.begin(115200);
  digitalWrite(ddPin, HIGH);
  delay(100);
  digitalWrite(ddPin, LOW);
  delay(500);
  digitalWrite(ddPin, HIGH);
  delay(2000);
}

void loop(){
  if (XBee.available()){ // If data comes in from XBee , send it out to XBee
    Serial1.write(byte(128));  //Start
    Serial1.write(byte(131));  //Safe mode
    char inByte = XBee.read();
    delay(1);
    Serial.write('\n');
    delay(1);
    XBee.write(inByte);
    delay(1);
    if(inByte == 'w'){
      Serial.write("forward\n");
      top();
    }
    if(inByte == 'a'){
      Serial.write("left\n");
      turnLeft(oneRotation/4);
    }
    if(inByte == 'd'){
      Serial.write("right\n");
      turnRight(oneRotation/4);
    }
    if(inByte == 'q'){
      Serial.write("left half\n");
      turnLeft(oneRotation/8);
    }
    if(inByte == 'e'){
      Serial.write("right half\n");
      turnRight(oneRotation/8);
    }
    if(inByte == 'x'){
      Serial.write("stopping\n");
      stopthis();
    }
  }
  updateSensors();
  // stop if angle is greater than 360 degrees
  if(abs(angle)>2*pi){
    Serial1.write(173);
    delay(100);
  } 
}

void updateSensors() {
  Serial1.write(byte(149)); // request encoder counts
  Serial1.write(byte(2));
  Serial1.write(byte(43));
  Serial1.write(byte(44));
  delay(100); // wait for sensors 
  int i=0;
  while(Serial1.available()) {
    sensorbytes[i++] = Serial1.read();  //read values into signed char array
  }
  //merge upper and lower bytes
  right_encoder=(int)(sensorbytes[2] << 8)|(int)(sensorbytes[3]&0xFF);
  left_encoder=int((sensorbytes[0] << 8))|(int(sensorbytes[1])&0xFF);

  angle=((right_encoder*72*3.14/508.8)-(left_encoder*72*3.14/508.8))/235;
}
