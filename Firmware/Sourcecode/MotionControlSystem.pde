public class MotionChannel {
  PApplet parent;
  ArrayList<EventPoint> Points = new ArrayList<EventPoint>();
  //color ChannelColor = color(random(0, 255), random(0, 255), random(0, 255));
  color ChannelColor = Color_GreyAkzentB;
  boolean Selected = false;
  int ViewableMin;
  int ViewableMax;
  boolean SelectedChannel = true;
  int ClosedEventPointWidth = 40;
  int ParentHeight;
  int SelectedEventPoint = -1;
  int HoveredEventPoint = -1;
  int lastTimeStamp = 0;

  int selectedLink = -1;
  int hoveredLink = -1;

  MotionChannel(PApplet par) {
    parent = par;
  }


  void addPoint(EventPoint newEventPoint) {
    Points.add(newEventPoint);
  }
  void addPoint() {
    Points.add(new EventPoint(lastTimeStamp));
    lastTimeStamp += Points.get(Points.size()-1).PointWidth;
  }

  void drawEventPoints(int indMin, int indMax, int ChannelTopHeight, int ParentHeight) {
    if (indMax > Points.size()-1) indMax = Points.size()-1;
    ViewableMin = indMin;
    ViewableMax = indMax;
    lastTimeStamp = 0;
    int drawIndex = 0;
    for (int i = indMin; i <= indMax; i++) {
      if (i == HoveredEventPoint) {
        //parent.fill(Color_Seco);
        parent.fill(Points.get(i).EventPointColor);
        parent.stroke(ForeGroundA);
        parent.strokeWeight(5);
      } else if (i == SelectedEventPoint) {
        //parent.fill(Color_Seco);
        parent.fill(Points.get(i).EventPointColor);
        parent.stroke(ForeGroundB);
        parent.strokeWeight(5);
      } else {
        parent.stroke(0, 0, 0);
        parent.strokeWeight(1);
        parent.fill(Points.get(i).EventPointColor);
      }
      EventPoint CurrentPoint = Points.get(i);
      CurrentPoint.update();
      if (CurrentPoint.IsPoint) {
        //parent.rect(5+CurrentPoint.TimeStamp-5, ChannelTopHeight + ParentHeight/2-2, 15, 15, 5, 5, 5, 5);    //POINT
      } else {
        parent.rect(5+CurrentPoint.TimeStamp, ChannelTopHeight+1, CurrentPoint.PointWidth, ParentHeight-1, 10, 10, 0, 0); //VOID
      }

      parent.stroke(0, 0, 0);
      parent.strokeWeight(1);




      lastTimeStamp += CurrentPoint.PointWidth;
      drawIndex++;
    }
    for (int i = indMin; i <= indMax; i++) {
      if (i == HoveredEventPoint) {
        //parent.fill(Color_Seco);
        parent.fill(Points.get(i).EventPointColor);
        parent.stroke(ForeGroundA);
        parent.strokeWeight(5);
      } else if (i == SelectedEventPoint) {
        //parent.fill(Color_Seco);
        parent.fill(Points.get(i).EventPointColor);
        parent.stroke(ForeGroundB);
        parent.strokeWeight(5);
      } else {
        parent.stroke(0, 0, 0);
        parent.strokeWeight(1);
        parent.fill(Points.get(i).EventPointColor);
      }
      EventPoint CurrentPoint = Points.get(i);
      CurrentPoint.update();
      if (CurrentPoint.IsPoint) {
        parent.rect(5+CurrentPoint.TimeStamp-7.5, ChannelTopHeight + ParentHeight/2-2, 15, 15, 5, 5, 5, 5);    //POINT
        if (CurrentPoint.PointType==2)text("H", 5+CurrentPoint.TimeStamp-7.5, ChannelTopHeight + ParentHeight/2-2);
      }
      parent.stroke(0, 0, 0);
      parent.strokeWeight(1);


      if (hoveredLink > -1) {
        if (i == hoveredLink) {
          //parent.fill(Color_Seco);
          parent.fill(Points.get(i).EventPointColor);
          parent.stroke(ForeGroundA);
          parent.strokeWeight(5);
        } else if (i == selectedLink) {
          //parent.fill(Color_Seco);
          parent.fill(Points.get(i).EventPointColor);
          parent.stroke(ForeGroundB);
          parent.strokeWeight(5);
        } else {
          parent.noStroke();          
          parent.noFill();
        }
        parent.rect(5+CurrentPoint.TimeStamp, ChannelTopHeight-5, 2, 5);
      }

      parent.stroke(0, 0, 0);
      parent.strokeWeight(1);
    }



    //println(drawIndex);
    if (indMax == Points.size()-1 && SelectedChannel) {
      parent.fill(Color_AkzentB);
      parent.rect(5+lastTimeStamp, ChannelTopHeight+2, ClosedEventPointWidth, ParentHeight-2);
      parent.fill(0);
      parent.textSize(20);
      if (SelectedChannel)parent.text("+", 5+lastTimeStamp+20, ChannelTopHeight + (ParentHeight-2)/2+5);
    }
  }


  boolean checkSelected(int Mx, boolean Clicking, boolean Dragging, boolean Shifting, PointManipulationSystem PMS) {
    if (Mx > 5) {
      int mx = Mx - 5;
      //println((ViewableMax-ViewableMin+1)*ClosedEventPointWidth);
      //println(mx / ClosedEventPointWidth);
      //println((ViewableMax-ViewableMin+1)*ClosedEventPointWidth);
      if (mx < lastTimeStamp) {
        if (Dragging) {
          if (selectedLink > -1) {

            if (Shifting) {
              if (!Points.get(selectedLink-1).IsPoint) {
                if (Points.get(selectedLink).TimeStamp > Points.get(selectedLink-1).TimeStamp + 12 || mx > Points.get(selectedLink).TimeStamp) {
                  Points.get(selectedLink).PointWidth = Points.get(selectedLink).PointWidth - mx + Points.get(selectedLink).TimeStamp ;
                  Points.get(selectedLink).TimeStamp = mx;
                  Points.get(selectedLink-1).PointWidth = Points.get(selectedLink).TimeStamp - Points.get(selectedLink-1).TimeStamp;
                  ReCalculatePoints();
                }
              } else {
                if (Points.get(selectedLink-1).TimeStamp > Points.get(selectedLink-2).TimeStamp + 12 || mx > Points.get(selectedLink-1).TimeStamp) {
                  Points.get(selectedLink).PointWidth = Points.get(selectedLink).PointWidth - mx + Points.get(selectedLink-1).TimeStamp ;
                  Points.get(selectedLink-1).TimeStamp = mx;
                  Points.get(selectedLink-2).PointWidth = Points.get(selectedLink-1).TimeStamp - Points.get(selectedLink-2).TimeStamp;


                  SelectedEventPoint = selectedLink-1;

                  ReCalculatePoints();
                }
              }
            } else {
              if (!Points.get(selectedLink-1).IsPoint) {
                if (Points.get(selectedLink).TimeStamp > Points.get(selectedLink-1).TimeStamp + 12 || mx > Points.get(selectedLink).TimeStamp) {
                  Points.get(selectedLink).TimeStamp = mx;
                  Points.get(selectedLink-1).PointWidth = Points.get(selectedLink).TimeStamp - Points.get(selectedLink-1).TimeStamp;
                  ReCalculatePoints();
                }
              } else {
                if (selectedLink > 0) {
                  if (Points.get(selectedLink-1).TimeStamp > Points.get(selectedLink-2).TimeStamp + 12 || mx > Points.get(selectedLink-1).TimeStamp) {
                    Points.get(selectedLink-1).TimeStamp = mx;
                    Points.get(selectedLink-2).PointWidth = Points.get(selectedLink-1).TimeStamp - Points.get(selectedLink-2).TimeStamp;


                    SelectedEventPoint = selectedLink-1;

                    ReCalculatePoints();
                  }
                } else {
                  SelectedEventPoint = selectedLink-1;

                  ReCalculatePoints();
                }
              }
            }
          }
        } else {
          //println("Hovering over Points!");
          for (int i = Points.size()-1; i >= 0; i--) {

            if (mx >= Points.get(i).TimeStamp-5) {
              if (mx < Points.get(i).TimeStamp+5) {
                hoveredLink = i;
                if (Clicking || Dragging) {
                  println("Klicked on Linkage");
                  selectedLink = i;
                  if (!Points.get(selectedLink).IsPoint) {
                    println("Wir müssen den Vorherigen Punkt auswählen");
                    PMS.LoadPointInformaiton(Points.get(selectedLink-1));
                    println(selectedLink-1);
                    hoveredLink = i;
                    selectedLink = i;
                    SelectedEventPoint = selectedLink-1;

                    break;
                  } else {
                  }
                }
                HoveredEventPoint = -1;
                break;
              } else {

                hoveredLink = -1;
                //print("Klicked parcell:    ");
                //println(i);
                if (SelectedEventPoint == i) {
                  EventPoint CurrentEventPoint= Points.get(SelectedEventPoint);
                  CurrentEventPoint.giveFeedback(true);
                } else {
                  //SelectedEventPoint = i;
                  selectedLink = -1;
                }           

                if (Clicking) {

                  println("Reseted ChannelSelection");
                  SelectedEventPoint = i;
                  EventPoint CurrentEventPoint= Points.get(SelectedEventPoint);
                  //CurrentEventPoint.giveFeedback(true);
                  PMS.LoadPointInformaiton(CurrentEventPoint);
                  if (!CurrentEventPoint.IsPoint) {
                    /*CurrentEventPoint.PointWidth += 20;
                     for (int l = i+1; l < Points.size(); l++) {
                     Points.get(l).TimeStamp += 20;
                     }*/
                  }
                } else HoveredEventPoint = i;
                break;
              }
            }
          }
          ReCalculatePoints();
        }
      } else if (mx < lastTimeStamp + ClosedEventPointWidth) {
        if (Clicking) {
          //print("Want to Add:    ");
          //println(ViewableMin + int(mx / ClosedEventPointWidth));
          Points.add(new EventPoint(lastTimeStamp));
          lastTimeStamp += Points.get(Points.size()-1).PointWidth;
        }
      }
    }
    //println(SelectedEventPoint);

    return false;
  }



  void ReCalculatePoints() {    
    int CalculatedTimeStamp = 0;

    for (int i = 0; i< Points.size(); i++) {
      if (i ==0) {
        Points.get(i).TimeStamp = 0;
      } else {
        Points.get(i).TimeStamp = CalculatedTimeStamp;
      }

      CalculatedTimeStamp += Points.get(i).PointWidth;
    }
    lastTimeStamp = CalculatedTimeStamp;
  }
}


