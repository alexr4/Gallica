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


void settings() {
  size(500, 500, P2D);
}

void setup() {
  ptt = new PerfTracker(this, 100);

  path= "E:/Dropbox/_ENSEIGNEMENTS/_3DI/_PARTAGE/OfflineData/";
  folder = types[2];
  files = new ArrayList<String>();

  files = FilesLoader.getAllPathToTypeFilesFrom(this, path+folder, "json");
  JSONObject jso = loadJSONObject(files.get(0));
  //set global
  numberOfDatas = jso.getInt("numberOfRecords");
  println("numberOfDatas: "+numberOfDatas);


  frameRate(300);
}

void draw() {


  if (!isComplete) {
    gatherIntoOneFile();
    //convertIntoCSV();
    /*
    for (int i=0; i<files.size(); i++) {
     String filename = files.get(i);
     JSONObject jso = loadJSONObject(filename);
     if(jso.getString("error0") != null){
     println(filename);
     }
     }*/
    isComplete = true;
    println("Data has been process");
  }


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

    if (jso.getString("error0") != null) {
      println(filename);
    }

    saveJSONObject(dataFile, folder+"_alldata.json");
    println("\tprocess json "+i);
  }
}
