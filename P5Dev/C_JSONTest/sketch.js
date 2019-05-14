var url = "../../Datas/gallica_audio.json";
var datas;

function preload(){
  datas = loadJSON(url);
  console.log(datas)
}

function setup(){
  let nbDocs = datas.numberOfRecords;

  for(let i=0; i<datas.records.length; i++){
    let date = datas.records[i].date;
    console.log(date);
  }
}

function draw(){
}
