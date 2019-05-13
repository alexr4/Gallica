//original data
var requestURL = '../../Gallica-Avril2019/AllData/gallica_monographies.json';
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
    let value = records[i].datestamp;
    let subValue = records[i].date;
    subValue = parseDate(subValue);
    count2DPer(value, subValue, dictionary);
  }

  console.log("JSON to dictionnary: ", dictionary);
  let size = sizeOf(dictionary);

  let dateDictionary = {};
  for(key in dictionary){
    let date = convertToDate(key);
    dateDictionary[date] = dictionary[key];
  }
  console.log(dateDictionary);

  let newdictionary = sorted2DDictionary(dictionary)
  console.log("Sort dictionnary: ", newdictionary);

  exportRecords = convert2DDictionaryIntoJSONArray(dictionary);
  console.log("Dictionary to JSON ready to export: ", newdictionary);
}


function savedJSON(){
  console.log("save data");
  let json = {};
  json.records = exportRecords;
  saveJSON(json, 'sortedData.json');
}
