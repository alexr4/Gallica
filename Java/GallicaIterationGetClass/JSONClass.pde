class JSONRecorder extends Thread {
  PApplet parent;
  String name;
  int index;
  int numberOfDocuments;
  int numberOfDocumentPerFile;
  int numberOfrecords;
  int startRecord = 0;
  int endRecord;
  int maximumRecords = 50;
  String globalQuery;
  String srQuery = and+"startRecord=";
  String mrQuery = and+"maximumRecords=";

  //tracker
  MillisTracker mt;
  String timeToComplete;

  //recorder
  boolean isFinished;
  JSONObject savedDataFile;
  JSONArray datas;


  JSONRecorder(PApplet parent, String name, int index, int startRecord, int numberOfDocumentPerFile, int maximumRecords, int numberOfDocuments, String globalQuery) {
    super(name);
    this.name = name;
    
    savedDataFile = new JSONObject();
    datas = new JSONArray();

    this.parent = parent;
    this.index = index;
    this.startRecord = startRecord;
    this.numberOfDocuments = numberOfDocuments;
    this.numberOfDocumentPerFile = numberOfDocumentPerFile;
    this.maximumRecords = maximumRecords;
    this.globalQuery = globalQuery;
    this.endRecord = this.startRecord + this.numberOfDocumentPerFile;

    mt = new MillisTracker(this.parent, 100);
    savedDataFile.setInt("numberOfRecordsIntoFile", numberOfDocumentPerFile);
    savedDataFile.setInt("numberOfRecords", numberOfDocuments);
    
    println("Thread: "+name+" has been created");
    this.start();
  }

  @Override public void run() {
    while (!isFinished) {
      iterateOverRecords();
      try {
        Thread.sleep(10);
      }
      catch(InterruptedException e) {
        e.printStackTrace();
      }
    }
  }

  void iterateOverRecords() {
    if (startRecord < endRecord && maximumRecords > 0) {
      int tmpStart = startRecord;
      try {
        String request = globalQuery+srQuery+startRecord+mrQuery+maximumRecords;   
        XML xml = loadXML(request);
        int next = int(xml.getChild("srw:nextRecordPosition").getContent());
        startRecord = next;
        if (startRecord + maximumRecords > numberOfDocuments) {
          maximumRecords = numberOfDocuments - startRecord;
        }
        numberOfrecords += maximumRecords;
        //println(startRecord, maximumRecords, request);

        XML[] children = xml.getChild("srw:records").getChildren("srw:record");

        for (int i = 0; i < children.length; i++) {
          addData(children[i]);
        }
        savedDataFile.setJSONArray("records", datas);
        saveJSONObject(savedDataFile, "data/"+types[typeIndex]+"/gallica_"+typeIndex+"_"+types[typeIndex]+"_"+index+".json");
        mt.addSample();
      }
      catch(Exception e) {
        startRecord = tmpStart;
        println("error has been catch : "+e+"\n Retry at "+tmpStart);
      }
    } else {
      if (!isFinished) {
        int tmp = 0;
        for (Number i : mt.getSampleList()) {
          tmp += i.intValue();
        }
        int median =(int) median(mt.getSampleList());
        timeToComplete = getStringTime(tmp);
        println("Record finished in "+getStringTime(tmp));
        println("\tMedian time for request: "+getStringTime(median));
        mt.computePanel();
        isFinished = true;
      } else {
      }
    }
  }

  void addData(XML data) {
    JSONObject jso = new JSONObject();

    jso.setString("identifier", "ark:/12148/"+data.getChild("srw:extraRecordData").getChild("uri").getContent());

    XML recordData = data.getChild("srw:recordData").getChild("oai_dc:dc");
    if (recordData.getChild("dc:contributor") != null) jso.setString("contributor", recordData.getChild("dc:contributor").getContent());
    if (recordData.getChild("dc:publisher") != null) jso.setString("publisher", recordData.getChild("dc:publisher").getContent());
    if (recordData.getChild("dc:date") != null) jso.setString("date", recordData.getChild("dc:date").getContent());
    if (recordData.getChild("dc:source") != null) jso.setString("source", recordData.getChild("dc:source").getContent());
    if (recordData.getChild("dc:title") != null) jso.setString("title", recordData.getChild("dc:title").getContent());
    if (recordData.getChild("dc:relation") != null) jso.setString("relation", recordData.getChild("dc:relation").getContent());

    // println(jso);
    datas.setJSONObject(datas.size(), jso);
  }
}
