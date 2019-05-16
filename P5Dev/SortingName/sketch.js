var url = "sortedMan.json";
var datas;
var records;

var uniqueNames = {};

function preload(){
  datas = loadJSON(url);
  console.log(datas);
}

function setup(){
  createCanvas(windowWidth, windowHeight, SVG);

  records = datas.records;
  for(let i = 0; i<records.length; i++){
    let namePerCentury = records[i];
    let year = namePerCentury.key;
    let nameJSONOBject = namePerCentury.value;
    let nameArray = Object.keys(nameJSONOBject);
    for(let j=0; j<nameArray.length; j++){
      let name = nameArray[j];
      countPer(name, uniqueNames)
    }
  }
  uniqueNames = Object.keys(uniqueNames);
  uniqueNames.sort();



 console.log(uniqueNames)
}

function draw(){
  background(0);
  colorMode(HSB, 1, 1, 1)
  let ox = width/2;
  let oy = height/2;
  let minRad = 25;
  let maxRad = 800;
  let maxAngle = PI + HALF_PI;
  let ratioAngle = maxAngle/records.length;
  noFill();
  stroke(255);
  for(let j=0; j<uniqueNames.length; j++){
    let name = uniqueNames[j];

      let start = 0;
    for(let i = 0; i<records.length; i++){
      let namePerCentury = records[i];
      let year = namePerCentury.key;
      let nameJSONOBject = namePerCentury.value;
      let nameArray = Object.keys(nameJSONOBject);
      let value = nameJSONOBject[name];
      if(value != undefined){
       console.log(name, year, value)
       let diameter = map(j, 0, uniqueNames.length, minRad, maxRad);
       let normYear = i/records.length;
       let end = start + map(value, 0, 100, 0, ratioAngle);
       stroke(normYear * 0.25, 1, 1)
       arc(ox, oy, diameter, diameter, start, end)
       start = end;
     }
    }
  }

  noLoop();
  //
  // let max = 70;
  // let min = 1;
  // let innerRadius = 200;
  // let lenMax = 200;
  // let res = 25;
  // colorMode(HSB, 1, 1, 1)
  //
  //
  //
  // for(let i=0; i<nameArray.length; i++){
  //   let name = nameArray[i];
  //   let value = nameJSONOBject[name];
  //
  //   let angle = map(i, 0, nameArray.length, 0, TWO_PI);
  //   let len = map(value, 0, 100, 0, lenMax);
  //   let lenH = map(value, 0, 100, res * .1, res);
  //   let hue = value / 100;
  //   let px = cos(angle) * innerRadius + width/2;
  //   let py = sin(angle) * innerRadius + height/2;
  //
  //   push();
  //   translate(width/2, height/2);
  //   rotate(angle);
  //   noStroke();
  //   fill(hue, 1, 1);
  //   rect(innerRadius, lenH * -0.5, len, lenH);
  //   pop();
  //
  //   push();
  //   translate(px, py);
  //   rotate(angle);
  //   fill(0, 0, 1);
  //   noStroke();
  //   textAlign(RIGHT, CENTER)
  //   textSize(6)
  //   text(name, -10, 0)
  //   pop();
  //
  // }
  //
  //
  //
  // let frame = nf(frameCount, 5);
  //save("datavis_"+frame+".svg");
  //noLoop();
}
