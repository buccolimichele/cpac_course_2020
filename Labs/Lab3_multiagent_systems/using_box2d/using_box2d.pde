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
float DIST_TO_NEXT=50;
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
  cs  = new CircleShape();
  cs.m_radius = box2d.scalarPixelsToWorld(RADIUS_CIRCLE/2);
  bd.linearDamping=0;
  bd.angularDamping=0;
  
  path=new Path(9, 0.15, 0.3);
  
  String path=sketchPath()+"/sounds";
  File dir = new File(path);
  print(dir.isDirectory());
  filenames= dir.list();
  println(filenames);
  
}
void mousePressed() {
 if(mouseButton==LEFT){//insert a new box
    int i= int(min(random(0, filenames.length), filenames.length-1));
    int p=path.closestTarget(new Vec2(mouseX, mouseY));
    Box b = new Box(box2d, cs, bd, new PVector(mouseX, mouseY), new SoundFile(this, "sounds/"+filenames[i]),p);
    boxes.add(b);     
  }
  if(mouseButton==RIGHT){ 
    ;
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
  //  b2.bounce();
  }
  if (b2!=null) {  
    b2.play();
    b2.changeColor();
  }
  else{
  //   b1.bounce();
  }
}


void endContact(Contact cp) {
  ;
}

Vec2 computeForce(Box b){
  Vec2 pos=box2d.getBodyPixelCoord(b.body);
  Vec2 direction1= path.getDirection(pos, b.nextPoint);
  Vec2 direction2= path.getDirection(pos, path.nextPoint(b.nextPoint));
  Vec2 direction=direction1;
  if(direction.length() < DIST_TO_NEXT || direction2.length() < direction1.length()){
    b.nextPoint=path.nextPoint(b.nextPoint);
    direction= direction2;
  }

  return new Vec2(direction.x,-direction.y).mulLocal(0.5);
}
 
void draw() {
  fill(0,50);
  rect(width/2, height/2, width, height);
//  background(0,200);
  path.draw();
  box2d.step();
  boundaries.draw();
  for (Box b : boxes) {
    b.applyForce(computeForce(b));
    
    //path.draw(b.nextPoint);
    b.update(boxes);
    b.draw();
  }
}
