public class SerialCommander { //<>//
  GView view3D;
  ShowNavigator viewer3D;
  PApplet parent;
  GButton ConnectSerial;
  GButton ConnectSpaceNavigiator;
  GSlider AxisA, AxisB, AxisC, AxisD, AxisE, AxisF, AxisG;


  ControlIO controll;
  ControlDevice device;     //my SpaceNavigator
  ControlSlider sliderXpos; //Positions
  ControlSlider sliderYpos;
  ControlSlider sliderZpos;
  ControlSlider sliderXrot; //Rotations
  ControlSlider sliderYrot;
  ControlSlider sliderZrot;
  ControlButton button1;    //Buttons
  ControlButton button2;

  boolean SerialMode = false;
  boolean SpaceNavigatorActivated = false;

  SerialConnect serialConnect;
  Serial serial;

  float totalX = 0;  //inits
  float totalY = 0;
  float totalZ = 0;
  float totalXrot = 0;
  float totalYrot = 0;
  float totalZrot = 0;

  float PX, PY, PZ, PRX, PRY, PRZ;
  int MittelWertCounter = 0;
  int MittelWertGrenze = 10;

  float[][] JoystickVal = new float[6][MittelWertGrenze];

  float[] MittelWerte = new float[6];
  float[] GesendeteWerte = new float[7];

  SerialCommander(PApplet par) {
    parent = par;
  }



