import fpstracker.core.*;

PerfTracker ptt;

boolean isComplete;
String path;
String folder;
ArrayList<String> files;
int numberOfDatas;

String[] types = {
  "0_monographie", 
  "1_carte", 
  "2_image", 
  "3_fascicule", 
  "4_manuscrit", 
  "5_partition", 
  "6_sonore", 
  "7_objet", 
  "8_video"};

processing.data.Table table;

void settings() {
  size(500, 500, P2D);
}

void setup() {
  ptt = new PerfTracker(this, 100);

  path= "E:/01_Developpement/Gallica/OfflineData/";
  folder = types[7];
  files = new ArrayList<String>();

  files = FilesLoader.getAllPathToTypeFilesFrom(this, path+folder, "json");
  JSONObject jso = loadJSONObject(files.get(0));
  //set global
  numberOfDatas = jso.getInt("numberOfRecords");
  println("numberOfDatas: "+numberOfDatas);


  table = new processing.data.Table();
  table.addColumn("contributor");
  table.addColumn("publisher");
  table.addColumn("date");
  table.addColumn("source");
  table.addColumn("title");
  table.addColumn("relation");

  frameRate(300);
}

void draw() {
  if (frameCount <= files.size()) {
    convertIntoCSV(frameCount-1);
  } else {
    isComplete = true;
    println("Data has been process");
  }
  /*
  if (!isComplete) {
   //gatherIntoOneFile();
   convertIntoCSV();
   isComplete = true;
   println("Data has been process");
   }*/


  ptt.display(0, 0);
}

//GLOBAL
void gatherIntoOneFile() {
  JSONObject dataFile = new JSONObject();
  JSONArray datas = new JSONArray();
  for (int i=0; i<files.size(); i++) {
    String filename = files.get(i);
    JSONObject jso = loadJSONObject(filename);
    //set global
    dataFile.setInt("numberOfRecords", jso.getInt("numberOfRecords"));

    //set array
    JSONArray jsodatas = jso.getJSONArray("records");
    for (int j=0; j<jsodatas.size(); j++) {
      JSONObject value = jsodatas.getJSONObject(j);
      datas.setJSONObject(datas.size(), value);
    }
    dataFile.setJSONArray("records", datas);

    saveJSONObject(dataFile, folder+"_alldata.json");
    println("\tprocess json "+i);
  }
}

void convertIntoCSV() {
  processing.data.Table table = new processing.data.Table();
  table.addColumn("contributor");
  table.addColumn("publisher");
  table.addColumn("date");
  table.addColumn("source");
  table.addColumn("title");
  table.addColumn("relation");

  for (int i=0; i<files.size(); i++) {
    String filename = files.get(i);
    JSONObject jso = loadJSONObject(filename);

    //set array
    JSONArray jsodatas = jso.getJSONArray("records");
    for (int j=0; j<jsodatas.size(); j++) {
      JSONObject value = jsodatas.getJSONObject(j);

      processing.data.TableRow row = table.addRow();

      setCSVRow(value, "contributor", row);
      setCSVRow(value, "publisher", row);
      setCSVRow(value, "date", row);
      setCSVRow(value, "source", row);
      setCSVRow(value, "title", row);
      setCSVRow(value, "relation", row);

      saveTable(table, folder+"_alldata.csv");
    }
    println("\tprocess json int csv"+i);
  }
}

void convertIntoCSV(int i) {

  String filename = files.get(i);
  JSONObject jso = loadJSONObject(filename);

  //set array
  JSONArray jsodatas = jso.getJSONArray("records");
  for (int j=0; j<jsodatas.size(); j++) {
    JSONObject value = jsodatas.getJSONObject(j);

    processing.data.TableRow row = table.addRow();

    setCSVRow(value, "contributor", row);
    setCSVRow(value, "publisher", row);
    setCSVRow(value, "date", row);
    setCSVRow(value, "source", row);
    setCSVRow(value, "title", row);
    setCSVRow(value, "relation", row);

    saveTable(table, folder+"_alldata.csv");
  }
  println("\tprocess json int csv"+i);
}


//HELPER
void setCSVRow(JSONObject jso, String data, processing.data.TableRow row) {
  if (jso.getString(data) != null) {
    row.setString(data, jso.getString(data));
  } else {
    row.setString(data, "unknown");
  }
}
