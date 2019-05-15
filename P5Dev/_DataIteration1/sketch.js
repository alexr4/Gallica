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
  let outerRadius = 400;
  for(let i=0; i<nameArray.length; i++){
    let name = nameArray[i];
    let value = nameJSONOBject[name];

    let angle = map(i, 0, nameArray.length, 0, TWO_PI);
    let len = map(value, 0, 70, innerRadius, outerRadius);
    let px = cos(angle) * innerRadius + width/2;
    let py = sin(angle) * innerRadius + height/2;

    push();
    translate(width/2, height/2);
    rotate(angle);
    stroke(255);
    line(innerRadius, 0, len, 0);
    pop();

    push();
    translate(px, py);
    rotate(angle);
    fill(255);
    textAlign(RIGHT, CENTER)
    textSize(6)
    text(name, -10, 0)
    pop();

  }

  save("hello.svg");
  noLoop();
}
