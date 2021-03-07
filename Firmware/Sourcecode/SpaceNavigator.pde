public class ShowNavigator extends GViewListener {

  float X = 0;  //inits
  float Y = 0;
  float Z = 0;
  float Xrot = 0;
  float Yrot = 0;
  float Zrot = 0;

  PShape Navigator, Base, Light;

  int lastHeight;
  int lastDiameter;

  float a = 0, delta = 0.02f;
  float rot = 0;
  boolean is_rotating = true;

  public void reverseRotation() {
    delta *= -1;
    //invalidate();
  }

  public void update(int XX) {
    PGraphics3D v = (PGraphics3D) getGraphics();
    v.beginDraw();
    //v.ambientLight(100, 100, 100);
    v.directionalLight(200, 200, 200, 0, 7000, 0);
    v.directionalLight(200, 200, 200, 0, -7000, 0);
    v.directionalLight(200, 200, 200, 700, 700, 700);
    rot +=1;
    //println(mouseY);
    v.background(Color_AkzentC);
    v.translate(v.width/2, v.height/2*1.2, 0);    
    v.scale(0.2);
    v.rotateX(radians(168));
    v.translate(0, -125);
    //v.fill(200);
    v.shape(Base, 0, 0);
    //v.translate(0,rot);
    v.directionalLight(0, 0, 0, 0, 70, 0);
    v.shape(Light, 0, 0);

    v.translate(0, 203);

    v.spotLight(100, 100, 255, 0, 0, 0, 0, 1, 0, PI/16, 10000);
    v.translate(X, -Z, -Y);
    v.rotateX(degrees(-Xrot*0.25));
    v.rotateZ(degrees(Yrot*0.25));
    v.rotateY(degrees(Zrot*0.25));

    v.fill(50, 50, 50);
    v.stroke(0, 0, 0);
    v.strokeWeight(0.1);
    v.directionalLight(255, 255, 255, 10, 10, 10);
    v.noStroke();

    v.shape(Navigator, 0, 0);
    a += delta;
    v.endDraw();
  }
  private void init() {
    Navigator = createShape();
    Navigator.beginShape(TRIANGLE_STRIP);
    Navigator.fill(30);
    Navigator.stroke(200);
    Navigator.strokeWeight(0.1);
    Navigator.noStroke();
    DrawZylinder(0, 0, 0, 200, Navigator);
    DrawZylinderUP(71, 260, Navigator);
    DrawZylinderUP( 83, 264, Navigator);
    DrawZylinderUP( 96, 260, Navigator);
    DrawZylinderUP( 101, 256, Navigator);
    DrawZylinderUP( 107, 253, Navigator);
    DrawZylinderUP( 113, 250, Navigator);
    DrawZylinderUP( 177, 235, Navigator);
    DrawZylinderUP( 232, 231, Navigator);
    DrawZylinderUP( 263, 232, Navigator);
    DrawZylinderUP( 278, 233, Navigator);
    DrawZylinderUP( 284, 234, Navigator);
    DrawZylinderUP( 294, 236, Navigator);
    DrawZylinderUP( 306, 235, Navigator);
    DrawZylinderUP( 315, 224, Navigator);
    DrawZylinderUP( 334, 167, Navigator);
    DrawZylinderUP( 345, 135, Navigator);
    DrawZylinderUP( 352, 102, Navigator);
    DrawZylinderUP( 360, 46, Navigator);
    DrawZylinderUP( 361, 23, Navigator);
    DrawZylinderUP( 361, 0, Navigator);
    Navigator.endShape();

    Base = createShape();
    Base.beginShape(TRIANGLE_STRIP);
    Base.fill(230);
    Base.stroke(0);
    Base.noStroke();
    DrawZylinder(0, 0, 0, 320, Base);
    DrawZylinderUP( 20, 320, Base);
    DrawZylinderUP( 32, 365, Base);
    DrawZylinderUP( 44, 372, Base);
    DrawZylinderUP( 69, 383, Base);
    DrawZylinderUP( 82, 387, Base);
    DrawZylinderUP( 108, 390, Base);
    DrawZylinderUP( 122, 390, Base);
    DrawZylinderUP( 148, 387, Base);
    DrawZylinderUP( 186, 372, Base);
    DrawZylinderUP( 212, 356, Base);
    DrawZylinderUP( 241, 330, Base);
    DrawZylinderUP( 254, 314, Base);
    DrawZylinderUP( 0, 0, Base);

    Base.endShape();



    Light = createShape();
    Light.beginShape(TRIANGLE_STRIP);
    Light.fill(200, 205, 230);
    Light.noStroke();
    /*DrawZylinder(0, 0, 0, 320, Light);
     DrawZylinderUP( 20, 320, Light);
     DrawZylinderUP( 32, 365, Light);
     DrawZylinderUP( 44, 372, Light);
     DrawZylinderUP( 69, 383, Light);
     DrawZylinderUP( 82, 387, Light);
     DrawZylinderUP( 108, 390, Light);
     DrawZylinderUP( 122, 390, Light);
     DrawZylinderUP( 148, 387, Light);
     DrawZylinderUP( 186, 372, Light);*/
    //DrawZylinderUP( 212, 356, Light);
    //DrawZylinderUP( 241, 330, Light);
    DrawZylinderUP( 254, 314, Light);
    DrawZylinderUP( 0, 0, Light);

    Light.endShape();
  }



  void DrawZylinder(int h0, int r0, int h1, int r1, PShape s) {
    int SteppSize = 1;
    for (int a = 0; a<360; a+=SteppSize) {
      s.vertex(r0*cos(radians(a)), h0, r0*sin(radians(a)));
      s.vertex(r0*cos(radians(a+SteppSize)), h0, r0*sin(radians(a+SteppSize)));
      s.vertex(r1*cos(radians(a)), h1, r1*sin(radians(a)));

      s.vertex(r1*cos(radians(a+SteppSize)), h1, r1*sin(radians(a+SteppSize)));
      s.vertex(r0*cos(radians(a+SteppSize)), h0, r0*sin(radians(a+SteppSize)));
      s.vertex(r1*cos(radians(a)), h1, r1*sin(radians(a)));
      lastHeight = h1; 
      lastDiameter = r1;
    }
  }
  void DrawZylinderUP( int h1, int r1, PShape s) {
    int SteppSize = 1;
    int h0 = lastHeight; 
    int r0 = lastDiameter;
    for (int a = 0; a<360; a+=SteppSize) {
      s.vertex(r0*cos(radians(a)), h0, r0*sin(radians(a)));
      s.vertex(r0*cos(radians(a+SteppSize)), h0, r0*sin(radians(a+SteppSize)));
      s.vertex(r1*cos(radians(a)), h1, r1*sin(radians(a)));

      s.vertex(r1*cos(radians(a+SteppSize)), h1, r1*sin(radians(a+SteppSize)));
      s.vertex(r0*cos(radians(a+SteppSize)), h0, r0*sin(radians(a+SteppSize)));
      s.vertex(r1*cos(radians(a)), h1, r1*sin(radians(a)));
    }
    lastHeight = h1; 
    lastDiameter = r1;
  }
}
