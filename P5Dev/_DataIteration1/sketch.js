var url = "sortedData.json";
var datas;

function preload(){
  datas = loadJSON(url);
  console.log(datas);
}

function setup(){
  createCanvas(windowWidth, windowHeight, SVG);
}

function draw(){
  background(0);

  let namePerCentury = datas.records[1];
  let year = namePerCentury.key;
  let nameJSONOBject = namePerCentury.value;
  let nameArray = Object.keys(nameJSONOBject);

  let max = 70;
  let min = 1;
  let innerRadius = 200;
  let lenMax = 200;
  let res = 25;
  colorMode(HSB, 1, 1, 1)



  for(let i=0; i<nameArray.length; i++){
    let name = nameArray[i];
    let value = nameJSONOBject[name];

    let angle = map(i, 0, nameArray.length, 0, TWO_PI);
    let len = map(value, 0, 100, 0, lenMax);
    let lenH = map(value, 0, 100, res * .1, res);
    let hue = value / 100;
    let px = cos(angle) * innerRadius + width/2;
    let py = sin(angle) * innerRadius + height/2;

    push();
    translate(width/2, height/2);
    rotate(angle);
    noStroke();
    fill(hue, 1, 1);
    rect(innerRadius, lenH * -0.5, len, lenH);
    pop();

    push();
    translate(px, py);
    rotate(angle);
    fill(0, 0, 1);
    noStroke();
    textAlign(RIGHT, CENTER)
    textSize(6)
    text(name, -10, 0)
    pop();

  }



  let frame = nf(frameCount, 5);
  //save("datavis_"+frame+".svg");
  //noLoop();
}
