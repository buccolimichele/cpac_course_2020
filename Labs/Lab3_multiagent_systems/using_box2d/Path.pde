class Path{
    Vec2[] points;
    int num_points;
    float alpha=0.4;
    Path(int num_points, float min_fact, float max_fact){
      this.num_points=num_points;
      this.points = new Vec2[this.num_points];
      float angle; 
      float fact=0.5*(min_fact+max_fact);
      for(int i=0; i<this.num_points; i++){
        angle=map(i, 0, this.num_points, 0, 2*PI);
        fact=this.alpha*random(min_fact, max_fact)+(1-alpha)*fact;
        this.points[i]=new Vec2(width*(0.5+fact*cos(angle)), height*(0.5+fact*sin(angle)));      
      } 
    }
    void draw(){
      stroke(255);
      for(int i=1; i<this.num_points; i++){
        line(this.points[i-1].x, this.points[i-1].y, this.points[i].x, this.points[i].y);
      }
      line(this.points[this.num_points-1].x, this.points[this.num_points-1].y, this.points[0].x, this.points[0].y);      
    }
    void draw(int i){
      fill(255);
      ellipse(this.points[i].x, this.points[i].y, DIST_TO_NEXT,DIST_TO_NEXT);
    }
    int closestTarget(Vec2 position){
       float min_dist=width+height;
       int argmin=-1;
       float dist;

       for(int i=0; i<this.num_points; i++){
         dist=position.sub(this.points[i]).length();
         if(dist<min_dist){min_dist=dist; argmin=i;}
       }
       return argmin;
    }
    int nextPoint(int i){
      return (i+1)%this.points.length;
    }
    Vec2 getPoint(int i){
      return this.points[i];
    }
    Vec2 getDirection(Vec2 pos, int i){
       return this.points[i].sub(pos);         
       
    }
}
