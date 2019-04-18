//Query
String globalQuery = "https://gallica.bnf.fr/SRU?operation=searchRetrieve&version=1.2&query=";
String type = "dc.type";
String operator = "all";
String and = "&";
String separator = "%20";
String[] types = {
  "monographie", 
  "carte", 
  "image", 
  "fascicule", 
  "manuscrit", 
  "partition", 
  "sonore", 
  "objet", 
  "video"};
String collapsing = "collapsing=false";

//recorder
int numberOfDocuments;
int startRecord = 0;
int maximumRecords = 50;
String srQuery = and+"startRecord=";
String mrQuery = and+"maximumRecords=";

//helpers
int getNumberOfDocument(String request) {
  XML xml = loadXML(request);
 return int(xml.getChild("srw:numberOfRecords").getContent());
}


//JSON Saver
JSONObject savedDataFile = new JSONObject();
JSONArray datas = new JSONArray();


void addData(XML data){
  JSONObject jso = new JSONObject();
  
  jso.setString("identifier", "ark:/12148/"+data.getChild("srw:extraRecordData").getChild("uri").getContent());
  
  XML recordData = data.getChild("srw:recordData").getChild("oai_dc:dc");
  if(recordData.getChild("dc:contributor") != null) jso.setString("contributor", recordData.getChild("dc:contributor").getContent());
  if(recordData.getChild("dc:publisher") != null) jso.setString("publisher", recordData.getChild("dc:publisher").getContent());
  if(recordData.getChild("dc:date") != null) jso.setString("date", recordData.getChild("dc:date").getContent());
  if(recordData.getChild("dc:source") != null) jso.setString("source", recordData.getChild("dc:source").getContent());
  if(recordData.getChild("dc:title") != null) jso.setString("title", recordData.getChild("dc:title").getContent());
  if(recordData.getChild("dc:relation") != null) jso.setString("relation", recordData.getChild("dc:relation").getContent());
  
 // println(jso);
  datas.setJSONObject(datas.size(), jso);
}
