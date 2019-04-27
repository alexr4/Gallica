import fpstracker.core.*;
import fpstracker.ui.*;
import java.util.*;
import java.text.SimpleDateFormat;

PerfTracker ptt;

ArrayList<JSONRecorder> jsrlist;

int typeIndex=0;
boolean isFinished;

//unifinished data due to error 500 rpoblem
boolean partialGet = true;
int[] unfinished = {};


void settings() {
  size(1280, 500, P2D);
  //fullScreen(P2D);
  smooth(8);
}

void setup() {


  ptt = new PerfTracker(this, 100);

  jsrlist = new ArrayList<JSONRecorder>();
  int maxDocument = 100000;

  //for (int i=0; i<types.length; i++) {
    //if (i == 12) {
      String request = globalQuery+types[12];
      JSONRecorder jsr = new JSONRecorder(this, "jsr"+12, 12, maxDocument, request, types[12]);
      jsrlist.add(jsr);
    //}
  //}

  frameRate(300);
}

void draw() {
  background(240);
  fill(0);
  noStroke();

  float x = 20;
  float y = 80;
  float lh = 20;
  float lw = 500;

  textSize(12);
  text("Gathering Gallica data.\nTime passed: "+getStringTime(millis()), x, y);

  textSize(10);
  for (int i=0; i<jsrlist.size(); i++) {
    JSONRecorder jsr = jsrlist.get(i);
    float record = round(((float)jsr.cursor / (float)jsr.numberOfDocuments) * 100.0);
    boolean isRunning = jsr.isFinished;
    String name = jsr.name;
    
    float x_ = x;
    float y_ = y + lh * 2.0 * (i + 1);

    float mody = floor(y_ / (height - lh * 2));
    y_ -= ((height - lh * 2) * mody);
    y_ += (y+ lh * 2.0)*mody;
    x_ = x_+ lw * 1.01 * (mody);

    String state = name+" is running : "+isRunning;
    String process = (isRunning) ? "Compete at "+jsr.timeToComplete : "Process at: "+record+"%";
    
     if (i%2 == 0) {
      float margin = 2;
      fill(220);
      rect( x_ - margin, y_ - margin, lw + margin * 2, lh * 2+ margin * 2);
    }
    fill(0);
    text(state+" — "+process+"\nNumber of documents: "+jsr.cursor+"/"+jsr.numberOfDocuments, x_, y_, lw, lh * 2);
  }

  ptt.display(0, 0);
}
