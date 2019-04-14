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

  printArray(numberOfElementsPerType);
  printArray(indexToNextElement);
  println(numberOfElementsIntoGallica);

  pg = createGraphics(width * 8, height * 8, P2D);
  pg.smooth(8);

  colorMode(HSB, 1.0, 1.0, 1.0, 1.0);
  ptt = new PerfTracker(this, 100);
  frameRate(300);
  surface.setLocation(0, 0);
}

void draw() {
  if (!isComputed) {
    pg.beginDraw();
    pg.colorMode(HSB, 1.0, 1.0, 1.0, 1.0);  
    computeData(pg);
    pg.endDraw();
    isComputed = true;
  }

  int w = width;
  int h = height;
  if (mousePressed) {
    zoom = !zoom;
    w = pg.width;
    h = pg.height;
  }

  imageMode(CENTER);
  image(pg, width*0.5, height*0.5, w, h);

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

  b.background(0);
  b.fill(255);
  b.noStroke();
  numberOfElementsIntoGallica = 4000000;
  for (int i=0; i<numberOfElementsIntoGallica; i++) {

    radius = constant * sqrt((float)i * 2.25);
    theta = i * goldenRatio;//(TWO_PI * 100.0 * goldenRatio);**/
    theta = random(TWO_PI);
    /*if (int(theta % TWO_PI) == 0 && !updateRadius) {
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

    if (i>indexToNextElement.get(gIndex)) { 
      gIndex ++;
    }
    float g = (gIndex / (indexToNextElement.size() + 1.0));
    //g = map(g, 0.0, 1.0, 140.0/360.0, 320.0/360.0);
    b.fill(g, 1.0, 1.0);
    b.ellipse(x, y, radiusElement * 0.5, radiusElement * 0.5);
  }
}

void computePDF(String name) {
  beginRecord(PDF, name+".pdf");
  computeData(g);
  endRecord();
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
    pg.colorMode(HSB, 1.0, 1.0, 1.0);  
    computeData(pg);
    pg.beginDraw();
    pg.save("GallicaTypeData.tif");
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
