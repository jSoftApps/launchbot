//LaunchBot_1_6
//Open Source Launchpad to Serial/Joystick program.
//Created by team 4918 the roboctopi, 2014
//Coded by James and Spencer.
//Have fun (Use wisely)

//       COLOR/BRIGHTNESS CHART
//      Decimal Colour Brightness
//      12       Off     Off
//      13       Red     Low
//      15       Red     Full
//      29       Amber   Low
//      63       Amber   Full
//      62       Yellow  Full
//      28       Green   Low
//      60       Green   Full

//sets up a code to send a slave board and tell it to enable(must be same on the board you want enabled)
int COM_LIST_NUM = 0;//the number of the com port you want to use.
String MIDI_INPUT_NAME = "Launchpad Mini";//set both of these to the name of the launchpad in midi
String MIDI_OUTPUT_NAME = "Launchpad Mini";

import controlP5.*;//imports all the needed librarys
import processing.serial.*;
import java.awt.AWTException;
import themidibus.*; 
import javax.sound.midi.MidiMessage;
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

Serial myPort;
MidiBus myBus;
ControlP5 cp5;
Textarea ComPorts;
Textarea MIDIinPorts;
Textarea MIDIoutPorts;
Textarea StatusBox;
Textarea StatusBox2;

int time;//sets up a delayless delay system
int timeDelay;//as well
boolean template;//sets up a boolean to reset the lights to the starting template
boolean status = false;//sets up boolean  for status light
boolean runonce = true;//just stuff
boolean runonce1 = true;//this as well
String COMS = "Serial Ports Open:" + "\n";
String MIDIin = "Midi Inputs Open:" + "\n";
String MIDIout = "Midi Outputs Open:" + "\n";
String controlerstat = "--------------CONTROLER STATUS------------ \n";
int[] light;

