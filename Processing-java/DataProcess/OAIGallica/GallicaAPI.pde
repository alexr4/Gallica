//Query
String globalQuery = "http://oai.bnf.fr/oai2/OAIHandler?verb=ListRecords&metadataPrefix=oai_dc&set=gallica:typedoc:";
String[] types = {
  "audio", 
  "cartes", 
  "images", 
  "images:dessins", 
  "images:cartes", 
  "images:estampes", 
  "images:objets", 
  "images:photographies", 
  "manuscrits", 
  "monographies", 
  "partitions", 
  "objets", 
  "periodiques", 
  "videos"
};
int numberOfDocuments;

//helpers
int getNumberOfDocument(XML xml) {
  return int(xml.getChild("ListRecords").getChild("resumptionToken").getInt("completeListSize"));
}

String getNextResumptionToken(XML xml) {
  return xml.getChild("ListRecords").getChild("resumptionToken").getContent();
}
/*
//JSON Saver
 JSONObject savedDataFile = new JSONObject();
 JSONArray datas = new JSONArray();
 
 
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
 }*/
