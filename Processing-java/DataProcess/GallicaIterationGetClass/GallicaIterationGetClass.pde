import fpstracker.core.*;
import fpstracker.ui.*;
import java.util.*;
import java.text.SimpleDateFormat;

PerfTracker ptt;

ArrayList<JSONRecorder> jsrlist;

int typeIndex=3;
boolean isFinished;

//unifinished data due to error 500 rpoblem
boolean partialGet = false;
int[] unfinished = {39, 54};


void settings() {
  size(1280, 500, P2D);
  //fullScreen(P2D);
  smooth(8);
}

void setup() {
  //check the number of Elements
  String request = globalQuery+type+separator+operator+separator+types[typeIndex]+and+collapsing;
  println("Orginal request: "+request);
  int numberOfDocuments = getNumberOfDocument(request);

  println("Number of document: "+numberOfDocuments);

  ptt = new PerfTracker(this, 100);

  jsrlist = new ArrayList<JSONRecorder>();
  //732050
  int maxPerRequest = 50;
  int numberPerJSON = 10000;
  int numberOfParallelThread = ceil((float)numberOfDocuments / (float)numberPerJSON);
  
  int divider = 10;
  int numberOfParallelThreadPerParts = numberOfParallelThread / divider;
  int indexPart = 0;
  int startPart = indexPart * numberOfParallelThreadPerParts;
  int endPart = startPart + numberOfParallelThreadPerParts;
 // println(numberOfParallelThread);
  if (!partialGet) {
    for (int i=startPart; i<endPart; i++) {
      int start = i * numberPerJSON;
      JSONRecorder jsr = new JSONRecorder(this, "jsr"+i, i, start, numberPerJSON, maxPerRequest, numberOfDocuments, request);
      jsrlist.add(jsr);
    }
  } else {
    for (int i=0; i<unfinished.length; i++) {
      int index = unfinished[i];
      int start = index * numberPerJSON;
      JSONRecorder jsr = new JSONRecorder(this, "jsr"+index, index, start, numberPerJSON, maxPerRequest, numberOfDocuments, request);
      jsrlist.add(jsr);
    }
  }
  frameRate(300);
}

void draw() {
  background(240);
  fill(0);
  noStroke();

  float x = 20;
  float y = 80;
  float lh = 15;
  float lw = 200;

  textSize(12);
  text("Gathering Gallica data.\nTime passed: "+getStringTime(millis()), x, y);

  textSize(9);
  for (int i=0; i<jsrlist.size(); i++) {
    JSONRecorder jsr = jsrlist.get(i);
    float numberDocument = jsr.numberOfrecords;
    float record = round((numberDocument / (float)jsr.numberOfDocumentPerFile) * 100.0);
    boolean isRunning = jsr.isFinished;
    String name = jsr.name;
    float x_ = x;
    float y_ = y + lh * 2.0 * (i + 1);

    float mody = floor(y_ / height);
    y_ -= (height * mody);
    x_ = x_+ lw * 1.15 * (mody);

    String state = name+" is running : "+isRunning;
    String process = (isRunning) ? "Compete at "+jsr.timeToComplete : "Process at: "+record+"%";
    text(state+" — "+process+"\nNumber of documents: "+numberDocument, x_, y_, lw, lh * 2);
  }

  ptt.display(0, 0);
}
