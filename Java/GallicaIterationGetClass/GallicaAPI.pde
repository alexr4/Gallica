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

//helpers
int getNumberOfDocument(String request) {
  XML xml = loadXML(request);
  return int(xml.getChild("srw:numberOfRecords").getContent());
}
