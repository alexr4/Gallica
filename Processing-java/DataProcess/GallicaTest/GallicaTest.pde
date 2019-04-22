import http.requests.*;
PImage img;

void settings() {
  String request = "https://gallica.bnf.fr/services/Pagination?ark=bpt6k9686111g";
  GetRequest get = new GetRequest(request);
  get.send();
  println("Reponse Content-Length Header: " + get.getHeader("Content-Length"));
  println("Reponse Content: " + get.getContent());

  XML xml = loadXML(request);
  XML[] structures = xml.getChildren("structure");
  XML[] vues = structures[0].getChildren("nbVueImages");
  String vue = vues[0].getContent();

  int randValue = 3;//floor(random(0, int(vue)));
  println(randValue);

  img = loadImage("https://gallica.bnf.fr/ark:/12148/bpt6k9686111g/f"+randValue+".image/highres", "jpg");
  println(img.width, img.height);
  float res = (float) img.width / (float) img.height;
  int h= 900;
  int w = round(h*res);
  size(w, h);
}

public void setup() 
{
  smooth();

  String request = "https://gallica.bnf.fr/services/ContentSearch?ark=bpt6k9686111g&query=ordinateur&page=3";
  XML xml = loadXML(request);
  XML data = xml.getChild("items").getChild("item");

  float masterWidth = float(data.getChild("p_width").getContent());
  float masterHeight = float(data.getChild("p_height").getContent());
  float posX = float(data.getChild("altoid").getChild("altoidstring").getInt("hpos"));
  float posY = float(data.getChild("altoid").getChild("altoidstring").getInt("vpos"));
  float wordW = float(data.getChild("altoid").getChild("altoidstring").getInt("width"));
  float wordH = float(data.getChild("altoid").getChild("altoidstring").getInt("height"));
  
  

  float nx = posX/masterWidth;
  float ny = posY/masterHeight; 
  float nw = wordW/masterWidth; 
  float nh = wordH/masterHeight;

  image(img, 0, 0, width, height);
  fill(255, 255, 0, 100);
  noStroke();
  rect(nx * width, ny * height - 15, nw * width, nh * height); 
  
  ///exemple: https://gallica.bnf.fr/SRU?version=1.2&operation=searchRetrieve&query=dc.creator%20all%20%22Charles%20Joseph%20Minard&filter=dc.type%20all%20%22carte%22&filter=dewey%20all%203
}