void setup() {
  size(490, 350);
  cp5 = new ControlP5(this);
//the next bits add the UI for the window
  ComPorts = cp5.addTextarea("txt")
    .setPosition(10, 10)
      .setSize(200, 75)
        .setFont(createFont("arial", 12))
          .setLineHeight(14)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));

  MIDIinPorts = cp5.addTextarea("txt1")
    .setPosition(10, 95)
      .setSize(200, 75)
        .setFont(createFont("arial", 12))
          .setLineHeight(14)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
                
  MIDIoutPorts = cp5.addTextarea("txt2")
    .setPosition(10, 180)
      .setSize(200, 75)
        .setFont(createFont("arial", 12))
          .setLineHeight(14)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
  
  StatusBox = cp5.addTextarea("txt3")
    .setPosition(10, 265)
      .setSize(200, 75)
        .setFont(createFont("arial", 12))
          .setLineHeight(14)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));

  StatusBox2 = cp5.addTextarea("txt4")
    .setPosition(220, 10)
      .setSize(260, 330)
        .setFont(createFont("arial", 12))
          .setLineHeight(14)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
      StatusBox2.scroll(1);
                 
           
  String portName = Serial.list()[COM_LIST_NUM];//serial set up stuff
  myPort = new Serial(this, portName, 9600);
  
  String[] available_coms = Serial.list(); //Returns an array of available input devices
  for (int i = 0;i < available_coms.length;i++)
    COMS = COMS + ("["+i+"] \""+available_coms[i]+"\""+"\n");
  ComPorts.setText(COMS);

  String[] available_inputs = MidiBus.availableInputs(); //Returns an array of available input devices
  for (int i = 0;i < available_inputs.length;i++)
    MIDIin = MIDIin + ("["+i+"] \""+available_inputs[i]+"\""+"\n");
  String[] available_outputs = MidiBus.availableOutputs(); //Returns an array of available input devices
  for (int i = 0;i < available_outputs.length;i++)
    MIDIout = MIDIout + ("["+i+"] \""+available_outputs[i]+"\""+"\n");
    
  MIDIinPorts.setText(MIDIin);
  MIDIoutPorts.setText(MIDIout);
  
  println(MIDIin + MIDIout);

  myBus = new MidiBus(this,MIDI_INPUT_NAME,MIDI_OUTPUT_NAME);
  myBus.sendControllerChange(0, 0, 0);//resets the controler
  myBus.sendControllerChange(0, 0, 40);//sets controler to flashing possible
 
  StatusBox.setText(//status update stuff
  "Currently Conected To: \n" +
  "MIDI Input | " + myBus.attachedInputs()[0] + "\n" +
  "MIDI Output | " + myBus.attachedOutputs()[0] + "\n" +
  "SERIAL Output | " + portName
  );
    
  time = millis();
  timeDelay = 100;  
}
void draw() {
  background(0);
  
 StatusBox2.setText(
 controlerstat
 );
  if (status == false) {//status light when in sleep
    if (runonce) {
      controlerstat = controlerstat + hour() + ":" + minute() + ":" + second() + "=======>" + "Controler In Idle \n";
      runonce = false;
    }
    myBus.sendControllerChange(0, 111, 58);
  }
  if (status == true) {//status light when enabled
    if (runonce1) {
      controlerstat = controlerstat + hour() + ":" + minute() + ":" + second() + "=======>" + "Controler Enabled \n";
      runonce1 = false;
    } 
    myBus.sendControllerChange(0, 111, 60);
  }
  while (template == true) {//checks if the lights need to be refleshed to the template state
    light = new int [150];//sets up an array
    //--------------------------light layout(what lights are on as a guide)---------------------------
    light[0] = 63;//ROW1 //change these to the light code ( list at top)
    light[1] = 12;
    light[2] = 12;
    light[3] = 12;
    light[4] = 12;
    light[5] = 12;
    light[6] = 63;
    light[7] = 12;
    light[16] = 12;//ROW2
    light[17] = 12;
    light[18] = 63;
    light[19] = 12;
    light[20] = 63;
    light[21] = 12;
    light[22] = 12;
    light[23] = 12;
    light[32] = 63;//ROW3
    light[33] = 12;
    light[34] = 12;
    light[35] = 12;
    light[36] = 12;
    light[37] = 12;
    light[38] = 63;
    light[39] = 12;
    light[48] = 12;//ROW4
    light[49] = 12;
    light[50] = 12;
    light[51] = 12;
    light[52] = 12;
    light[53] = 12;
    light[54] = 12;
    light[55] = 12;
    light[64] = 12;//ROW5
    light[65] = 12;
    light[66] = 12;
    light[67] = 12;
    light[68] = 12;
    light[69] = 12;
    light[70] = 12;
    light[71] = 12;
    light[80] = 12;//ROW6
    light[81] = 12;
    light[82] = 12;
    light[82] = 12;
    light[83] = 12;
    light[84] = 12;
    light[85] = 12;
    light[86] = 12;
    light[87] = 12;
    light[96] = 12;//ROW7
    light[97] = 12;
    light[98] = 12;
    light[99] = 12;
    light[100] = 12;
    light[101] = 12;
    light[102] = 12;
    light[103] = 12;
    light[112] = 12;//ROW8
    light[113] = 12;
    light[114] = 12;
    light[115] = 12;
    light[116] = 12;
    light[117] = 12;
    light[118] = 12;
    light[119] = 12;
    for (int i = 0; i < light.length; i++) {
      myBus.sendNoteOn(0, i, light[i]);//sets lights to layout when the boolean is true
    }
    template = false;
  }
}
void midiMessage(MidiMessage message) {
  int padid = message.getMessage() [1];//sets a pad id variable(dont edit)
  int onpress = 60;//set this to what color yo want the button to change to when pressed
  int[] pad = new int [121];//sets up an array, dont change
  pad[0] = 1;//ROW1//launchpad button to joystick button map----------------
  pad[1] = 0;//set code to 0 if you want that key dormant(this also dissables color change on keypress)
  pad[2] = 0;
  pad[3] = 0;
  pad[4] = 0;
  pad[5] = 0;
  pad[6] = 5;
  pad[7] = 0;
  pad[16] = 0;//ROW2
  pad[17] = 0;
  pad[18] = 3;
  pad[19] = 0;
  pad[20] = 4;
  pad[21] = 0;
  pad[22] = 0;
  pad[23] = 0;
  pad[32] = 2;//ROW3
  pad[33] = 0;
  pad[34] = 0;
  pad[35] = 0; 
  pad[36] = 0;
  pad[37] = 0;
  pad[38] = 6; 
  pad[39] = 0;
  pad[48] = 0;//ROW4
  pad[49] = 0;
  pad[50] = 0;
  pad[51] = 0;
  pad[52] = 0;
  pad[53] = 0;
  pad[54] = 0;
  pad[55] = 0;
  pad[64] = 0;//ROW5
  pad[65] = 0;
  pad[66] = 0;
  pad[67] = 0;
  pad[68] = 0;
  pad[69] = 0;
  pad[70] = 0;
  pad[71] = 0;
  pad[80] = 0;//ROW6
  pad[81] = 0;
  pad[82] = 0;
  pad[82] = 0;
  pad[83] = 0;
  pad[84] = 0;
  pad[85] = 0;       
  pad[86] = 0;
  pad[87] = 0;
  pad[96] = 0;//ROW7
  pad[97] = 0;
  pad[98] = 0;
  pad[99] = 0;
  pad[100] = 0;
  pad[101] = 0;
  pad[102] = 0;
  pad[103] = 0;
  pad[112] = 0;//ROW8
  pad[113] = 0;
  pad[114] = 0;
  pad[115] = 0;
  pad[116] = 0;
  pad[117] = 0;
  pad[118] = 0;
  pad[119] = 0;


  if (message.getStatus() == 144 & pad[padid] != 0 & status == true) {//preforms keypressed comands
    myPort.write(pad[padid] + 100);//finds button adds 100 to indicate on and sends via serial
    myBus.sendNoteOn(0, padid, onpress);
    controlerstat = controlerstat + hour() + ":" + minute() + ":" + second() + "=======>" + "NoteSent" + padid + "\n";
  }
  if (message.getStatus() == 128 & pad[padid] != 0 & status == true) {//preforms keyreleased comands
    myPort.write(pad[padid]);//finds padid adds nothing to indicate off and sends it to serial
    int x = light[padid];
    myBus.sendNoteOn(0, padid, x );//resets the lights to the starting template, thus removing the pressed key's new color
  }
  if (message.getStatus() == 144 & message.getMessage()[1] == 8) {//handles the load background button pressed functions
    myBus.sendNoteOn(0, 8, onpress);
    myBus.sendNoteOn(0, padid, onpress);
  }
  if (message.getStatus() == 128 & message.getMessage()[1] == 8) {//handles the load background button released functions
    controlerstat = controlerstat + hour() + ":" + minute() + ":" + second() + "=======>" + "Template Loaded \n";
    myBus.sendNoteOn(0, 8, 12);
    template = true;
    status = true;
  }
  if (message.getStatus() == 144 & message.getMessage()[1] == 24) {
    myBus.sendNoteOn(0, 24, onpress);
  }
  if (message.getStatus() == 128 & message.getMessage()[1] == 24) {
    controlerstat = controlerstat + hour() + ":" + minute() + ":" + second() + "=======>" + "Controler Reset \n";
    myBus.sendNoteOn(0, 24, 12);
    myBus.sendControllerChange(0, 0, 0);
    myBus.sendControllerChange(0, 0, 40);
    status = false;
    runonce = true;
    runonce1 = true;
    delay(500);
  }
}

void delay(int time) {//handles realdelay
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
