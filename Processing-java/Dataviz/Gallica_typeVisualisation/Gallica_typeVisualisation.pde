import fpstracker.core.*;
import processing.svg.*;
import processing.pdf.*;
PerfTracker ptt;

String globalQuery = "https://gallica.bnf.fr/SRU?operation=searchRetrieve&version=1.2&query=";
String type = "dc.type";
String operator = "all";
String and = "&";
String separator = "%20";
String[] types = {
  "monographie", 
  "carte", 
  "image", 
  "fascicule", 
  "manuscrit", 
  "partition", 
  "sonore", 
  "objet", 
  "video"};
String collapsing = "collapsing=false";

color[] colors = {
  color(255, 210, 0),
  color(180, 210, 64),
  color(81, 210, 148),
  color(0, 204, 223),
  color(3, 172, 223),
  color(19, 140, 221),
  color(49, 93, 204),
  color(80, 52, 186),
  color(116, 1, 165)
};

//Data
int numberOfElementsIntoGallica;
ArrayList<Integer> numberOfElementsPerType = new ArrayList<Integer>();
ArrayList<Integer> indexToNextElement = new ArrayList<Integer>();


PGraphics pg;
boolean isComputed;
boolean zoom;

void settings() {
  size(1000, 1000, P2D);
  smooth(8);
}

public void setup() 
{
  int next = 0;
  for (int i=0; i<types.length; i++) {
    String request = globalQuery+type+separator+operator+separator+types[i]+and+collapsing;
    println(request);
    XML xml = loadXML(request);
    int numberOfElement = int(xml.getChild("srw:numberOfRecords").getContent());
    numberOfElementsPerType.add(numberOfElement);
    numberOfElementsIntoGallica += numberOfElement;
    next += numberOfElement;
    indexToNextElement.add(next);
  }
  println("Number of datas per types of documents");
  printArray(numberOfElementsPerType);
  printArray(indexToNextElement);
  println("Number of documents on the Gallica database : "+numberOfElementsIntoGallica);
  int n = 0;
  for (int i : numberOfElementsPerType) {
    n+=i;
  }
  println(n);
  pg = createGraphics(width * 8, height * 8, P2D);
  pg.smooth(8);

  //colorMode(HSB, 1.0, 1.0, 1.0, 1.0);
  ptt = new PerfTracker(this, 100);
  frameRate(300);
  surface.setLocation(0, 0);
}

void draw() {
  background(200);
  if (!isComputed) {

    pg.beginDraw();
    //pg.colorMode(HSB, 1.0, 1.0, 1.0, 1.0);  
    computeEvenCircleDistribution(pg, 0, 0);
    pg.endDraw();
    isComputed = true;
    println("Datavis has been generated");
  }

  int w = width;
  int h = height;
  float x = width/2;
  float y = height/2;
  if (mousePressed) {
    zoom = !zoom;
    w = pg.width;
    h = pg.height;
    x= map(mouseX, 0, width, -pg.width*0.5, pg.width*0.5);
    y= map(mouseY, 0, height, -pg.height*0.5, pg.height*0.5);
  }

  imageMode(CENTER);
  image(pg, x, y, w, h);

  ptt.display(0, 0);
}

void computeData(PGraphics b) {
  float goldenRatio = (1.0 + sqrt(5.0)) / 2.0;
  float constant = 1.25;
  float theta = 0.0;
  float radiusElement = 8.0;
  float radius = 10;
  float perimeter = (TWO_PI * radius);
  float nbElementPerRadius = (perimeter / (radiusElement * 2.0));
  float angleOffset = TWO_PI / nbElementPerRadius;
  float eta = random(TWO_PI);
  boolean updateRadius = false;
  println(nbElementPerRadius);
  int gIndex = 0;
  int line = 0;

  int indexOfType = 8;
  gIndex = indexOfType;
  numberOfElementsIntoGallica = numberOfElementsPerType.get(indexOfType);

  b.background(240);
  b.noStroke();
  for (int i=0; i<numberOfElementsIntoGallica; i++) {

    radius = constant * sqrt((float)i * 2.25);
    //theta = i * (TWO_PI * 0.01 * goldenRatio);
    theta = random(TWO_PI);
    /*
    if (int(theta % TWO_PI) == 0 && !updateRadius) {
     radius += radiusElement * 0.8;
     perimeter = (TWO_PI * radius);
     nbElementPerRadius = (perimeter / (radiusElement * 2.0));
     angleOffset = TWO_PI / nbElementPerRadius;
     eta += PI * 0.25;
     updateRadius = true;
     line ++;
     //println(line, "new line", nbElementPerRadius, angleOffset);
     } else if (int(theta % TWO_PI) != 0 ) {
     updateRadius = false;
     }
     theta += angleOffset;*/

    float x = cos(theta + eta) * radius + pg.width/2.0;
    float y = sin(theta + eta) * radius + pg.height/2.0;
    /*
    if (i>indexToNextElement.get(gIndex)) { 
     gIndex ++;
     }
     */
    float g = 1.0 - (gIndex / (indexToNextElement.size() + 1.0));
    //g = map(g, 0.0, 1.0, 140.0/360.0, 320.0/360.0);
    PVector P = getPalette(g, 
      new PVector(0.5, 0.5, 0.5), 
      new PVector(0.5, 0.5, 0.5), 
      new PVector(1.0, 1.0, 0.5), 
      new PVector(0.8, 0.9, 0.3));

    /*
                          new PVector(0.5, 0.5, 0.5), 
     new PVector(0.5, 0.5, 0.5), 
     new PVector(1.0, 1.0, 1.0),
     new PVector(0.0, 0.1, 0.2)
     */
    P.mult(255);
    b.fill(P.x, P.y, P.z);
    b.ellipse(x, y, radiusElement * 0.5, radiusElement * 0.5);

    if (i%500000 == 0) println(i);
  }
}

