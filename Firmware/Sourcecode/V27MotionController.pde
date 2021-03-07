import g4p_controls.*;

import java.awt.event.KeyEvent;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.serial.*;

import javax.swing.JFrame;

public MotionChannelHandler motionHandler;

int CurveControlYOffset = 40;

PFont FontA;
PFont FontB;
PFont FontC;
int StartUpStatus = 0;
color Color_Prim = #002400;              //Dark Green
color Color_Seco = #31572C;              //Hunter green
color Color_AkzentA = #1B2F33; // CCA43B //Charleston green
color Color_AkzentB = #3F5E5A; // CCA43B //Feldgrau
color Color_AkzentC = #E5E5E5; // CCA43B //Platinum

color ForeGroundA = #FFA400;  //orange
color ForeGroundB = #A50104;  //dark red
color ForeGroundC = #D25302;  //dark orange

color Color_GreyAkzentA = #69807D;       //Xanadu
color Color_GreyAkzentB = #92A2A0;       //MorningBlue
color Color_GreyAkzentC = #BCC4C3;       //Silver sand

color Color_ButtonA = #058ED9;           //Green Blue Crayola
color Color_ButtonAkzentA = #3DA4DC;     //Carolina Blue

color Color_ButtonB = #3EC300;           //Kelly Green
color Color_ButtonAkzentB = #68CC3A;     //Lime Green

color Color_ButtonC = #FF1500;           //Imperial Red
color Color_ButtonAkzentC = #F9493A;     //Radical Red

float StartDelay = 0.001;
float Rotate = 90;
float ellipseRadius = 0;

boolean StartedWindow = false;
boolean SpaceNavigatorError = false;
String SystemStatus = "Starting the System";
PImage PlayButton, StopButton,PauseButton;
GImageButton Play, Pause, Stop;

public void settings() {
  fullScreen(P2D, 1);
  //size(400, 600, P2D);
}

public void setup() {

  surface.setSize(400, 600);
  surface.setLocation(displayWidth/2-200, displayHeight/2-300);
  //FontA = createFont("Assets/Poppins/Poppins-Regular.ttf", 30); 
  //FontB = createFont("Assets/Raleway/Raleway-Medium.ttf", 30); 
  FontC = createFont("Assets/Righteous/Righteous-Regular.ttf", 50); 

  background(Color_Prim);
  //delay(1500);
  //RunController();
  frame.toFront();
  frame.requestFocus();
  surface.setAlwaysOnTop(true);
  PlayButton = loadImage("playA.png");
  StopButton = loadImage("stopA.png");
  PauseButton = loadImage("pauseA.png");
}

public void draw() {

  background(Color_Prim);
  //background(0);
  if (millis() < 500)return;
  if (millis() > 8500 && !StartedWindow)RunController();
  //if (millis() > 500 && !StartedWindow)RunController();
  if (StartUpStatus == 0) {
    if (ellipseRadius/2 + 1 < width + width/3*2) {
      ellipseRadius += (width + width/3*4-ellipseRadius)/50 * StartDelay;
      if (StartDelay < 1)StartDelay += 0.01;
      //println((width/3*4-ellipseRadius)/100);
    } else {
      ellipseRadius = (width + width/3*2 + 1)*2;
    }
    noStroke();
    fill(Color_AkzentC);
    ellipse(width-5, height-5, ellipseRadius *1.08, ellipseRadius*1.08);

    pushMatrix();
    rectMode(CENTER);


    fill(Color_Prim);
    translate(width-5, height-5);
    rotate(radians(Rotate));
    Rotate--;
    rect(0, 0, ellipseRadius *1.08*2, 50);
    rotate(radians(-20));
    rect(0, 0, ellipseRadius *1.08*2, 50);
    rotate(radians(-20));
    rect(0, 0, ellipseRadius *1.08*2, 50);
    rotate(radians(-20));
    rect(0, 0, ellipseRadius *1.08*2, 50);
    rotate(radians(-20));
    rect(0, 0, ellipseRadius *1.08*2, 50);
    rotate(radians(-20));
    rect(0, 0, ellipseRadius *1.08*2, 50);
    rotate(radians(-20));
    rect(0, 0, ellipseRadius *1.08*2, 50);
    popMatrix();







    fill(Color_Seco);
    ellipse(width-5, height-5, ellipseRadius, ellipseRadius);
    fill(Color_AkzentC);

    //textFont(FontA);
    //text("MotionController", width - ellipseRadius/4,height- ellipseRadius/4);
    //textFont(FontB);
    //text("MotionController", width - ellipseRadius/4,height- ellipseRadius/4-30);




    pushMatrix();
    textFont(FontC);
    //rotate(radians(-60));
    translate( width - ellipseRadius/4-100, height-130);
    rotate(radians(-38));
    text("MotionController", 0, 0);
    popMatrix();
  } else if (StartUpStatus == 1) {
    //frame.dispose();
    surface.setAlwaysOnTop(false);
    surface.setVisible(true);
    surface.setSize(5, 5);
    surface.setLocation(5, 5);
  }
}

void RunController() {

  StartedWindow = true;



  String[] name = {"MotionController"};
  PApplet control = new Controller(this);
  //String[] files = {"data/playA.png", "playB.png", "playC.png"};
  //Play = new GImageButton(control, 10, 5, files);

  PApplet.runSketch(name, control);


  //String[] name2 = {"Controller"};
  //PApplet.runSketch(name2, new SerialCommander());
  StartUpStatus = 1;
}
