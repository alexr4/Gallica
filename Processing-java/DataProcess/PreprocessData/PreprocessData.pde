import fpstracker.core.*;
import fpstracker.ui.*;
import java.util.*;
import java.text.SimpleDateFormat;

PerfTracker ptt;

String[] types = {
  "0_monographie_alldata", 
  "1_carte_alldata", 
  "2_image_alldata", 
  "3_fascicule_alldata", 
  "4_manuscrit_alldata", 
  "5_partition_alldata", 
  "6_sonore_alldata", 
  "7_objet_alldata", 
  "8_video_alldata"};

String[] queries = {
  "date", 
  "source", 
  "contributor", 
  "publisher"
};

ArrayList<DataProcessor> dataprocessorlist;
int nbStarted;
boolean allStarted;

void settings() {
  size(1000, 800, P2D);
}

void setup() {
  ptt = new PerfTracker(this, 100);

  String path= "E:/Dropbox/_ENSEIGNEMENTS/_3DI/_PARTAGE/OfflineData/";

  int dataPerIteration = 1000;
  dataprocessorlist = new ArrayList<DataProcessor>();

  for (int j=0; j<types.length; j++) {
    //int j=7;
    String file = types[j];
    if (j != 3) {
      JSONObject jso = loadJSONObject(path+file+".json");
      println(path+file+".json has been loaded");
      for (int i = 0; i<queries.length; i++) {
        DataProcessor dp = new DataProcessor(this, file+"-"+queries[i], i + j * types.length, file, jso, queries[i], dataPerIteration);
        dataprocessorlist.add(dp);
      }
    }
  }

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
  float lw = 500;

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

    float mody = floor(y_ / height);
    y_ -= (height * mody);
    x_ = x_+ lw * 1.15 * (mody);

    String state = name+" is running : "+(!isRunning);
    String process = (isRunning) ? "Compete at "+dp.timeToComplete : "Process at: "+record+"%, Last in "+dp.lastTimeToComplete;
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
