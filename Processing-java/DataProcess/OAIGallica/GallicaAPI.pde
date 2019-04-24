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

int getCursor(XML xml) {
  return int(xml.getChild("ListRecords").getChild("resumptionToken").getInt("cursor"));
}

String getNextResumptionToken(XML xml) {
  return xml.getChild("ListRecords").getChild("resumptionToken").getContent();
}

String defineNextResumptionToken(String[] resumptionToken, int cursor) {
  return resumptionToken[0]+"!"+
    resumptionToken[1]+"!"+
    resumptionToken[2]+"!"+
    resumptionToken[3]+"!"+
    cursor+"!"+
    resumptionToken[5]+"!"+
    resumptionToken[6];
}

//JSON Saver
JSONObject savedDataFile = new JSONObject();
JSONArray datas = new JSONArray();


void addData(XML data) {
  JSONObject jso = new JSONObject();

  jso.setString("datestamp", data.getChild("header").getChild("datestamp").getContent());

  XML recordData = data.getChild("metadata").getChild("oai_dc:dc");
  addContentToJSO(jso, recordData, "dc:identifier", "identifier");
  addContentToJSO(jso, recordData, "dc:contributor", "contributor");
  addContentToJSO(jso, recordData, "dc:publisher", "publisher");
  addContentToJSO(jso, recordData, "dc:date", "date");
  addContentToJSO(jso, recordData, "dc:source", "source");
  addContentToJSO(jso, recordData, "dc:title", "title");
  addContentToJSO(jso, recordData, "dc:relation", "relation");

  // println(jso);
  datas.setJSONObject(datas.size(), jso);
}

void addContentToJSO(JSONObject jso, XML xml, String xmlData, String name) {
  if (xml.getChild(xmlData) != null) jso.setString(name, xml.getChild(xmlData).getContent());
}
