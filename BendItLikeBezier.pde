int x, y;
int numOfClicks;
float a1, b1, a2, b2, a3, b3, a4, b4;
float t, startTimer;
ArrayList<Storage> clicks;
ArrayList<PVector> pts;
boolean abc = false;
String s = "GOAL!!!" +"\n" + "Press R to play again";
PImage ball, field, runDef1, runDef2, standDef, mark,mark2,fireworks;
PFont font;
String i = "1st click: Aim which part of the goal to score" + "\n" + 
           "2nd/3rd Click: Determine how the ball curves" + "\n" +
           "Spacebar: Kick the ball!" + "\n" +
           "Press R if it is too difficult for you :(";
           
void setup() {
  ball = loadImage("ball.png");
  field = loadImage("field.jpg");
  runDef1 = loadImage("runDef1.png");
  runDef2 = loadImage("runDef2.png");
  standDef = loadImage("standDef.png");
  mark = loadImage("x.png");
  mark2 = loadImage("redx.png");
  fireworks = loadImage("fireworks.jpg");  //Load images into the sketch
  font = loadFont("AdobeArabic-BoldItalic-48.vlw");//load font into the sketch
  size(1152, 720);  //size must be exactly the dimension of the background to be able to use the image
  background(field);
  clicks = new ArrayList<Storage>();
  pts = new ArrayList<PVector>();
  image(mark,50,345,30,30);
  clicks.add(new Storage(0, 50, 360));  //set the first point which is fixed after every draw or reset into zeroth array in the arraylist
  numOfClicks = 1;                      //so that the next click would be saved in the first array in the arraylist
  a1 = random(200, 500); 
  b1 = random(100, 600);
  a2 = random(576, 975);
  b2 = random(100, 600); //randomise the 2 defenders's position
  a3 = 551;
  b3 = 0;
  a4 = 551;
  b4 = 570;             //fix two stationary defenders at the half court mark to increase difficulty        
  textFont(font, 16);
}

void draw() {
  text(i,75,47);      //instructions of the game
  smooth();
  image(runDef1, a1, b1, 50, 150);
  image(runDef2, a2, b2, 50, 150);
  image(standDef, a3, b3, 50, 150);
  image(standDef, a4, b4, 50, 150);
  if (abc ==true) {  //only execute the game when spacebar is pressed
    background(field);
    t = float(millis())/1000 - startTimer; //explained in previous cubic bezier sketch
    int currentKeyframe;
    for (currentKeyframe = 0; currentKeyframe < clicks.size()-1; currentKeyframe++)
    {
      if (clicks.get(currentKeyframe).time < t && clicks.get(currentKeyframe+1).time > t)
        break;
    }

    PVector pos;
    if (currentKeyframe == clicks.size()-1) {
      pos = clicks.get(currentKeyframe).position;
    } else {
      PVector p1 = clicks.get(currentKeyframe).position;
      PVector p2 = clicks.get(currentKeyframe+1).position;
      PVector cP1 = pts.get(currentKeyframe);
      PVector cP2 = pts.get(currentKeyframe+1);

      float t1 = clicks.get(currentKeyframe).time;
      float t2 = clicks.get(currentKeyframe+1).time;

      float nt = (t-t1)/(t2-t1);
      p1 = PVector.mult(p1, pow(1.0-nt, 3));
      p2 = PVector.mult(p2, pow(nt, 3));

      PVector p3 = PVector.mult(cP1, 3*sq(1-nt)*nt);
      PVector p4 = PVector.mult(cP2, 3*(1-nt)*sq(nt));

      pos = PVector.add(p1, p2);  
      pos = PVector.add(p3, pos);
      pos = PVector.add(p4, pos);
    }
    
    //reset the sketch if contact is made the defenders using the coordinates of the defender's position
    //and the radius of the soccer ball
    if (pos.x >= a1-10 && pos.x<= a1+50+10 && pos.y>=b1-10 && pos.y<=b1+150+10) {
      reset(); 
    }
    if (pos.x >= a2-10 && pos.x<= a2+50+10 && pos.y>=b2-10 && pos.y<=b2+150+10) {
      reset();
    }
    if (pos.x >= a3-10 && pos.x<= a3+50+10 && pos.y>=b3-10 && pos.y<=b3+150+10) {
      reset();
    }
    if (pos.x >= a4-10 && pos.x<= a4+50+10 && pos.y>=b4-10 && pos.y<=b4+150+10) {
      reset();
    }
    //brings to the celebration screen when goal scored which is when soccer ball contact the boundaries of the goal
    if (pos.x >= 1085-10 && pos.y>=315 && pos.y<=315+90) {
      restart();
    }
    //draw the image of the defenders and the ball throughout the interpolation
    pushMatrix();
    image(runDef1, a1, b1, 50, 150);
    image(runDef2, a2, b2, 50, 150);
    image(standDef, a3, b3, 50, 150);
    image(standDef, a4, b4, 50, 150);
    translate(pos.x, pos.y);
    image(ball, 0, 0, 20, 20);
    popMatrix();
  }
}

void mousePressed() {
  x = mouseX;
  y = mouseY;
  if (mouseButton == LEFT) {
    if (numOfClicks==1) {          //X mark targetting the point of goal
      image(mark,x-15,y-15,30,30); //minus 15 is added so that the center of the x is where the mouse click 
      clicks.add(new Storage(numOfClicks, x, y));//add first mouse click into first array of clicks arraylist
      numOfClicks++;          //add 1 to numOfClicks to register subsequent clicks
    } else if (numOfClicks>1 && numOfClicks<=3) {
      image(mark2,x-15,y-15,30,30);//red X mark targetting the point of goal
      pts.add(new PVector(x, y));//store the 2nd/3rd mouse click's position in PVector for the calculation
      numOfClicks++;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    abc = true;  //execute the kick after points are set
    startTimer = float(millis())/1000; 
  }
  if (key =='r' || key == 'R') {
    reset();    
  }
}

void reset() {
  abc = false;    //reset the entire sketch whenver it is called upon and clear all elements in any array/arraylist
  clicks.clear();
  pts.clear();
  setup();
}

void restart() {
  a1= -200;
  a2= -200;
  a3= -200;
  a4= -200;
  b1= -200;
  b2= -200;
  b3= -200;    
  b4= -200;      //get the defenders out of the sketch so they wouldnt be seen in the celebration screen
  background(fireworks);
  textFont(font, 48);
  textAlign(CENTER); //centralised the text alignment
  text(s, width/2, height/2);
  stroke(0);
  textAlign(CORNER); //reverse it back to its original position so not to affect the instruction text
}