public class MotionChannelHandler {
  ArrayList<MotionChannel> Channels = new ArrayList<MotionChannel>();
  int ClosedChannelHeight = 40;
  int ParentHeight, ParentWidth;
  int topHeight;
  int ViewableMin;
  int ViewableMax;
  int SelectedChannel = -1;
  int HoveredChannel = -1;
  PointManipulationSystem PMS;

  PApplet parent;

  MotionChannelHandler(PApplet par, int Pwidth, int Pheight, PointManipulationSystem pms) {
    parent = par;
    ParentHeight = Pheight;
    ParentWidth = Pwidth;
    //println(ParentHeight);
    topHeight = ParentHeight - int(ClosedChannelHeight * 7.70);
    PMS = pms;
  }

  void drawChannels(int indMin, int indMax) {
    if (indMax > Channels.size()-1) indMax = Channels.size()-1;
    ViewableMin = indMin;
    ViewableMax = indMax;

    int drawIndex = 0;
    parent.noStroke();
    for (int i = indMin; i <= indMax; i++) {
      MotionChannel CurrentChannel = Channels.get(i);
      if (i == SelectedChannel) {
        parent.fill(Color_AkzentB);
        //parent.stroke(255,0,0);
        //parent.strokeWeight(5);
        CurrentChannel.SelectedChannel = true;
      } else {
        //parent.stroke(0,0,0);
        //parent.strokeWeight(1);
        parent.fill(CurrentChannel.ChannelColor);
        CurrentChannel.SelectedChannel = false;
      }
      parent.stroke(Color_AkzentA);
      parent.rect(0, topHeight+drawIndex*ClosedChannelHeight, ParentWidth, ClosedChannelHeight);
      CurrentChannel.drawEventPoints(0, 20, topHeight+drawIndex*ClosedChannelHeight, ClosedChannelHeight);
      drawIndex++;
    }
  }



