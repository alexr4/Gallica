class DataProcessor extends Thread {
  //Thread
  int speed = 300;
  PApplet parent;
  String name;
  int index;
  boolean started;

  //Original datas
  String path;
  String file;
  String dataToPerform;
  int numberOfDatas;
  JSONObject jso;
  JSONArray jsodatas; //arrays with all the data

  //New file data objects
  JSONObject dataFile; //final data file
  JSONArray queryArray; //array with all queries;
  JSONObject queryFile; //array with all the queries;

  //process
  boolean isComplete;
  int numberOfDataProcessed;
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
    //array of data
    this.jsodatas = jso.getJSONArray("records");

    numberOfDatas = jso.getInt("numberOfRecords");
    mt = new MillisTracker(this.parent, 100);
    //mt.addSample();

    this.dataPerIteration = dataPerIteration;
    this.start = 0;
    this.end = this.dataPerIteration;


    dataFile = new JSONObject();
    queryArray = new JSONArray();
    dataFile.setJSONArray("Records", queryArray);

    queryFile = new JSONObject();

    println("Thread: "+name+" has been created for "+numberOfDatas+" datas");
  }

  @Override public void run() {
    while (!isComplete) {
      int tmpStart = parent.millis();
      process(dataToPerform);
      start += dataPerIteration;
      end += dataPerIteration;

      try {
        saveJSONObject(dataFile, path+"PreProcess/"+file+"_Per_"+dataToPerform+".json");
        int tmpEnd = parent.millis() - tmpStart;
        lastTimeToComplete = getStringTime(tmpEnd);
        mt.addSample();
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
      for (int i=start; i<end; i++) {
        if (i < jsodatas.size()) {
          JSONObject child = jsodatas.getJSONObject(i);
          String query = "";
          /**
           step 1 : get the query to perform
           1.1 : check is the data to perform exist (yes : 1.2, no : 1.3)
           1.2 : check if the query is the type of date (1.2.1), source, (1.2.2), or other
           1.2.1 : if type is date, check the date format and reformat it if necessary (see helper function : returnAsSimpleDate) and define query
           1.2.2 : if type source, check the source format and get simplify one and define query
           1.2.3 : define query
           1.3 : if data to perform does not exist define as unknown
           */
          /**
           step 2 : fill the query type json file
           2.1 : check if the query exist into the query type file (yes 2.2, no : 2.3)
           2.2 : go to step 3
           2.3 : add query to the file and to add JSONArray to the final file and save file
           */
          /**
           step 3 : send jso to the right array in the final file and save file
           */
          if (child.getString(dataToPerform) != null) {
            String value = child.getString(dataToPerform);
            //process data into readable
            if (dataToPerform.equals("date")) {
              query = returnAsSimpleDate(value);
            } else if (dataToPerform.equals("source")) {
              query = returnAsSimpleSource(value, 0.65);
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

          numberOfDataProcessed = start;
          //println("\tdata "+i+"/"+jsodatas.size()+" has been performed");
        }
      }
    } else {
      if (!isComplete) {
        int tmp = 0;
        for (Number n : mt.getSampleList()) {
          //println(n);
          tmp += n.intValue();
        }
        //println(tmp);
        int median =(int) median(mt.getSampleList());
        timeToComplete = getStringTime(tmp);
        println("Record finished in "+getStringTime(tmp));
        println("\tMedian time for request: "+getStringTime(median));
        mt.computePanel();
        isComplete = true;
      } else {
      }
    }
  }

  String returnAsSimpleSource(String value, float ratio) {
    String newValue = value;
    //1-Convert all text to lower case in order to not deal with CAP/unCap sensitiveness
    newValue = newValue.toLowerCase();

    //2-remove all special charactere ("https://javarevisited.blogspot.com/2016/02/how-to-remove-all-special-characters-of-String-in-java.html")
    newValue = newValue.replaceAll("\\p{Punct}", "");
    newValue = newValue.replaceAll("[0-9]", "");

    //3-remove space when it's at the begining of a line
    if (newValue.length() > 0) {
      if (newValue.charAt(0) == (' ')) {
        newValue = value.substring(1);
      }
    }

    //4-compare string with other values of the array
    if (sourceToSub.size() > 0) {
      boolean newSource = true;
      for (String s : sourceToSub) {
        float count = diff(newValue, s);
        if (count > ratio) {
          newValue = s;
          newSource = false;
          break;
        } else {
        }
      }

      if (newSource) {
        sourceToSub.add(newValue);
      }
    } else {
      sourceToSub.add(newValue);
    }

    return newValue;
  }
}
