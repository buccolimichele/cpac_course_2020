import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

float WIDTHBOX=30;
int RADIUS_CIRCLE=30;
float HEIGHTBOX=100;
float SCALEFORCE=100000;
String filenames[];
Box2DProcessing box2d;
BodyDef bd;
Boundaries boundaries;
PolygonShape ps;
CircleShape cs;
Path path;
ArrayList<Box> boxes;
void setup() {
  size(1280, 720);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  box2d.listenForCollisions();
  boxes=new ArrayList<Box>();
  boundaries=new Boundaries(box2d, width, height);
  bd= new BodyDef();
  bd.type= BodyType.DYNAMIC;
  ps= new PolygonShape();
  /*Vec2[] vertices=new Vec2[3];
  vertices[0]=new Vec2(box2d.scalarPixelsToWorld(-WIDTHBOX/4), box2d.scalarPixelsToWorld(-HEIGHTBOX/4));  
  vertices[1]=new Vec2(box2d.scalarPixelsToWorld(+WIDTHBOX/4), box2d.scalarPixelsToWorld(-HEIGHTBOX/4));
  vertices[2]=new Vec2(box2d.scalarPixelsToWorld(0), box2d.scalarPixelsToWorld(+HEIGHTBOX/4));*/
  cs  = new CircleShape();
  cs.m_radius = box2d.scalarPixelsToWorld(RADIUS_CIRCLE/2);
  //ps.setAsBox(box2d.scalarPixelsToWorld(WIDTHBOX/2), box2d.scalarPixelsToWorld(HEIGHTBOX/2));
  bd.linearDamping=0;
  bd.angularDamping=0;
  
  path=new Path(20, 0.25, 0.5);
  
  String path=sketchPath()+"/sounds";
  File dir = new File(path);
  print(dir.isDirectory());
  filenames= dir.list();
  println(filenames);
  
}
void mousePressed() {
 if(mouseButton==LEFT){//insert a new box
    int i= int(min(random(0, filenames.length), filenames.length-1));
    Box b = new Box(box2d, cs, bd, new PVector(mouseX, mouseY), new SoundFile(this, "sounds/"+filenames[i]));
    boxes.add(b); 
    b.applyForce(new Vec2(random(-1, 1), random(-1, 1)).mulLocal(SCALEFORCE));
  }
  if(mouseButton==RIGHT){ // do the harlem shake
    for (Box b : boxes) {
      b.applyForce(new Vec2(random(-1, 1), random(-1, 1)).mulLocal(SCALEFORCE));  
    }
  }
}

void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  Body body1 = f1.getBody();
  Body body2 = f2.getBody();
  Box b1 = (Box) body1.getUserData();
  Box b2 = (Box) body2.getUserData();
  if (b1!=null) {
    b1.play();
    b1.changeColor();
  }
  else{
    b2.bounce();
  }
  if (b2!=null) {  
    b2.play();
    b2.changeColor();
  }
  else{
     b1.bounce();
  }
}


void endContact(Contact cp) {
  ;
}

void draw() {
  background(0);
  path.draw();
  box2d.step();
  boundaries.draw();
  for (Box b : boxes) {
    b.update(boxes);
    b.draw();
  }
}