  void addChannel(MotionChannel newMotionChannel) {
    Channels.add(newMotionChannel);
  }
  void addChannel() {
    Channels.add(new MotionChannel(parent));
  }

  boolean CheckSelected(int Mx, int My, boolean Clicked, boolean Dragged, boolean Shifted) {
    //println(ViewableMax-ViewableMin+1);
    //println(Clicked);   

    if (My > topHeight) {

      int my = My - topHeight;
      //println((ViewableMax-ViewableMin+1)*ClosedChannelHeight);
      //println(my / ClosedChannelHeight);
      //println((ViewableMax-ViewableMin+1)*ClosedChannelHeight);
      if (my / ClosedChannelHeight < (ViewableMax-ViewableMin+1)) {
        //println(Clicked);   

        //println("Klicked!!");
        if (HoveredChannel == ViewableMin + int(my / ClosedChannelHeight) && Clicked) {
          SelectedChannel = HoveredChannel;
          MotionChannel CurrentChannel = Channels.get(SelectedChannel);
          CurrentChannel.checkSelected(Mx, Clicked, Dragged, Shifted, PMS);
          for (int k = 0; k < motionHandler.Channels.size(); k++) {
            if (k == motionHandler.SelectedChannel)continue;
            motionHandler.Channels.get(k).SelectedEventPoint = -1;
            motionHandler.Channels.get(k).HoveredEventPoint = -1;
            motionHandler.Channels.get(k).selectedLink = -1;
            motionHandler.Channels.get(k).hoveredLink = -1;
          }
        } else {
          HoveredChannel = ViewableMin + int(my / ClosedChannelHeight);
        }
      }
    }
    return false;
  }

