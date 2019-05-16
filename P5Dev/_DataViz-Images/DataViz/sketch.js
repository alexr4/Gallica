var url = "sortedData.json";
var datas;
var records;
var minValue;
var maxValue;
var minDate;
var maxDate;
var startTime;

function preload(){
  datas = loadJSON(url);
  console.log(datas);
}

function setup(){
  createCanvas(windowWidth, windowHeight);//, SVG);

   records = datas.records;
   minValue = datas.minValue;
   maxValue = datas.maxValue;
   minDate = datas.minDate;
   maxDate = datas.maxDate;
   console.log(minDate, maxDate, minValue, maxValue, records);
   startTime = millis();
}

function draw(){

  //colorMode(HSB, 360, 100, 100)
  background(200);
  let normMouse = mouseX / width;

  let titre = "Nombre d'image par type\net par année présentes\nsur Gallica";
  titre = titre.toUpperCase();
  fill(50);
  noStroke();
  textAlign(LEFT, TOP);
  textStyle(BOLD);
  textSize(18);
  text(titre, 20, 20)

  let maxTime = 1250.0;
  let time = (millis() - startTime) / maxTime;
  let anim = (time > 1.0) ? 1.0 : time;
  let easedTime = outCubic(anim);

  let ox = width/2;
  let oy = height/2;
  let minRad = 200;
  let maxRad = 600;
  let heightArc = maxRad / records.length;
  let maxAngle = TWO_PI;
  let centuries = (maxDate - minDate) / 100
  let ratioAngle = (maxAngle/centuries)
  let baseHue = 260;
  let endHue = 360;
  let gridHeight = 0.2;
  let alpha = 50;
  let grey = 20;

  strokeCap(SQUARE)
  rectMode(CENTER)
  noFill();
  stroke(180)
  ellipse(ox, oy, maxRad * 1.2, maxRad * 1.2)
  ellipse(ox, oy, minRad * 0.5, minRad * 0.5)
  textSize(12);
  for(let i=0; i<records.length; i++){
    let century = records[i].key;
    let datas = records[i].value;
    let radius = map(i, 0, records.length-1, minRad, maxRad);
    let start = 0;
    let yearArray = Object.keys(datas);

    let pbx = cos(-HALF_PI) * (radius * 0.5 - heightArc * gridHeight) + ox;
    let pby = sin(-HALF_PI) * (radius * 0.5 - heightArc * gridHeight) + oy;

    let pex = cos(-HALF_PI) * (radius * 0.5 + heightArc * gridHeight) + ox;
    let pey = sin(-HALF_PI) * (radius * 0.5 + heightArc * gridHeight) + oy;

    strokeWeight(1.0)
    stroke(grey, alpha);
    line(pbx, pby, pex, pey)

    let px = cos(-HALF_PI) * (radius * 0.5) + ox;
    let py = sin(-HALF_PI) * (radius * 0.5) + oy;
    century = century.toUpperCase();
    fill(50);
    noStroke();
    textAlign(RIGHT, CENTER);
    textStyle(BOLD);
    text(century, px - 10, py)

    for(let j=0; j<yearArray.length; j++){
      let normj = 1.0 - ((j / yearArray.length) * 0.5 + 0.5);
      let year = yearArray[j];
      let numberOfElement = datas[year];
      let normValue = map(numberOfElement, minValue, maxValue, 0.0, 1.0);
      normValue = outExp(normValue);
      let end = start + (map(normValue, 0, 1.0, PI * 0.1, ratioAngle * 2.5)) * easedTime;
      let offset = end - start;
      //console.log(numberOfElement, offset)
      let hue = map(Number(year), minDate, maxDate, baseHue, endHue);
      //hue = map(hue, 0, 1, baseHue, endHue) % 360;
      let bright = map(Number(year), minDate, maxDate, 45, 65);
      bright = lerp(100, bright, easedTime);
      //console.log(year, numberOfElement, hue);
      let sat = 100 * easedTime;
      let rgb = hsluv.hsluvToRgb([hue, 100, bright]);

      pbx = cos(end - HALF_PI) * (radius * 0.5 - heightArc * gridHeight) + ox;
      pby = sin(end - HALF_PI) * (radius * 0.5 - heightArc * gridHeight) + oy;

      pex = cos(end - HALF_PI) * (radius * 0.5 + heightArc * gridHeight) + ox;
      pey = sin(end - HALF_PI) * (radius * 0.5 + heightArc * gridHeight) + oy;

      let ptx = cos(start + offset * 0.5 - HALF_PI) * (radius * 0.5) + ox;
      let pty = sin(start + offset * 0.5 - HALF_PI) * (radius * 0.5) + oy;

      noFill();
      stroke(rgb[0] * 255, rgb[1] * 255, rgb[2] * 255);
      strokeWeight(heightArc * 0.25)
      arc(ox, oy, radius, radius, start - HALF_PI, end - HALF_PI);

      strokeWeight(1.0)
      stroke(grey, alpha);
      line(pbx, pby, pex, pey)

      noStroke();
      textStyle(BOLD);
      fill(grey, alpha * 1.75);
      textAlign(CENTER, CENTER);
      push();
      translate(ptx, pty)
      rotate(start + offset * 0.5)
      text(year, 0, -(heightArc * gridHeight))
      text(numberOfElement, 0, 0);
      pop();

      start = end;
    }
  }




  // let frame = nf(frameCount, 5);
  //save("datavis_"+frame+".svg");
  //noLoop();
}
