class JSONRecorder extends Thread {
  int speed = 300;
  PApplet parent;
  String name;
  int index;

  //data
  XML xml;
  String request;
  String type;
  String resumptionToken;
  int cursor = 0;
  int maximumRecords = 100;
  int numberOfDocuments;

  //tracker
  MillisTracker mt;
  String timeToComplete;

  //recorder
  boolean isFinished;
  JSONObject savedDataFile;
  JSONArray datas;

  JSONRecorder(PApplet parent, String name, int index, String request, String type) {
    super(name);

    this.savedDataFile = new JSONObject();
    this.datas = new JSONArray();

    this.parent = parent;
    this.index = index;
    this.request = request;
    this.xml = loadXML(request);
    this.numberOfDocuments = getNumberOfDocument(xml);
    this.type = type.replaceAll("\\p{Punct}", "");
    this.name = name+"_"+this.type;

    savedDataFile.setJSONArray("records", datas);

    if (this.numberOfDocuments != 0) {
      XML[] children = xml.getChild("ListRecords").getChildren("record");
      for (int i = 0; i < children.length; i++) {
        addData(children[i]);
      }
    } else {
      this.isFinished = true;
    }

    this.mt = new MillisTracker(this.parent, 100);
    this.savedDataFile.setInt("numberOfRecords", this.numberOfDocuments);
    saveJSONObject(this.savedDataFile, "data/gallica_"+this.type+".json");

    println("Thread: "+this.name+" has been created");
    this.start();
  }

  @Override public void run() {
    while (!isFinished) {
      iterateOverRecords();

      try {
        Thread.sleep(1000/speed);
      }
      catch(InterruptedException e) {
        //e.printStackTrace();
        println("Error on Thread "+name);
        e.printStackTrace();
      }
    }
  }

  void iterateOverRecords() {
    if (cursor < numberOfDocuments) {
      try {
        resumptionToken = getNextResumptionToken(xml);
        if (!resumptionToken.equals("")) { 
          request = "http://oai.bnf.fr/oai2/OAIHandler?resumptionToken="+resumptionToken+"&verb=ListRecords";
          xml = loadXML(request);
          cursor += maximumRecords;

          //println(cursor, maximumRecords);
          XML[] children = xml.getChild("ListRecords").getChildren("record");

          for (int i = 0; i < children.length; i++) {
            addData(children[i]);
          }

          saveJSONObject(savedDataFile, "data/gallica_"+type+".json");
          mt.addSample();
        } else {
          cursor = numberOfDocuments;
        }
      }
      catch(Exception e) {
        println("error has been catch on thread"+name+". Retry: "+request);
        e.printStackTrace();
      }
    } else {
      if (!isFinished) {
        int tmp = 0;
        for (Number i : mt.getSampleList()) {
          tmp += i.intValue();
        }
        int median =(int) median(mt.getSampleList());
        timeToComplete = getStringTime(tmp);
        println("Record finished in "+timeToComplete);
        println("\tMedian time for request: "+getStringTime(median));
        mt.computePanel();

        isFinished = true;
      } else {
        mt.displayPanel(0, 60);
      }
    }
  }

  void addData(XML data) {
    JSONObject jso = new JSONObject();
    
    if (data.getChild("header").getChild("datestamp")!= null) jso.setString("datestamp", data.getChild("header").getChild("datestamp").getContent());
    
    if (data.getChild("metadata") != null) {
      if (data.getChild("metadata").getChild("oai_dc:dc") != null) {
        XML recordData = data.getChild("metadata").getChild("oai_dc:dc");
        addContentToJSO(jso, recordData, "dc:identifier", "identifier");
        addContentToJSO(jso, recordData, "dc:contributor", "contributor");
        addContentToJSO(jso, recordData, "dc:publisher", "publisher");
        addContentToJSO(jso, recordData, "dc:date", "date");
        addContentToJSO(jso, recordData, "dc:source", "source");
        addContentToJSO(jso, recordData, "dc:title", "title");
        addContentToJSO(jso, recordData, "dc:relation", "relation");
      } else {
        // println(data);
      }
    } else {
      //println(request, data);
      if (data.getChild("header").getString("status")!= null) jso.setString("status", data.getChild("header").getString("status"));
      if (data.getChild("header").getChild("identifier")!= null) jso.setString("identifier", data.getChild("header").getChild("identifier").getContent());
    }

    // println(jso);
    datas.setJSONObject(datas.size(), jso);
  }

  void addContentToJSO(JSONObject jso, XML xml, String xmlData, String name) {
    if (xml.getChild(xmlData) != null) jso.setString(name, xml.getChild(xmlData).getContent());
  }
}
