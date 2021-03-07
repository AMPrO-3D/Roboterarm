public class PointManipulationSystem {
  PApplet parent;
  EventPoint EditingEventPoint;
  int ParentWidth, ParentHeight;
  GTextField x;
  MotionChannelHandler MCH;
  String[] item;
  GDropList Markertype;
  GSlider valueSelect;
  boolean PointOrChannel = false;// true=Channel flase=Point
  boolean PointOrVoid = false;//true=Void  false=Point



  PointManipulationSystem(PApplet par, int Pw, int Ph, MotionChannelHandler mch) {
    parent = par;
    ParentWidth = Pw;
    ParentHeight = Ph;
    Markertype = new GDropList(parent, 220, 378, 150, 100, 3);
    
    
    
    Markertype.setLocalColorScheme(5);
    Markertype.setLocalColor(3, Color_ButtonA);
    Markertype.setLocalColor(4, Color_ButtonAkzentA);
    //Markertype.setLocalColor(6, Color_ButtonA);
    Markertype.setLocalColor(3, color(0, 0, 0));






    valueSelect = new GSlider(parent, 400, 340, 180, 100, 25); 


    valueSelect.setOpaque(false); 
    valueSelect.setValue(0); 
    valueSelect.setLimits(0, 255);
    valueSelect.setShowLimits(false); 
    valueSelect.setShowValue(true); 
    valueSelect.setShowTicks(false); 
    valueSelect.setEasing(1.0); 
    valueSelect.setRotation(0.0, GControlMode.CENTER); 

    valueSelect.setLocalColorScheme(5);
    valueSelect.setLocalColor(3, Color_ButtonA);
    valueSelect.setLocalColor(4, Color_ButtonAkzentA);
    valueSelect.setLocalColor(6, Color_ButtonA);
    valueSelect.setLocalColor(2, color(0, 0, 0));

    valueSelect.setStickToTicks(false); 
    valueSelect.addEventHandler(this, "handleSliderEvents");

    valueSelect.setVisible(false);

    MCH = mch;
    item = new String[] {"void", "point", "halt"}; 
    Markertype.setItems(item, 0);
    Markertype.setVisible(false);
    Markertype.addEventHandler(this, "handleDropListEvents");
    //EventPoint Markertypes = new EventPoint(0);
    /* for (int i = 0; i < Markertypes.pointTypes.size(); i++) {
     Markertype.addItem(Markertypes.pointTypes.get(i).Name);
     }*/
  }


  void LoadPointInformaiton(EventPoint LoadPoint) {
    EditingEventPoint = LoadPoint;

    PointOrChannel = false;
    if (EditingEventPoint.PointType == 0)PointOrVoid = true;
    else if (EditingEventPoint.PointType == 1)PointOrVoid = false;

    if (!PointOrVoid) {
      valueSelect.setValue(EditingEventPoint.Value);
    }
  }

  void LoadChannelInformation(MotionChannel LoadChannel) {
    PointOrChannel = true;
  }


  void unloadPointInformation() {

    PointOrChannel = true;
  }


  void drawEventPointInformation() {
    if (EditingEventPoint != null) {
      if (PointOrChannel) {    // Editing Channel
        //println("Editing Channel");
        Markertype.setVisible(false);
        valueSelect.setVisible(false);
      } else {                 //Editing an Eventpoint
        //println("Editing an Eventpoint");
        Markertype.setVisible(true);
        //println(EditingEventPoint.PointType);
        Markertype.setSelected(EditingEventPoint.PointType);

        if (PointOrVoid) {    // Editing VoidPoint
          //println("Editing VoidPoint");
          valueSelect.setVisible(false);
        } else {                 //Editing an Point
          //println("Editing an Point");
          valueSelect.setVisible(true);
        }
      }





      //parent.fill(0);
      //parent.text(EditingEventPoint.EventPointType.Name, ParentWidth-60, 60);
      //print("PointType = ");
      //println(EditingEventPoint.EventPointType.Name);
    }
  }

  void handleDropListEvents(GDropList list, GEvent event) { 

    if (list == Markertype)
    {
      println(Markertype.getSelectedIndex());
      motionHandler.SetPointData(0, Markertype.getSelectedIndex(), valueSelect.getValueI());

      println("HAALLOO");
    } else {
      println("******************");
    }
  }


  void handleSliderEvents(GSlider list, GEvent event) {
    if (list == valueSelect) {
      motionHandler.SetPointData(0, Markertype.getSelectedIndex(), valueSelect.getValueI());

      println(valueSelect.getValueI());
    } else {
      println("******************");
    }
  }

  void KeyPointManipulation(int newMarkerType) {
    Markertype.setSelected(newMarkerType);
    motionHandler.SetPointData(0, Markertype.getSelectedIndex(), valueSelect.getValueI());
  }
}
