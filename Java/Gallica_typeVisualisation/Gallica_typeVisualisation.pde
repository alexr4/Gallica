import fpstracker.core.*;
import processing.svg.*;
import processing.pdf.*;
PerfTracker ptt;

String globalQuery = "https://gallica.bnf.fr/SRU?operation=searchRetrieve&version=1.2&query=";
String type = "dc.type";
String operator = "all";
String and = "&";
String separator = "%20";
String[] types = {"monographie", 
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

  ptt = new PerfTracker(this, 100);
  frameRate(300);
}

void draw() {
  if (!isComputed) {
    computeData(pg);
    isComputed = true;
  } else {
    image(pg, 0, 0, width, height);
  }
  ptt.display(0, 0);
}

void computeData(PGraphics b) {
  float goldenRatio = (1.0 + sqrt(5.0)) / 2.0;
  float constant = 1.25;
  float rand = radians(1.0 / 1000.0);
  float sqrtBased = sqrt(pg.width * pg.width + pg.height * pg.height) / 2.0;

  b.beginDraw();
  b.background(0);
  b.fill(255);
  b.noStroke();
  float theta = 0.0;
  float radius = 0.0;
  float d = 0;
  int gIndex = 0;
  for (int i=0; i<numberOfElementsIntoGallica; i++) {
    /**
     phi = n*a;                                          
     r = c*sqrt(1.0*n);
     */
    radius = constant * sqrt((float)i * 2.0);
    theta = i * goldenRatio;//(TWO_PI * 100.0 * goldenRatio);
    float x = cos(theta) * radius + pg.width/2.0;
    float y = sin(theta) * radius + pg.height/2.0;
    if (i>indexToNextElement.get(gIndex)) { 
      gIndex ++;
    }
    float g = (1.0 - gIndex / (indexToNextElement.size() + 1.0));
    b.fill(g * 255.0);
    b.ellipse(x, y, 2, 2);

    if (i% 100000 == 0) {
      println(i);
    }
  }
  b.endDraw();
}

void computePDF(String name) {
  beginRecord(PDF, name+".pdf");
  computeData(g);
  endRecord();
}

void exportSVG(String name, int w, int h) {
  String exportName = name+".svg";
  PGraphics pgsvg = createGraphics(w, h, SVG, exportName);
  computeData(pgsvg);
  pgsvg.dispose();
}

void keyPressed() {
  String name = "GallicaTypeData";
  if (key == 'i') {
    println(name+"img start saving.");
    computeData(pg);
    pg.save("GallicaTypeData.png");
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
