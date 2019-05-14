//original data
var requestURL = '../../Datas/gallica_monographies.json';
var datas;
var records;


//saved sorted data here
var UISave;
var exportRecords = [];
var dictionary = {};

function preload() {
  //We retreive the DATA as a JSON File using the HTTPS Request
  datas = loadJSON(requestURL);
}

function setup() {
  records = datas.records;
  console.log("based JSON data ", records);

  UISave = createButton('saved new JSON');
  UISave.mouseReleased(savedJSON);

  for(let i=0; i<records.length; i++){
    let value = records[i].date;
    let subValue = records[i].source;
    value = parseDate(value);
    count2DPer(value, subValue, dictionary);
  }

  console.log("JSON to dictionnary: ", dictionary);
  let size = sizeOf(dictionary);

  /*let newdictionary = sorted2DDictionary(dictionary)
  console.log("Sort dictionnary: ", newdictionary);*/

  exportRecords = convert2DDictionaryIntoJSONArray(dictionary);
  console.log("Dictionary to JSON ready to export: ", exportRecords);
}


function savedJSON(){
  console.log("save data");
  let json = {};
  json.records = exportRecords;
  saveJSON(json, 'sortedData.json');
}
