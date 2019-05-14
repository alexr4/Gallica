var url = "../../Datas/gallica_audio.json";
var datas;
var records;

function preload(){
  datas = loadJSON(url);
  console.log(datas)
}

function setup(){
  records = datas.records;

  let dictionary = {};
  let dictionary2D = {};

  for(let i=0; i<records.length; i++){
    let value = records[i].date;
    let subvalue = records[i].datestamp;
    value = parseDate(value);
    //value = convertToDate(value);
    countPer(value, dictionary);
    count2DPer(value, subvalue, dictionary2D);
  }

  let size = sizeOf(dictionary);
  console.log(size);
  console.log(dictionary);

  let array2D = convert2DDictionaryIntoJSONArray(dictionary2D);
  let json = {};
  json.records = array2D;
  saveJSON(json, "export2D.json");


  let array = convertDictionaryIntoJSONArray(dictionary);
  json = {};
  json.records = array;
  saveJSON(json, "export.json");
}

function draw(){
}
