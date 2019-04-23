import fpstracker.core.*;
import fpstracker.ui.*;
import java.util.*;
import java.text.SimpleDateFormat;

PerfTracker ptt;
MillisTracker mt;

int typeIndex=12;
boolean isFinished;

XML xml;
String resumptionToken;

void settings() {
  size(500, 500, P2D);
  smooth(8);
}

void setup() {
  //check the number of Elements
  String request = globalQuery+types[typeIndex];
  println(request);
  xml = loadXML(request);
  println("Orginal request: "+request);
  numberOfDocuments = getNumberOfDocument(xml);
  println("Number of document: "+numberOfDocuments);
  resumptionToken = getNextResumptionToken(xml);
  println(resumptionToken);


  //274!7001!9150002!7189!100!47492!oai_dc
  //274!7001!9150002!7422!200!47492!oai_dc

  ptt = new PerfTracker(this, 100);
  mt = new MillisTracker(this, 100);

  frameRate(300);
}

void draw() {
  background(240);
  // iterateOverRecords();
  
  int start = millis();
  String request = "http://oai.bnf.fr/oai2/OAIHandler?resumptionToken="+resumptionToken+"&verb=ListRecords";
  xml = loadXML(request);
  resumptionToken = getNextResumptionToken(xml);
  int end = millis() - start;
  println(end, resumptionToken);


  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  textSize(24);
  text("Time passed: "+getStringTime(millis()), width/2, height/2);

  ptt.display(0, 0);
}
/*
void iterateOverRecords() {
 if (startRecord <= numberOfDocuments && maximumRecords > 0) {
 int tmpStart = startRecord;
 try {
 String request = globalQuery+type+separator+operator+separator+types[typeIndex]+and+collapsing+srQuery+startRecord+mrQuery+maximumRecords;   
 XML xml = loadXML(request);
 int next = int(xml.getChild("srw:nextRecordPosition").getContent());
 startRecord = next;
 if (startRecord + maximumRecords > numberOfDocuments) {
 maximumRecords = numberOfDocuments - startRecord;
 }
 println(startRecord, maximumRecords, request);
 
 XML[] children = xml.getChild("srw:records").getChildren("srw:record");
 
 for (int i = 0; i < children.length; i++) {
 addData(children[i]);
 }
 
 mt.addSample();
 }
 catch(Exception e) {
 startRecord = tmpStart;
 println("error has been catch. Retry "+tmpStart);
 }
 } else {
 if (!isFinished) {
 
 savedDataFile.setJSONArray("records", datas);
 saveJSONObject(savedDataFile, "data/gallica_"+typeIndex+"_"+types[typeIndex]+".json");
 
 int tmp = 0;
 for (Number i : mt.getSampleList()) {
 tmp += i.intValue();
 }
 int median =(int) median(mt.getSampleList());
 println("Record finished in "+getStringTime(tmp));
 println("\tMedian time for request: "+getStringTime(median));
 mt.computePanel();
 
 if (typeIndex < types.length-1) {
 typeIndex ++;
 startRecord=0;
 maximumRecords = 50;
 
 String request = globalQuery+type+separator+operator+separator+types[typeIndex]+and+collapsing;
 println("Orginal request: "+request);
 numberOfDocuments = getNumberOfDocument(request);
 savedDataFile.setInt("numberOfRecords", numberOfDocuments);
 } else {
 isFinished = true;
 }
 } else {
 mt.displayPanel(0, 60);
 }
 }
 }*/
