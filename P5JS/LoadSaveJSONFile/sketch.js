//original data
var requestURL = '../../Gallica-Avril2019/AllData/gallica_audio.json';
var datas;
var records;

//sorting variable
var iteration = 0;
var chunk = 1000;

//saved sorted data here
var UISave;
var json = {};
var sorting = [];
var newrecords = [];

function preload() {
  //We retreive the DATA as a JSON File using the HTTPS Request
  datas = loadJSON(requestURL);
}

function setup() {
  createCanvas(400, 400);
  records = datas.records;
  console.log(records);

  UISave = createButton('saved new JSON');
  UISave.mouseReleased(savedJSON);
}

function draw() {
  background(220);

  if(iteration < records.length){
    for(let i=iteration; i<iteration+chunk; i++){
      if(i < records.length){
        let record = records[i];
        searchAndAdd(record);
      }
      //console.log(datestamp);
    }

    iteration += chunk;
    text(iteration+"/"+records.length, 20, 20);
  }else{
    console.log(iteration+"/"+records.length+" : datas as been processed");
    noLoop();
  }
}

function savedJSON(){
  console.log("save data");
  json.records = newrecords;
  saveJSON(json, 'sortedData.json');
}

function searchAndAdd(element, array){
  if(newrecords.length > 0){
    for(let j=0; j<newrecords.length; j++){
      if(newrecords[j].datestamp != undefined){
        if(newrecords[j].datestamp === element.datestamp){
          //if the element has the same value as an another, we increment the number of elements
          newrecords[j].numberOfElement = newrecords[j].numberOfElement + 1;
        }else{
          //if not we add the new elements
            addNewElement(element);
            console.log(element.datestamp);
            break;
        }
      }
    }
  }else{
    addNewElement(element);
  }


}

function addNewElement(element){
  let newelement = {};
  newelement.datestamp = element.datestamp;
  newelement.numberOfElement = 1;
  newrecords.push(newelement);
  //console.log("add new element")
}
