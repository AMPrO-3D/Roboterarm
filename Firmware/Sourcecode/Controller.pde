public class Controller extends PApplet { //<>// //<>// //<>// //<>//

  SerialCommander serialCommander;
  PApplet parent;
  //GButton OpenSerialCommander;
  PointManipulationSystem pointEditing;
  CurveControlSystem  curveControl;




  boolean playing = false;


  int CursorPosition = 0;

  Controller(PApplet par) {
    parent = par;
  }


  public void settings() {
    size(1440, 790, P2D);
  }

  public void setup() {
    surface.setLocation(150, 150);
    surface.setResizable(false);
    pointEditing = new PointManipulationSystem(this, 1080, height, motionHandler);
    motionHandler  = new MotionChannelHandler(this, 1080, height, pointEditing);
    serialCommander = new SerialCommander(this);
    curveControl = new CurveControlSystem(this, 5, 35, 1080, 256);//height/3*2-45);
    surface.setTitle("Controller");
    motionHandler.addChannel();
    motionHandler.addChannel();
    motionHandler.addChannel();
    motionHandler.addChannel();
    motionHandler.addChannel();
    motionHandler.addChannel();
    motionHandler.addChannel();

    motionHandler.AddPointToChannel(0);
    motionHandler.AddPointToChannel(0);
    motionHandler.AddPointToChannel(0);
    motionHandler.AddPointToChannel(0);
    motionHandler.AddPointToChannel(0);
    motionHandler.AddPointToChannel(0);

    //Folgend wird eine Ausgangsituatuion simuliert
    motionHandler.drawChannels(0, 100);
    motionHandler.setManualPointData(0, 0, 1, 50, 0);
    motionHandler.setManualPointData(0, 1, 0, 50, 60);
    motionHandler.setManualPointData(0, 2, 1, 50, 0);

    motionHandler.ReCalculateChannel(0);

    //OpenSerialCommander = new GButton(this, width-60, 5, 50, 25);
    //Play = new GImageButton(this, 10, 5, 25, 25);

    //Stop = new GImageButton(this, 70, 5, 25, 25);


    //PImage img = loadImage("data/playA.png");


    //parent.loadImage("playA.png");

    //Stop = new GImageButton(this, 70, 5,files);

    //Play.setLocalColorScheme(4);
    //Play.setLocalColor(3, Color_ButtonA);
    //Play.setLocalColor(4, Color_ButtonAkzentA);
    //Play.setLocalColor(6, Color_ButtonA);
    //Play.setLocalColor(2, color(0, 0, 0));




    serialCommander.init();
  }
  public void draw() {
    background(Color_AkzentA);

    noFill();
    int startDensity = 180;
    int ShadowWidth = 15;
    float Stepsize = startDensity / ShadowWidth;
    float radiusAnpassung = 0.95;
    for (float i = 0; i < ShadowWidth; i += 0.9) {        
      stroke(0, startDensity-Stepsize*i);

      rect(-5-i, curveControl.CanvasY+curveControl.CanvasHeight+43-i, 1090-7+i*2, 125-15+i*2, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung);
    }
    startDensity = 180;
    ShadowWidth = 15;
    Stepsize = startDensity / ShadowWidth;
    radiusAnpassung = 0.95;
    for (float i = 0; i < ShadowWidth; i += 0.9) {        
      stroke(0, startDensity-Stepsize*i);

      rect(-5-i, curveControl.CanvasY+curveControl.CanvasHeight+193-i, 1090-7+i*2, height-15+i*2, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung);
    }

    startDensity = 180;
    ShadowWidth = 15;
    Stepsize = startDensity / ShadowWidth;
    radiusAnpassung = 0.95;
    for (float i = 0; i < ShadowWidth; i += 0.9) {        
      stroke(0, startDensity-Stepsize*i);

      rect(1214-i-80, 429-i, 613+i*2, 700+i*2, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung);
    }


    fill(Color_AkzentC);
    noStroke();

    rect(-5, curveControl.CanvasY+curveControl.CanvasHeight+35, 1090, 125, 5, 5, 5, 5);
    //rect(-5, height/3*2-45+39, 1090, 251, 5, 5, 0, 5);


    rect(-5, curveControl.CanvasY+curveControl.CanvasHeight+185, 1090, height, 5, 5, 0, 5);

    rect(1000, 65, 500, 205, 10, 10, 10, 10);
    //fill(Color_AkzentB);
    rect(1205-80, 420, 500, 600, 10, 10, 10, 10);

    PlayButton.resize(95, 95);
    StopButton.resize(95, 95);
    PauseButton.resize(95, 95);

    if (!playing)image(PlayButton, 0, curveControl.CanvasY+curveControl.CanvasHeight+35+15);
    else image(PauseButton, 0, curveControl.CanvasY+curveControl.CanvasHeight+35+15);
    image(StopButton, 95, curveControl.CanvasY+curveControl.CanvasHeight+35+15);

    println(curveControl.CanvasY+curveControl.CanvasHeight+35);

    //println(millis());
    //if (millis() > 5000) StartUpStatus = 1;

    //fill(Color_AkzentB);
    //rect(width/6*5, 35, width, height/3*2);

    //fill(Color_AkzentB);
    //rect(0, height/3*2, width, height);

    motionHandler.drawChannels(0, 100);
    motionHandler.CheckSelected(mouseX, mouseY, false, false, false);
    //curveControl.CheckCurveControlInteraction(mouseX,mouseY,false,false);
    //println("#");
    pointEditing.drawEventPointInformation();

    fill(ForeGroundA);
    ellipse(mouseX, mouseY, 2, 2);

    curveControl.drawCanvas();
    serialCommander.draw();
    //println(height/3*2-45);
    line(CursorPosition, 35, CursorPosition, 300);
    line(CursorPosition, height/3*2-45, CursorPosition, height);
    //line(CursorPosition,height/3*2-45,CursorPosition,10);

    if (playing) {
      CursorPosition++;
      float[] Output = motionHandler.getMomentValues(CursorPosition);
      println(Output);
      serialCommander.AxisA.setValue(map(Output[0], 0, 200, 0, 10000));
      serialCommander.AxisB.setValue(map(Output[1], 0, 200, 0, 10000));
      //println(map(Output[0], 0, 255, 0, 100));
      serialCommander.AxisC.setValue(map(Output[2], 0, 200, 0, 10000));
      serialCommander.AxisD.setValue(map(Output[3], 0, 200, 0, 10000));
      serialCommander.AxisE.setValue(map(Output[4], 0, 200, 0, 10000));
      serialCommander.AxisF.setValue(map(Output[5], 0, 200, 0, 10000));
      serialCommander.AxisG.setValue(map(Output[6], 0, 200, 0, 10000));
      //serialCommander.AxisF.setValue(map(Output[5],0,200,0,1));
      if (CursorPosition > 1080)CursorPosition = 0;
    }
    noStroke();
    fill(ForeGroundA);
    rect(0, height-20, 1085, 20);
  }


  public void mousePressed() {
    motionHandler.CheckSelected(mouseX, mouseY, true, false, false);
    curveControl.CheckCurveControlInteraction(mouseX, mouseY-CurveControlYOffset, true, false);
  }

  public void mouseDragged() {
    if (keyPressed && keyCode == 16) motionHandler.CheckSelected(mouseX, mouseY, true, true, true);
    else motionHandler.CheckSelected(mouseX, mouseY, true, true, false);

    curveControl.CheckCurveControlInteraction(mouseX, mouseY-CurveControlYOffset, true, true);
  }

  public void keyPressed() {
    if (key == 'p')pointEditing.KeyPointManipulation(1);
    else if (key == 'h') {
      println("halt");
    } else if (key == 'g') {
      saveFrame("line-######.png");
    } else if (keyCode == CONTROL) {
      println("Play");
      //String[] name = {"Controller"};
      //serialCommander = new SerialCommander(this);
      //PApplet.runSketch(name, serialCommander);
      playing = !playing;
      
    } else if (keyCode == ALT) {
       println("Stop");
        //String[] name = {"Controller"};
        //serialCommander = new SerialCommander(this);
        //PApplet.runSketch(name, serialCommander);
        playing = false;
        CursorPosition = 0;
    } else if (keyCode == RIGHT) {
      motionHandler.NavigateArrow('R');
      println("halt");
    } else if (keyCode == LEFT) {
      motionHandler.NavigateArrow('L');
      println("halt");
    } else if (keyCode == UP) {
      motionHandler.NavigateArrow('U');
      println("halt");
    } else if (keyCode == DOWN) {
      motionHandler.NavigateArrow('D');
      println("halt");
    } else println("halt!");
  }

  void handleButtonEvents(GImageButton button, GEvent event) {
    /*if (button == OpenSerialCommander) {
     if (event == GEvent.CLICKED) {
     println("Öffne Serial Commander");
     //String[] name = {"Controller"};
     //serialCommander = new SerialCommander(this);
     //PApplet.runSketch(name, serialCommander);
     }
     } else*/    if (button == Play) {
      if (event == GEvent.CLICKED) {
      }
    } else if (button == Stop) {
      if (event == GEvent.CLICKED) {
        println("Stop");
        //String[] name = {"Controller"};
        //serialCommander = new SerialCommander(this);
        //PApplet.runSketch(name, serialCommander);
        playing = false;
        CursorPosition = 0;
      }
    }
  }



  void handleButtonEvents(GButton button, GEvent event) {
    /*if (button == OpenSerialCommander) {
     if (event == GEvent.CLICKED) {
     println("Öffne Serial Commander");
     //String[] name = {"Controller"};
     //serialCommander = new SerialCommander(this);
     //PApplet.runSketch(name, serialCommander);
     }
     } else*/
    if (button == serialCommander.ConnectSerial) {
      serialCommander.SerialMode = !serialCommander.SerialMode;
      if (serialCommander.SerialMode) {

        println(Serial.list());  
        serialCommander.ConnectSerial.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
        serialCommander.ConnectSerial.setText("verbinden...");

        delay(500);
        try {
          serialCommander.serial = new Serial(serialCommander.parent, Serial.list()[0], 500000);
        }
        catch(Exception e) {
          e.printStackTrace();
        }
        delay(500);
        if (serialCommander.serial.active()) {
          serialCommander.ConnectSerial.setLocalColorScheme(GCScheme.GREEN_SCHEME);
          serialCommander.ConnectSerial.setLocalColor(3, Color_ButtonB);
          serialCommander.ConnectSerial.setLocalColor(4, Color_ButtonAkzentB);
          serialCommander.ConnectSerial.setLocalColor(6, Color_ButtonB);          
          serialCommander.ConnectSerial.setLocalColor(2, color(0, 0, 0));
          serialCommander.ConnectSerial.setText("Motioncontroller trennen...");
        }
      } else {
        serialCommander.serial.stop();
        if (!serialCommander.serial.active()) {
          serialCommander.ConnectSerial.setLocalColorScheme(0);
          serialCommander.ConnectSerial.setLocalColor(3, Color_ButtonC);
          serialCommander.ConnectSerial.setLocalColor(4, Color_ButtonAkzentC);
          serialCommander.ConnectSerial.setLocalColor(6, Color_ButtonC);
          serialCommander.ConnectSerial.setLocalColor(2, color(0, 0, 0));
          serialCommander.ConnectSerial.setText("Motioncontroller verbinden...");
        }
      }
    } else if (button == serialCommander.ConnectSpaceNavigiator) {
      try {
        serialCommander.controll = ControlIO.getInstance(serialCommander.parent);
        serialCommander.device = serialCommander.controll.getDevice("SpaceNavigator");//magic name
        serialCommander.device.setTolerance(5.00f);


        serialCommander.sliderXpos = serialCommander.device.getSlider("X-Achse");//German in all drivers???
        serialCommander.sliderYpos = serialCommander.device.getSlider("Y-Achse");
        serialCommander.sliderZpos = serialCommander.device.getSlider("Z-Achse");
        serialCommander.sliderXrot = serialCommander.device.getSlider("X-Rotation");
        serialCommander.sliderYrot = serialCommander.device.getSlider("Y-Rotation");
        serialCommander.sliderZrot = serialCommander.device.getSlider("Z-Rotation");
        serialCommander.button1 = serialCommander.device.getButton("Taste 0");
        serialCommander.button2 = serialCommander.device.getButton("Taste 1");
        serialCommander.sliderXpos.setMultiplier(0.05); //sensitivities
        serialCommander.sliderYpos.setMultiplier(0.05);
        serialCommander.sliderZpos.setMultiplier(0.05);
        serialCommander.sliderXrot.setMultiplier(0.00005);
        serialCommander.sliderYrot.setMultiplier(0.00005);
        serialCommander.sliderZrot.setMultiplier(0.00005);

        serialCommander.SpaceNavigatorActivated = true;
      }
      catch(Exception e) {
        e.printStackTrace();
        println("FEEEHHHLER");
        SpaceNavigatorError = true;

        G4P.showMessage(this, "Das System konnte keinen SpaceNavigator erreichen. Bitte verbinden sie den SpaceNavigator bevor sie dieses Programm ausführen. Das Programm wird sich nun automatisch beenden! ", "SpaceNavigator nicht erreichbar", G4P.ERROR_MESSAGE);

        exit();
      }

      if ( serialCommander.SpaceNavigatorActivated) {
        serialCommander.ConnectSpaceNavigiator.setLocalColorScheme(GCScheme.GREEN_SCHEME);
        serialCommander.ConnectSpaceNavigiator.setLocalColorScheme(1);
        serialCommander.ConnectSpaceNavigiator.setLocalColor(3, Color_ButtonB);
        serialCommander.ConnectSpaceNavigiator.setLocalColor(4, Color_ButtonAkzentB);
        serialCommander.ConnectSpaceNavigiator.setLocalColor(6, Color_ButtonB);
        serialCommander.ConnectSpaceNavigiator.setLocalColor(2, color(0, 0, 0));
        serialCommander.ConnectSpaceNavigiator.setText("SpaceNavigator verbunden");
        serialCommander.ConnectSpaceNavigiator.setEnabled(false);
      }
    } else {
      println("******************");
    }
  }
}