void computeEvenCircleDistribution(PGraphics b, int ox, int oy) {
  b.background(0);
  float r = 60;
  int nbPoint = 3 * 2;
  int count = 0;
  float radiusInc = 65;
  float radiusElement = 35;
  int pointInc = 3 * 2;
  int gIndex = 0;
  int max = numberOfElementsIntoGallica;
  int numberElementPerCircle = 100;

  //int indexOfType = 8;
  //gIndex = indexOfType;
  // max = numberOfElementsPerType.get(indexOfType);

  b.noStroke();
  b.fill(255);

  println(gIndex, count);

  for (int i=0; i<max; i++) {
    for (int j=0; j<nbPoint; j++) {
      float div = TWO_PI / nbPoint;
      float angle = j * div;
      float x = cos(angle) * r + ox;
      float y = sin(angle) * r + oy;



      float g = 1.0 - (gIndex / float(indexToNextElement.size() -1));
      //g = map(g, 0.0, 1.0, 140.0/360.0, 320.0/360.0);
      PVector P = getPalette((1.0 - g) + 1.25, 
        new PVector(0.5, 0.5, 0.5), 
        new PVector(0.5, 0.5, 0.5), 
        new PVector(1.0, 1.0, 0.5), 
        new PVector(0.8, 0.9, 0.3));
      P.mult(255);

      /*
                          new PVector(0.5, 0.5, 0.5), 
       new PVector(0.5, 0.5, 0.5), 
       new PVector(1.0, 1.0, 1.0),
       new PVector(0.0, 0.1, 0.2)
       */
      //count ++;
      count += numberElementPerCircle;
     /// if (gIndex < indexToNextElement.size()) {
      if (count>=indexToNextElement.get(gIndex)) { 
        gIndex ++;
        println(gIndex, count);
      }
  //  }
      if (count >= max) {
        break;
      } else {

       // b.fill(P.x, P.y, P.z);
        b.fill(colors[gIndex]);
        b.ellipse(x, y, radiusElement * 1.45, radiusElement * 1.45);
        /*
        b.pushMatrix();
         b.translate(x, y);
         b.rotate(angle);
         b.rect(0, 0, radiusElement * 1.25, radiusElement * 1.25);
         b.popMatrix();*/
      }
    }
    nbPoint += pointInc;
    r +=radiusInc;
    // println(gIndex, count);
    
    if (count >= max) {
      break;
    }
  }
  println(gIndex, count);
}

void computePDF(String name) {
  beginRecord(PDF, name+".pdf");
  computeData(g);
  endRecord();
}

PVector getPalette(float t, PVector A, PVector B, PVector C, PVector D) {
  float x = cos(TWO_PI * (C.x * t + D.x)); 
  float y = cos(TWO_PI * (C.y * t + D.y)); 
  float z = cos(TWO_PI * (C.z * t + D.z)); 

  B.x *= x;
  B.y *= y;
  B.z *= z;

  return A.add(B);
}

void exportSVG(String name, int w, int h) {
  String exportName = name+".svg";
  PGraphics pgsvg = createGraphics(w, h, SVG, exportName);
  pgsvg.beginDraw();
  pg.colorMode(HSB, 1.0, 1.0, 1.0, 1.0);  
  computeData(pgsvg);
  pgsvg.endDraw();
  pgsvg.dispose();
}

void keyPressed() {
  String name = "GallicaTypeData";
  if (key == 'i') {
    println(name+"img start saving.");
    pg.beginDraw();
    computeEvenCircleDistribution(pg, pg.width, pg.height);
    pg.beginDraw();
    pg.save("GallicaTypeData-TL.png");
    println(name+" saved.");

    pg.beginDraw();
    computeEvenCircleDistribution(pg, 0, pg.height);
    pg.beginDraw();
    pg.save("GallicaTypeData-TR.png");
    println(name+" saved.");

    pg.beginDraw();
    computeEvenCircleDistribution(pg, pg.width, 0);
    pg.beginDraw();
    pg.save("GallicaTypeData-BL.png");
    println(name+" saved.");

    pg.beginDraw();
    computeEvenCircleDistribution(pg, 0, 0);
    pg.beginDraw();
    pg.save("GallicaTypeData-BR.png");
    println(name+" saved.");
  }
  if (key == 's') {
    println(name+"svg start saving.");
    exportSVG("GallicaTypeData", width * 10, height * 10);
    println(name+" saved.");
  }
  if (key == 'p') {
    println(name+"pdf start saving.");
    computePDF("GallicaTypeData");
    println(name+" saved.");
  }
}
