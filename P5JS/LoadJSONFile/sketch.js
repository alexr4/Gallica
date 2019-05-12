var requestURL = '../../Gallica-Avril2019/Sorted/PerDate/videos_Per_date.json';
var datas = [];

function preload() {
  //We retreive the DATA as a JSON File using the HTTPS Request
  datas = loadJSON(requestURL);
}

function setup() {
  createCanvas(400, 400);
  let contributorsList = datas.Records;
  console.log(datas);
}

function draw() {
  background(220);
}
