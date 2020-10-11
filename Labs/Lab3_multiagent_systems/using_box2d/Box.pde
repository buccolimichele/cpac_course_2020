class Box{
    Body body;
    Box2DProcessing  box2d;
    color defColor = color(200, 200, 200);
    color contactColor;
    float time_to_color,time_index;
    int nextPoint;
    SoundFile sample;
    Box(Box2DProcessing  box2d, CircleShape ps, BodyDef bd, PVector position, SoundFile sample, int nextPoint){
        this.box2d = box2d;    
        bd.position.set(this.box2d.coordPixelsToWorld(position.x, position.y));
        this.body = this.box2d.createBody(bd);
        this.body.m_mass=1;
        //this.body.setLinearVelocity(new Vec2(0,3));       
        this.body.createFixture(ps, 1);
        this.body.setUserData(this);
        this.sample=sample;
        this.time_to_color=this.sample.duration()*frameRate;
        this.time_index=time_to_color;
        this.nextPoint=nextPoint;
        colorMode(HSB, 255);
        this.contactColor= color(random(0,255),255,255);
        colorMode(RGB, 255);
    }
    void applyForce(Vec2 force){
      this.body.applyForce(force, this.body.getWorldCenter());
      
    }
    void draw(){
        Vec2 pos=this.box2d.getBodyPixelCoord(this.body);
        float angle=this.body.getAngle();
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(-angle);
        fill(lerpColor(this.contactColor, this.defColor, map(this.time_index, 0, this.time_to_color,0,1)));
        stroke(0);
        strokeWeight(0);
        //triangle(-WIDTHBOX/2, -HEIGHTBOX/2, WIDTHBOX/2, -HEIGHTBOX/2, 0, HEIGHTBOX/2);  
        //rectMode(CENTER);            
        //rect(0, 0, WIDTHBOX, HEIGHTBOX);
        ellipse(0, 0, RADIUS_CIRCLE, RADIUS_CIRCLE);  

        this.time_index=min(this.time_index+1, this.time_to_color);
        popMatrix();
    }
    void kill(){
        this.box2d.destroyBody(this.body);
    }

    void changeColor(){
        this.time_index=0;
    }
    void play(){
     // this.sample.jump(0);
     if(! this.sample.isPlaying())      this.sample.play();    
    }
    void update(ArrayList<Box> boxes){
      Vec2 mypos=this.body.getPosition();
      Vec2 otherpos;
      Vec2 direction;
      float dist;
      float steerDist=6;
      for(Box other: boxes){
        if(this.body==other.body){continue;}
        otherpos=other.body.getPosition();
        direction=otherpos.sub(mypos);        
        dist=direction.length();
        println(dist);
        if(dist<steerDist){
          direction.mulLocal(-3/dist);
          println("applying force!", direction);
          this.applyForce(direction); // normalization with respect to the length, but 
        }
      }
    }
    void bounce(){
      Vec2 vel=this.body.getLinearVelocity();
      Vec2 pos=this.box2d.getBodyPixelCoord(this.body);
      if(pos.y<HEIGHTBOX || pos.y>height-HEIGHTBOX){ //touching left or right border
        vel.y=-vel.y;
      }  
      if(pos.x<WIDTHBOX || pos.x>width-WIDTHBOX){ //touching top or bottom border
        vel.x=-vel.x;
      }
      this.body.setLinearVelocity(vel);
    }
}
