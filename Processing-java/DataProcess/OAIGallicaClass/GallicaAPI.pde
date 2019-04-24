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
  if (xml.getChild("ListRecords") != null) {
    return int(xml.getChild("ListRecords").getChild("resumptionToken").getInt("completeListSize"));
  } else {
    return 0;
  }
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
