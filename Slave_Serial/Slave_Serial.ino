#include <SoftwareSerial.h>

SoftwareSerial mySerial(7, 8);//RX,TX The pins that are being used to recieve the serial from the repeater.
int x;//byte storage
void setup()  

{
  mySerial.begin(9600);//new software serial port
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
}
void loop() // run over and over
{

  Joystick.X(512); //setting all axis to the midpoint.
  Joystick.Y(512);     
  Joystick.Z(512);
  Joystick.Zrotate(512);
  Joystick.sliderLeft(512);
  Joystick.sliderRight(512);

  if(mySerial.available()){
    x = mySerial.read();//set buffer
    
    if(x >= 100){//on code tasks
      Joystick.button(x - 100, 1);//decodes oncode and enables button
    }
    if(x < 100){//off code tasks
      Joystick.button(x, 0);//decodes off code and dissables button
    }
  }
}


