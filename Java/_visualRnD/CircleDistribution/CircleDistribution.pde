import fpstracker.core.*;
import processing.svg.*;
import processing.pdf.*;
PerfTracker ptt;

PGraphics buffer;
boolean isComputed = false;
boolean zoom;

void setup() {
  size(1000, 1000, P2D);
  buffer = createGraphics(width * 8, height * 8, P2D);
  buffer.smooth(8);
  ptt = new PerfTracker(this, 100);
  frameRate(300);
}

void draw() {
  background(50);
  if (!isComputed) {
    buffer.beginDraw();
    computeEvenCircleDistribution(buffer);
    buffer.endDraw();
    isComputed = true;
  }


  int w = width;
  int h = height;
  float x = width/2;
  float y = height/2;
  if (mousePressed) {
    zoom = !zoom;
    w = buffer.width;
    h = buffer.height;
    x= map(mouseX, 0, width, -buffer.width*0.5, buffer.width*0.5);
    y= map(mouseY, 0, height, -buffer.height*0.5, buffer.height*0.5);
  }

  imageMode(CENTER);
  image(buffer, x, y, w, h);

  ptt.display(0, 0);
}

void computeEvenCircleDistribution(PGraphics b) {
  b.background(0);
  float r = 8;
  int nbPoint = 3 * 2;
  int max = 4218117;
  int count = 0;
  float radiusInc = 6;
  float radiusElement = 4;
  int pointInc = 3 * 2;


  b.noStroke();
  b.fill(255);
  for (int i=0; i<max; i++) {
    for (int j=0; j<nbPoint; j++) {
      float div = TWO_PI / nbPoint;
      float angle = j * div;
      float x = cos(angle) * r + b.width;
      float y = sin(angle) * r + b.height;
      b.ellipse(x, y, radiusElement, radiusElement);
      count ++;
      if (count >= max) {
        break;
      }
    }
    nbPoint += pointInc;
    r +=radiusInc;
    if (count%10000 == 0) println(count);
    if (count >= max) {
      break;
    }
  }

  println(count);
}

void keyPressed() {
  buffer.beginDraw();
  computeEvenCircleDistribution(buffer);
  buffer.endDraw();
  buffer.save("buffer.tif");
}
