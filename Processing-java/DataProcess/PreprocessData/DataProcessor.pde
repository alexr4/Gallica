class DataProcessor extends Thread {
  //Thread
  int speed = 300;
  PApplet parent;
  String name;
  int index;
  boolean started;

  //data
  boolean isComplete;
  String path;
  String file;
  String dataToPerform;
  int numberOfDatas;
  int numberOfDataProcessed;
  JSONObject jso;

  JSONObject dataFile;
  JSONArray queryArray ;
  JSONArray jsodatas;

  int dataPerIteration;
  int end;
  int start;

  //trackers
  MillisTracker mt;
  String timeToComplete;
  String lastTimeToComplete = "";

  //affine query
  ArrayList<String> sourceToSub = new ArrayList<String>();

  DataProcessor(PApplet parent, String name, int index, String path, String file, JSONObject jso, String dataToPerform, int dataPerIteration) {
    super(name);
    this.name = name;
    this.parent = parent;
    this.index = index;
    this.file = file;
    this.path = path;
    this.dataToPerform = dataToPerform;

    this.jso = jso;

    numberOfDatas = jso.getInt("numberOfRecords");
    mt = new MillisTracker(this.parent, 100);
    mt.addSample();

    this.dataPerIteration = dataPerIteration;
    this.start = 0;
    this.end = this.dataPerIteration;


    dataFile = new JSONObject();
    queryArray = new JSONArray();
    dataFile.setJSONArray("Records", queryArray);
    //array of data
    jsodatas = jso.getJSONArray("records");

    println("Thread: "+name+" has been created for "+numberOfDatas+" datas");
  }

  @Override public void run() {
    while (!isComplete) {
      process(dataToPerform);
      start += dataPerIteration;
      end += dataPerIteration;

      try {
        Thread.sleep(1000/speed);
      }
      catch(InterruptedException e) {
        //e.printStackTrace();
        println("Error on Thread ");
      }
    }
  }

  //GLOBAL
  void process(String dataToPerform) {
    if (start < numberOfDatas) {
      int tmpStart = parent.millis();
      for (int i=start; i<end; i++) {
        if (i < jsodatas.size()) {
          JSONObject child = jsodatas.getJSONObject(i);
          String query = "";
          if (child.getString(dataToPerform) != null) {
            String value = child.getString(dataToPerform);
            //process data into readable
            if (dataToPerform.equals("date")) {
              query = returnAsSimpleDate(value);
            } else if (dataToPerform.equals("source")) {
              query = returnAsSimpleSource(value);
            } else {
              query = value;
            }
          } else {
            query = "unknown";
          }

          JSONArray datas = new JSONArray();
          if (dataFile.getJSONArray(query) == null) {
            dataFile.setJSONArray(query, datas);
            JSONObject newJSO = new JSONObject();
            newJSO.setString(dataToPerform, query);
            queryArray.setJSONObject(queryArray.size(), newJSO);
          } else {
            datas = dataFile.getJSONArray(query);
          }

          datas.setJSONObject(datas.size(), child);

          saveJSONObject(dataFile, path+"PreProcess/"+file+"_Per_"+dataToPerform+".json");
          numberOfDataProcessed = start;
          mt.addSample();
          //println("\tdata "+i+"/"+jsodatas.size()+" has been performed");
        }
      }
      int tmpEnd = parent.millis() - tmpStart;
      lastTimeToComplete = getStringTime(tmpEnd);
    } else {
      if (!isComplete) {
        int tmp = 0;
        for (Number n : mt.getSampleList()) {
          tmp += n.intValue() * 10;
        }
        int median =(int) median(mt.getSampleList()) * 10;
        timeToComplete = getStringTime(tmp);
        println("Record finished in "+getStringTime(tmp));
        println("\tMedian time for request: "+getStringTime(median));
        mt.computePanel();
        isComplete = true;
      } else {
      }
    }
  }

  String returnAsSimpleSource(String value) {
    String newValue = value;

    if (newValue.charAt(0) == (' ')) {
      newValue = value.substring(1);
    }

    if (sourceToSub.size() > 0) {
      boolean newSource = true;
      for (String s : sourceToSub) {
        float count = diff(newValue, s);
        if (count > 0.75) {
          newValue = s;
          newSource = false;
        } else {
        }
      }

      if (newSource) {
        sourceToSub.add(newValue);
      }
    } else {
      sourceToSub.add(value);
    }

    return newValue;
  }
}
