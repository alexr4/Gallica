import fpstracker.core.*;
import fpstracker.ui.*;
import java.util.*;
import java.text.SimpleDateFormat;

PerfTracker ptt;

String path= "E:/Dropbox/_ENSEIGNEMENTS/Gallica/OfflineData/OAI-PMH/gallica_";
String[] types = {
  "audio", 
  "cartes", 
  "images", 
  "imagescartes", 
  "imagesdessins", 
  "imagesestampes", 
  "imagesobjets", 
  "imagesphotographies", 
  "manuscrits", 
  "monographies", 
  "objets", 
  "partitions", 
  "videos"
};

String[] queries = {
  "datestamp", 
  "date", 
  "source", 
  "contributor", 
  "publisher"
};

int dataPerIteration = 5000;
ArrayList<DataProcessor> dataprocessorlist;
int nbStarted;
boolean allStarted;

int typeIndex;
int index;
DataProcessor dp;

void settings() {
  size(500, 500, P2D);
}

void setup() {
  ptt = new PerfTracker(this, 100);



  dataprocessorlist = new ArrayList<DataProcessor>();

  typeIndex = 3;
  index = 3;
 // for (int j=0; j<types.length; j++) {
    //typeIndex = j;
    String file = types[typeIndex];
    JSONObject jso = loadJSONObject(path+file+".json");
    println(path+file+".json has been loaded");
    for (int i=0; i<queries.length; i++) {
      index = i;
      dp = new DataProcessor(this, file+"-"+queries[index], index + typeIndex * types.length, "data", file, jso, queries[index], dataPerIteration);
      dataprocessorlist.add(dp);
    }
 // }

  surface.setLocation(0, 0);
  frameRate(300);
}

void draw() {

  if (!allStarted) {
    for (DataProcessor dp : dataprocessorlist) {
      if (!dp.started) {
        dp.start();
        dp.started = true;
        nbStarted ++;
      }
    }
    if (nbStarted >= dataprocessorlist.size()) {
      allStarted = true;
    }
  }



  background(240);
  fill(0);
  noStroke();

  float x = 20;
  float y = 80;
  float lh = 15;
  float lw = 400;

  textSize(12);
  text("Processing Gallica data.\nTime passed: "+getStringTime(millis()), x, y);

  textSize(9);
  for (int i=0; i<dataprocessorlist.size(); i++) {
    DataProcessor dp = dataprocessorlist.get(i);

    float record = round(((float)dp.numberOfDataProcessed / (float)dp.numberOfDatas) * 100.0);
    boolean isRunning = dp.isComplete;
    String name = dp.name;
    float x_ = x;
    float y_ = y + lh * 2.0 * (i + 1);

    float mody = floor(y_ / (height - lh * 2));
    y_ -= ((height - lh * 2) * mody);
    y_ += (y+ lh * 2.0)*mody;
    x_ = x_+ lw * 1.01 * (mody);

    String state = name+" is running : "+(!isRunning);
    String process = (isRunning) ? "Complete at "+dp.timeToComplete : "Process at: "+record+"%, Last in "+dp.lastTimeToComplete;
    if (i%2 == 0) {
      float margin = 2;
      fill(220);
      rect( x_ - margin, y_ - margin, lw + margin * 2, lh * 2+ margin * 2);
    }
    fill(0);
    text(state+" — "+process+"\nNumber of documents: "+dp.numberOfDataProcessed+"/"+dp.numberOfDatas, x_, y_, lw, lh * 2);
  }

  ptt.display(0, 0);
}
