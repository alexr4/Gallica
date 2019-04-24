import fpstracker.core.*;
import fpstracker.ui.*;
import java.util.*;
import java.text.SimpleDateFormat;

PerfTracker ptt;
MillisTracker mt;

int typeIndex=13;
boolean isFinished;

XML xml;
String resumptionToken;
String[] resumptionTokenSplits;
int cursor = 0;
int maximumRecords = 100;

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
  XML[] children = xml.getChild("ListRecords").getChildren("record");

  for (int i = 0; i < children.length; i++) {
    addData(children[i]);
  }

  /* resumptionToken = getNextResumptionToken(xml);
   cursor = 0;
   println(resumptionToken, cursor);
   
   resumptionTokenSplits = split(resumptionToken, '!');
   */

  savedDataFile.setJSONArray("records", datas);

  ptt = new PerfTracker(this, 100);
  mt = new MillisTracker(this, 100);

  frameRate(300);
}

void draw() {
  background(240);
  /* test token
   int start = millis();
   cursor += 100;
   //String request = "http://oai.bnf.fr/oai2/OAIHandler?resumptionToken="+resumptionToken+"&verb=ListRecords";
   resumptionToken = defineNextResumptionToken(resumptionTokenSplits, cursor);
   String request = "http://oai.bnf.fr/oai2/OAIHandler?resumptionToken="+resumptionToken+"&verb=ListRecords";
   xml = loadXML(request);
   //resumptionToken = getNextResumptionToken(xml);
   int end = millis() - start;
   println(end, resumptionToken, cursor, request);
   */
  iterateOverRecords();

  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  textSize(24);
  text("Time passed: "+getStringTime(millis()), width/2, height/2);

  ptt.display(0, 0);
}

void iterateOverRecords() {
  if (cursor < numberOfDocuments) {
    try {
      resumptionToken = getNextResumptionToken(xml);
      if (!resumptionToken.equals("")) { 



        String request = "http://oai.bnf.fr/oai2/OAIHandler?resumptionToken="+resumptionToken+"&verb=ListRecords";
        println(((float)cursor/(float)numberOfDocuments) * 100, request, resumptionToken);
        xml = loadXML(request);
        cursor += maximumRecords;
        //println(cursor, maximumRecords);

        XML[] children = xml.getChild("ListRecords").getChildren("record");

        for (int i = 0; i < children.length; i++) {
          addData(children[i]);
        }

        saveJSONObject(savedDataFile, "data/gallica_"+typeIndex+"_"+types[typeIndex]+".json");
        mt.addSample();
      } else {
        cursor = numberOfDocuments;
      }
    }
    catch(Exception e) {
      println("error has been catch. Retry ");
    }
  } else {
    if (!isFinished) {

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
        cursor=0;
        maximumRecords = 100;

        String request = globalQuery+types[typeIndex];
        println(request);
        xml = loadXML(request);
        println("Orginal request: "+request);
        numberOfDocuments = getNumberOfDocument(xml);

        //savedDataFile.setInt("numberOfRecords", numberOfDocuments);
      } else {
        isFinished = true;
      }
    } else {
      mt.displayPanel(0, 60);
    }
  }
}