  void AddPointToChannel(int ChannelIndex) {
    Channels.get(ChannelIndex).addPoint();
  }


  void SetPointData(int DataType, int Name, int Value) {
    //println(DataType);
    //println(Name);
    if (SelectedChannel > -1) {
      if (Channels.get(SelectedChannel).SelectedEventPoint > -1) {
        if (DataType == 0) {
          int oldWidth = Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).PointWidth;
          Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).PointType = Name;
          Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).EventPointType = Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).pointTypes.get(Name);
          if (Name == 1) {
            Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).EventPointType = Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).pointTypes.get(Name);
            Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).PointWidth = 0;
            Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).Value = Value;
            //println(Value);
            Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).update();
          }
          println("#############");
          //println(Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint).EventPointType);
        }



        for (int i = 0; i < Channels.size(); i++) {
          ReCalculateChannel(i);
        }
      }
    }
  }

  void setManualPointData(int ChannelNumber, int PointNumber, int Name, int Value, int Width) {

    if (ChannelNumber > -1) {
      if (PointNumber > -1) {
        if (0 == 0) {
          int oldWidth = Channels.get(ChannelNumber).Points.get(PointNumber).PointWidth;
          Channels.get(ChannelNumber).Points.get(PointNumber).PointType = Name;
          Channels.get(ChannelNumber).Points.get(PointNumber).EventPointType = Channels.get(ChannelNumber).Points.get(PointNumber).pointTypes.get(Name);
          if (Name == 1) {
            Channels.get(ChannelNumber).Points.get(PointNumber).EventPointType = Channels.get(ChannelNumber).Points.get(PointNumber).pointTypes.get(Name);
            Channels.get(ChannelNumber).Points.get(PointNumber).PointWidth = 0;
            Channels.get(ChannelNumber).Points.get(PointNumber).Value = Value;
            //println(Value);
            Channels.get(ChannelNumber).Points.get(PointNumber).update();
          } else if (Name == 0) {
            Channels.get(ChannelNumber).Points.get(PointNumber).EventPointType = Channels.get(ChannelNumber).Points.get(PointNumber).pointTypes.get(Name);
            Channels.get(ChannelNumber).Points.get(PointNumber).PointWidth = Width;
            Channels.get(ChannelNumber).Points.get(PointNumber).Value = Value;
            //println(Value);
            Channels.get(ChannelNumber).Points.get(PointNumber).update();
          }
          println("#############");
          //println(Channels.get(ChannelNumber).Points.get(PointNumber).EventPointType);
        }



        for (int i = 0; i < Channels.size(); i++) {
          ReCalculateChannel(i);
        }
      }
    }
  }

  void ReCalculateChannel(int ChannelID) {    
    int CalculatedTimeStamp = 0;

    for (int i = 0; i< Channels.get(ChannelID).Points.size(); i++) {
      if (i == 0) {
        Channels.get(ChannelID).Points.get(i).TimeStamp = 0;
      } else {
        Channels.get(ChannelID).Points.get(i).TimeStamp = CalculatedTimeStamp;
        if (i < Channels.get(ChannelID).Points.size()-2) {
          println(4);
          if (!Channels.get(ChannelID).Points.get(i).ControlPointsEdited) {
            println(5);
            if (i > 0) {
              println(6);
              println("Recalc ControllPoints");
              int lastX = motionHandler.Channels.get(ChannelID).Points.get(i-1).TimeStamp;
              int lastY = motionHandler.Channels.get(ChannelID).Points.get(i-1).Value;

              int nextX = motionHandler.Channels.get(ChannelID).Points.get(i+1).TimeStamp;
              int nextY = motionHandler.Channels.get(ChannelID).Points.get(i+1).Value;


              int Ex1, Ey1, Ex2, Ey2;

              Ex1 = lastX+(nextX-lastX)/3;
              Ey1 = lastY+(nextY-lastY)/3;

              Ex2 = lastX+(nextX-lastX)/3*2;
              Ey2 = lastY+(nextY-lastY)/3*2;



              Channels.get(ChannelID).Points.get(i).ControlPoint1.x = Ex1;
              Channels.get(ChannelID).Points.get(i).ControlPoint1.y = Ey1;


              Channels.get(ChannelID).Points.get(i).ControlPoint2.x = Ex2;
              Channels.get(ChannelID).Points.get(i).ControlPoint2.y = Ey2;
            }
          }
        }
      }

      CalculatedTimeStamp += Channels.get(ChannelID).Points.get(i).PointWidth;
    }
    Channels.get(ChannelID).lastTimeStamp = CalculatedTimeStamp;
  }


  void NavigateArrow(char Dir) {
    boolean worked = true;

    switch(Dir) {
    case 'R':
      if (Channels.get(SelectedChannel).SelectedEventPoint < Channels.get(SelectedChannel).Points.size()-1) Channels.get(SelectedChannel).SelectedEventPoint++;    
      else {
        Channels.get(SelectedChannel).Points.add(new EventPoint(Channels.get(SelectedChannel).lastTimeStamp));
        Channels.get(SelectedChannel).lastTimeStamp += Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).Points.size()-1).PointWidth;
      }
      break;
    case 'L':
      if (Channels.get(SelectedChannel).SelectedEventPoint > 0) Channels.get(SelectedChannel).SelectedEventPoint--;    
      break;
      /*
    case 'U':
       if (SelectedChannel < Channels.size()-1) SelectedChannel++;
       break;
       case 'D':
       if (SelectedChannel > 0) SelectedChannel--;    
       break;  */

    default:
      worked = false;
      break;
    }
    if (worked) {
      PMS.LoadPointInformaiton(Channels.get(SelectedChannel).Points.get(Channels.get(SelectedChannel).SelectedEventPoint));
    }
  }


  float[] getMomentValues(int CursorPos) {
    float[] ret = new float[Channels.size()];
    print("Channelmenge:  ");
    println(Channels.size());
    for (int ScanChannels = 0; ScanChannels < Channels.size(); ScanChannels++) {
      for (int ScanBlocks = 1; ScanBlocks < Channels.get(ScanChannels).Points.size()-1; ScanBlocks++ ) {
       
        if (!Channels.get(ScanChannels).Points.get(ScanBlocks).IsPoint) {
          println("VOID");
          if (Channels.get(ScanChannels).Points.get(ScanBlocks).TimeStamp <= CursorPos && Channels.get(ScanChannels).Points.get(ScanBlocks).TimeStamp + Channels.get(ScanChannels).Points.get(ScanBlocks).PointWidth > CursorPos) {
            print("Treffer ");
            println(ScanBlocks);
            int PosInVoid = CursorPos - Channels.get(ScanChannels).Points.get(ScanBlocks).TimeStamp;


            float f = map(PosInVoid, 0, Channels.get(ScanChannels).Points.get(ScanBlocks).PointWidth, 0, 1);
            if (Channels.get(ScanChannels).Points.get(ScanBlocks-1).IsPoint && Channels.get(ScanChannels).Points.get(ScanBlocks+1).IsPoint) {
              println("Play Data");
              //int Value = GetBezier(Channels.get(ScanChannels).Points.get(ScanBlocks-1).TimeStamp,Channels.get(ScanChannels).Points.get(ScanBlocks-1).Value,Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint1.x,Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint1.y,Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint2.x,Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint2.y,Channels.get(ScanChannels).Points.get(ScanBlocks).TimeStamp,Channels.get(ScanChannels).Points.get(ScanBlocks).Value).y;
              PVector vec = GetBezier(Channels.get(ScanChannels).Points.get(ScanBlocks-1).TimeStamp, Channels.get(ScanChannels).Points.get(ScanBlocks-1).Value, Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint1.x, Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint1.y, Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint2.x, Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint2.y, Channels.get(ScanChannels).Points.get(ScanBlocks+1).TimeStamp, Channels.get(ScanChannels).Points.get(ScanBlocks+1).Value, f);
              //Value = GetBezier(Channels.get(ScanChannels).Points.get(ScanBlocks-1).TimeStamp,Channels.get(ScanChannels).Points.get(ScanBlocks-1).Value,Channels.get(ScanChannels).Points.get(ScanBlocks).ControlPoint1.x, 0, 0, 0, 0, 0, f);
              print(vec.x);
              print("  ");
              println(vec.y);
              parent.fill(0,255,0);
              parent.ellipse(vec.x,vec.y + CurveControlYOffset,10,10);
              ret[ScanChannels] = vec.y;
              
            }
          }
        } else println("Point");
      }
    }



    return ret;
  }

  PVector GetBezier(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float t) {
    PVector ret = new PVector();

    float X = pow(1-t, 3) * x0 + 3*pow(1-t, 2)*t * x1 + 3* (1-t) * pow(t, 2) * x2 + pow(t, 3) * x3;
    float Y = pow(1-t, 3) * y0 + 3*pow(1-t, 2)*t * y1 + 3* (1-t) * pow(t, 2) * y2 + pow(t, 3) * y3;

    ret.x = X;
    ret.y = Y;

    return ret;
  }
}



