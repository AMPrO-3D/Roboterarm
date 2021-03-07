public class CurveControlSystem {
  PApplet parent;
  int CanvasX, CanvasY, CanvasWidth, CanvasHeight;
  PVector CurrentEditingPoint1 = new PVector(-1, -1);
  PVector CurrentEditingPoint2 = new PVector(-1, -1);
  int EditingControlPoint = -1;
  int CurrentlySelectedChannel;
  int CurrentlySelectedNodeMode;
  int CurrentlySelectedNode;


  CurveControlSystem(PApplet par, int cX, int cY, int cW, int cH) {
    parent = par;
    CanvasX = cX;
    CanvasY = cY;
    CanvasWidth = cW;
    CanvasHeight = cH;
  }

  void drawCanvas() {
    
    parent.noFill();
    int startDensity = 150;
    int ShadowWidth = 15;
    float Stepsize = startDensity / ShadowWidth;
    float radiusAnpassung = 0.95;
    for (float i = 0;i < ShadowWidth; i += 0.9){        
        parent.stroke(0,startDensity-Stepsize*i);
        
        parent.rect(CanvasX-i, CanvasY+8-i , CanvasWidth-7+i*2, CanvasHeight-3+i*2, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung, 5+i*radiusAnpassung);
    }
    parent.fill(Color_AkzentB);
    parent.noStroke();
    parent.rect(CanvasX-10, CanvasY, CanvasWidth+10, CanvasHeight+10, 5, 5, 5, 5);
    
    //parent.rect(CanvasX, CanvasY + CanvasHeight-40, CanvasWidth, 25, 5, 5, 5, 5);
    


    parent.fill(Color_AkzentC);
    parent.strokeWeight(0.5);
    parent.stroke(Color_AkzentC);

    for (int i = 0;i < 257; i += 64){
      parent.line(CanvasX-10, CanvasY+i+4, CanvasWidth + CanvasX, CanvasY+i+4);
    }
    //parent.line(0, 0, motionHandler.Channels.get(0).Points.get(1).TimeStamp, motionHandler.Channels.get(0).Points.get(1).Value);
    //parent.line(mouseX, mouseY, 0, 0);

    for (int c = 0; c < motionHandler.Channels.size(); c++) {
      int lastX = 0;
      int lastY = 0;
      for (int i = 0; i < motionHandler.Channels.get(c).Points.size(); i++) {
        if (motionHandler.Channels.get(c).Points.get(i).IsPoint) {        //Calculating a Point
          //println("Point" + i);
          //parent.line(lastX, lastY, motionHandler.Channels.get(c).Points.get(i).TimeStamp, motionHandler.Channels.get(c).Points.get(i).Value);
          lastX = motionHandler.Channels.get(c).Points.get(i).TimeStamp;
          lastY =  motionHandler.Channels.get(c).Points.get(i).Value;
        } else {          //Calculating a Void
          if (i < motionHandler.Channels.get(c).Points.size()-1) {
            if (motionHandler.Channels.get(c).Points.get(i+1).IsPoint) {
              parent.noFill();                
              parent.stroke(ForeGroundB);
              parent.strokeWeight(3);
              //parent.line(lastX, lastY, nextX, nextY);

              parent.beginShape();
              parent.vertex(lastX, lastY+CurveControlYOffset);
              parent.bezierVertex(motionHandler.Channels.get(c).Points.get(i).ControlPoint1.x, motionHandler.Channels.get(c).Points.get(i).ControlPoint1.y+CurveControlYOffset, motionHandler.Channels.get(c).Points.get(i).ControlPoint2.x, motionHandler.Channels.get(c).Points.get(i).ControlPoint2.y+CurveControlYOffset, motionHandler.Channels.get(c).Points.get(i+1).TimeStamp, motionHandler.Channels.get(c).Points.get(i+1).Value+CurveControlYOffset);
              parent.endShape();
            }
          }
        }
      }
    }


    parent.fill(Color_AkzentC);
    parent.strokeWeight(1);
    parent.stroke(0);
    CurrentlySelectedChannel = motionHandler.SelectedChannel;
    if (CurrentlySelectedChannel > -1) {
      CurrentlySelectedNode = motionHandler.Channels.get(CurrentlySelectedChannel).SelectedEventPoint;
      if (CurrentlySelectedNode > -1) {
        CurrentlySelectedNodeMode = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).PointType;
        if (CurrentlySelectedNodeMode == 0) {
          //println("Wir sollten ein CurveInterface anzeigen!");
          int lastX = 0;
          int lastY = 0;
          if (CurrentlySelectedNode > 0 && CurrentlySelectedNode < motionHandler.Channels.get(CurrentlySelectedChannel).Points.size()-1) {
            //println(1);
            if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode-1).IsPoint) {
              //println(2);
              lastX = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode-1).TimeStamp;
              lastY = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode-1).Value;
              if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode+1).IsPoint) {
                //println(3);
                int nextX = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode+1).TimeStamp;
                int nextY = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode+1).Value;


                parent.stroke(0);
                parent.strokeWeight(1);

                float Ex1, Ey1;

                Ex1 = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint1.x;
                Ey1 = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint1.y;

                if (Ex1 == 0 || Ey1 == 0) {
                  println("da muss was faul sein!");
                  motionHandler.ReCalculateChannel(CurrentlySelectedChannel);
                }

                CurrentEditingPoint1.x = Ex1;
                CurrentEditingPoint1.y = Ey1;


                float Ex2, Ey2;

                Ex2 = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint2.x;
                Ey2 = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint2.y;

                if (Ex2 == 0 || Ey2 == 0) {
                  println("da muss was faul sein!");
                  motionHandler.ReCalculateChannel(CurrentlySelectedChannel);
                }

                CurrentEditingPoint2.x = Ex2;
                CurrentEditingPoint2.y = Ey2;




                parent.ellipse(Ex1, Ey1+CurveControlYOffset, 15, 15);
                parent.ellipse(Ex2, Ey2+CurveControlYOffset, 15, 15);

                parent.noFill();                
                parent.stroke(ForeGroundB);
                parent.strokeWeight(3);
                //parent.line(lastX, lastY, nextX, nextY);

                parent.beginShape();
                parent.vertex(lastX, lastY+CurveControlYOffset);
                parent.bezierVertex(Ex1, Ey1+CurveControlYOffset, Ex2, Ey2+CurveControlYOffset, nextX, nextY+CurveControlYOffset);
                parent.endShape();
              } else {
              }
            } else {
            }
          }
        }
      }
    }





    //if (motionHandler.Channels.get())
  }
  void CheckCurveControlInteraction(int Mx, int My, boolean Clicked, boolean Dragged) {
    if (Mx > CanvasX && Mx < CanvasX + CanvasWidth) {
      if  (My+CurveControlYOffset*2 > CanvasY && My+CurveControlYOffset*2 < CanvasY + CanvasHeight) {
        //println("CurveControl-Interaction");
        PVector MousePointer = new PVector(Mx, My);

        //println(CurrentEditingPoint1.dist(MousePointer));

        if (CurrentEditingPoint1.dist(MousePointer) < 7.5) {
          //ControlPointsEdited
          CurrentlySelectedChannel = motionHandler.SelectedChannel;
          if (CurrentlySelectedChannel > -1) {
            CurrentlySelectedNode = motionHandler.Channels.get(CurrentlySelectedChannel).SelectedEventPoint;
            if (CurrentlySelectedNode > -1) {
              CurrentlySelectedNodeMode = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).PointType;
              if (CurrentlySelectedNodeMode == 0) {
                if (CurrentlySelectedNode > 0 && CurrentlySelectedNode < motionHandler.Channels.get(CurrentlySelectedChannel).Points.size()-1) {
                  if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode-1).IsPoint) {
                    if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode+1).IsPoint) {
                      if (Dragged) {
                        EditingControlPoint = 1;
                        motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPointsEdited = true;
                        motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint1.x = MousePointer.x;
                        motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint1.y = MousePointer.y;
                      }
                    } else {
                    }
                  } else {
                  }
                }
              }
            }
          }
        } else if (CurrentEditingPoint2.dist(MousePointer) < 7.5) {
          //ControlPointsEdited
          CurrentlySelectedChannel = motionHandler.SelectedChannel;
          if (CurrentlySelectedChannel > -1) {
            CurrentlySelectedNode = motionHandler.Channels.get(CurrentlySelectedChannel).SelectedEventPoint;
            if (CurrentlySelectedNode > -1) {
              CurrentlySelectedNodeMode = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).PointType;
              if (CurrentlySelectedNodeMode == 0) {
                if (CurrentlySelectedNode > 0 && CurrentlySelectedNode < motionHandler.Channels.get(CurrentlySelectedChannel).Points.size()-1) {
                  if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode-1).IsPoint) {
                    if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode+1).IsPoint) {
                      if (Dragged) {
                        EditingControlPoint = 2;
                        motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPointsEdited = true;
                        motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint2.x = MousePointer.x;
                        motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint2.y = MousePointer.y;
                      }
                    } else {
                    }
                  } else {
                  }
                }
              }
            }
          }
        } else {
          println("Dragging out of ControlPoint Range!");
          println(EditingControlPoint);
          if (Dragged) {
            if (EditingControlPoint > -1) {
              CurrentlySelectedChannel = motionHandler.SelectedChannel;
              if (CurrentlySelectedChannel > -1) {
                CurrentlySelectedNode = motionHandler.Channels.get(CurrentlySelectedChannel).SelectedEventPoint;
                if (CurrentlySelectedNode > -1) {
                  CurrentlySelectedNodeMode = motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).PointType;
                  if (CurrentlySelectedNodeMode == 0) {
                    if (CurrentlySelectedNode > 0 && CurrentlySelectedNode < motionHandler.Channels.get(CurrentlySelectedChannel).Points.size()-1) {
                      if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode-1).IsPoint) {
                        if (motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode+1).IsPoint) {

                          if (EditingControlPoint == 1) {
                            motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPointsEdited = true;
                            motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint1.x = MousePointer.x;
                            motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint1.y = MousePointer.y;
                          } else if (EditingControlPoint == 2) {
                            motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPointsEdited = true;
                            motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint2.x = MousePointer.x;
                            motionHandler.Channels.get(CurrentlySelectedChannel).Points.get(CurrentlySelectedNode).ControlPoint2.y = MousePointer.y;
                          }
                        } else {
                        }
                      } else {
                      }
                    }
                  }
                }
              }
            }
          } else {
            EditingControlPoint = -1;
          }
        }
      }
    }
  }
}