  void init() {
    //frame.setLocation(0, 0);
    //view3D = new GView(parent, 5, 5, 350, 200, P3D);
    view3D = new GView(parent, 1170, 75, 200, 185, P3D);
    viewer3D = new ShowNavigator();
    viewer3D.init();
    view3D.addListener(viewer3D);
    ConnectSerial = new GButton(parent, 1090 +135-80, parent.height-75, 280, 50);
    ConnectSerial.setLocalColorScheme(0);
    ConnectSerial.setLocalColor(3, Color_ButtonC);
    ConnectSerial.setLocalColor(4, Color_ButtonAkzentC);
    ConnectSerial.setLocalColor(6, Color_ButtonC);
    ConnectSerial.setLocalColor(2, color(0, 0, 0));
    ConnectSerial.setText(" Verbinde mit Motioncontroller ");
    ConnectSerial.setLocalColor(255, 2);

    ConnectSpaceNavigiator = new GButton(parent, 1090 +135-80, parent.height-135, 280, 50);
    ConnectSpaceNavigiator.setLocalColorScheme(0);
    ConnectSpaceNavigiator.setLocalColor(3, Color_ButtonC);
    ConnectSpaceNavigiator.setLocalColor(4, Color_ButtonAkzentC);
    ConnectSpaceNavigiator.setLocalColor(6, Color_ButtonC);
    ConnectSpaceNavigiator.setLocalColor(2, color(0, 0, 0));
    ConnectSpaceNavigiator.setText(" Aktiviere SpaceNavigator ");
    ConnectSpaceNavigiator.setLocalColor(255, 2);


    /*
*/
    AxisA = new GSlider(parent, 1090 + 135 - 55, 410, 255, 100, 15);
    AxisA.setStickToTicks(false);
    AxisA.setNumberFormat(G4P.DECIMAL, 6);
    AxisA.setLimits(50, 0, 10000);    
    AxisA.setLocalColorScheme(5);
    AxisA.setLocalColor(3, Color_ButtonA);
    AxisA.setLocalColor(4, Color_ButtonAkzentA);
    AxisA.setLocalColor(6, Color_ButtonA);
    AxisA.setLocalColor(2, color(0, 0, 0));


    AxisB = new GSlider(parent, 1090 + 135 - 55, 430, 255, 100, 15); 
    AxisB.setStickToTicks(false); 
    AxisB.setNumberFormat(G4P.DECIMAL, 6);
    AxisB.setLimits(50, 0, 10000);
    AxisB.setLocalColorScheme(5);
    AxisB.setLocalColor(3, Color_ButtonA);
    AxisB.setLocalColor(4, Color_ButtonAkzentA);
    AxisB.setLocalColor(6, Color_ButtonA);
    AxisB.setLocalColor(2, color(0, 0, 0));
    AxisC = new GSlider(parent, 1090 + 135 - 55, 450, 255, 100, 15); 
    AxisC.setStickToTicks(false);
    AxisC.setNumberFormat(G4P.DECIMAL, 6); 
    AxisC.setLimits(50, 0, 10000);
    AxisC.setLocalColorScheme(5);
    AxisC.setLocalColor(3, Color_ButtonA);
    AxisC.setLocalColor(4, Color_ButtonAkzentA);
    AxisC.setLocalColor(6, Color_ButtonA);
    AxisC.setLocalColor(2, color(0, 0, 0));

    AxisD = new GSlider(parent, 1090 + 135 - 55, 470, 255, 100, 15);
    AxisD.setStickToTicks(false);
    AxisD.setNumberFormat(G4P.DECIMAL, 6); 
    AxisD.setLimits(50, 0, 10000);
    AxisD.setLocalColorScheme(5);
    AxisD.setLocalColor(3, Color_ButtonA);
    AxisD.setLocalColor(4, Color_ButtonAkzentA);
    AxisD.setLocalColor(6, Color_ButtonA);
    AxisD.setLocalColor(2, color(0, 0, 0));
    AxisE = new GSlider(parent, 1090 + 135 - 55, 490, 255, 100, 15); 
    AxisE.setStickToTicks(false);
    AxisE.setNumberFormat(G4P.DECIMAL, 6); 
    AxisE.setLimits(50, 0, 10000);
    AxisE.setLocalColorScheme(5);
    AxisE.setLocalColor(3, Color_ButtonA);
    AxisE.setLocalColor(4, Color_ButtonAkzentA);
    AxisE.setLocalColor(6, Color_ButtonA);
    AxisE.setLocalColor(2, color(0, 0, 0));
    AxisF = new GSlider(parent, 1090 + 135 - 55, 510, 255, 100, 15); 
    AxisF.setStickToTicks(false); 
    AxisF.setNumberFormat(G4P.DECIMAL, 6);
    AxisF.setLimits(50, 0, 10000);
    AxisF.setLocalColorScheme(5);
    AxisF.setLocalColor(3, Color_ButtonA);
    AxisF.setLocalColor(4, Color_ButtonAkzentA);
    AxisF.setLocalColor(6, Color_ButtonA);
    AxisF.setLocalColor(2, color(0, 0, 0));

    AxisG = new GSlider(parent, 1090 + 135 - 55, 550, 255, 100, 15); 
    AxisG.setStickToTicks(false); 
    AxisG.setNumberFormat(G4P.DECIMAL, 6);
    AxisG.setLimits(50, 0, 10000);
    AxisG.setLocalColorScheme(5);
    AxisG.setLocalColor(3, Color_ButtonA);
    AxisG.setLocalColor(4, Color_ButtonAkzentA);
    AxisG.setLocalColor(6, Color_ButtonA);
    AxisG.setLocalColor(2, color(0, 0, 0));


    rectMode(CENTER);
  }
  void draw() {
    for (int i = 0; i < 6; i++) {
      for (int l = MittelWertGrenze-1; l > 0; l--) {
        JoystickVal[i][l] = JoystickVal[i][l-1];
      }
    }

    if (SpaceNavigatorActivated) {
      print("State:   ");
      if (device.available) {
        println("da");
      } else {
        println("nit da");
      }
      if (true) {
        JoystickVal[0][0] = sliderXpos.getValue();
        JoystickVal[1][0] = sliderYpos.getValue();
        JoystickVal[2][0] = sliderZpos.getValue();
        JoystickVal[3][0] = sliderXrot.getValue();
        JoystickVal[4][0] = sliderYrot.getValue();
        JoystickVal[5][0] = sliderZrot.getValue();
      }
    }
    //println(sliderXpos.getValue());

    for (int i = 0; i < 6; i++) {
      for (int l = MittelWertGrenze-1; l > 0; l--) {
        MittelWerte[i] += JoystickVal[i][l];
        if (i== 0 && l <  MittelWertGrenze-1) {
          stroke(255);
          line(l*10, JoystickVal[i][l], (l+1)*10, JoystickVal[i][l+1]);
        }
      }
      MittelWerte[i] /= MittelWertGrenze;
    }




    viewer3D.X = MittelWerte[0];
    viewer3D.Y = MittelWerte[1];
    viewer3D.Z = MittelWerte[2];

    viewer3D.Xrot = MittelWerte[3];
    viewer3D.Yrot = MittelWerte[4];
    viewer3D.Zrot = MittelWerte[5];

    viewer3D.update(mouseX);
    println(mouseX);

    AxisA.setValue(AxisA.getValueF() + pow(MittelWerte[0], 3)*0.05);
    AxisB.setValue(AxisB.getValueF() + pow(MittelWerte[1], 3)*0.05);
    AxisC.setValue(AxisC.getValueF() + pow(MittelWerte[2], 3)*0.05);
    AxisD.setValue(AxisD.getValueF() + pow(MittelWerte[3]*1000, 3)*0.05);
    AxisE.setValue(AxisE.getValueF() + pow(MittelWerte[4]*1000, 3)*0.05);
    AxisF.setValue(AxisF.getValueF() + pow(MittelWerte[5]*1000, 3)*0.05);

    //print(AxisA.getValueF());
    //print("  ");
    //println(MittelWerte[0]);
    if (SerialMode) {
      if (GesendeteWerte[0] != AxisA.getValueF()) {
        GesendeteWerte[0] = AxisA.getValueF();
        sendControllerComand('A', AxisA.getValueF());
        println("Send A-Axis");
      }
      if (GesendeteWerte[1] != AxisB.getValueF()) {
        GesendeteWerte[1] = AxisB.getValueF();
        sendControllerComand('B', AxisB.getValueF());
      }
      if (GesendeteWerte[2] != AxisC.getValueF()) {
        GesendeteWerte[2] = AxisC.getValueF();
        sendControllerComand('C', AxisC.getValueF());
      }
      if (GesendeteWerte[3] != AxisD.getValueF()) {
        GesendeteWerte[3] = AxisD.getValueF();
        sendControllerComand('D', AxisD.getValueF());
      }
      if (GesendeteWerte[4] != AxisE.getValueF()) {
        GesendeteWerte[4] = AxisE.getValueF();
        sendControllerComand('E', AxisE.getValueF());
      }
      if (GesendeteWerte[5] != AxisF.getValueF()) {
        GesendeteWerte[5] = AxisF.getValueF();
        sendControllerComand('F', AxisF.getValueF());
      }
      if (GesendeteWerte[6] != AxisG.getValueF()) {
        GesendeteWerte[6] = AxisG.getValueF();
        sendControllerComand('G', AxisG.getValueF());
      }

      //serial.write('X');
      //serial.write(str(int(map(AxisA.getValueF(), 0, 10000, 0, 6400))));
      //serial.write((byte)10);
      if (serial.available()>0)serial.read();
    }
  }

  void handleButtonEvents(GButton button) {
    println("geklickt");
    //println(button);
    if (button == ConnectSerial) {

      println(serial.active());
    } else {
      println("******************");
    }
  }

  void sendControllerComand(char Axis, float Value) {
    serial.write(Axis);
    serial.write(str(int(map(Value, 0, 10000, 0, 10000))));
    //serial.write(str(int(map(Value, 0, 10000, 0, 6400))));
    serial.write((byte)10);
  }

  public void mousePressed() {
    println("tt");
  }

  public void mouseDragged() {
  }

  public void keyPressed() {
  }
}