public class EventPoint {
  ArrayList<EventPointTypes> pointTypes = new ArrayList<EventPointTypes>(); //Verfügbare Punkttypen
  EventPointTypes EventPointType;                                           // gesetzter Punkttyp
  int PointType = 0;
  int PointWidth;
  int TimeStamp;
  boolean IsPoint = false;
  int Value = 0;
  PVector ControlPoint1, ControlPoint2;
  boolean ControlPointsEdited = false;


  color EventPointColor = Color_AkzentC;
  EventPoint(int timeStamp) {

    ControlPoint1 = new PVector(0, 0);
    ControlPoint2 = new PVector(0, 0);
    pointTypes.add(new EventPointTypes("void", true, false));
    pointTypes.add(new EventPointTypes("point", false, true));
    pointTypes.add(new EventPointTypes("Halt", false, true));
    EventPointType = pointTypes.get(0);
    PointWidth = 20;
    TimeStamp = timeStamp;
  }
  void update() {
    if (PointType == 0) {
      IsPoint = false;
      EventPointColor = Color_AkzentC;
    } else if (PointType == 1) {
      PointWidth = 1;
      IsPoint = true;
      EventPointColor = ForeGroundA;
    } else {
      PointWidth = 10;
      IsPoint = true;
      EventPointColor = ForeGroundC;
    }
  }
  void giveFeedback(boolean really) {
    //if (really)println("I got selected");
  }
}


public class EventPointTypes {
  String Name;
  boolean WidthIsAdjustable;
  boolean IsPoint;
  EventPointTypes(String name, boolean widthIsAdjustable, boolean isPoint) {
    Name = name;
    WidthIsAdjustable = widthIsAdjustable;
    IsPoint = isPoint;
  }
}
