//original data
var types = ["cartes", "dessins", "estampes", "objets", "photographies"];
var requestURL = '../../../Datas/gallica_images';
var records = [];

//saved sorted data here
var UISave;
var exportRecords = [];
var dictionary = [];
var minValue = 0;
var maxValue = 0;
var minDate = 0;
var maxDate = 0;

function preload() {
  //We retreive the DATA as a JSON File using the HTTPS Request
  for(let i=0; i<types.length; i++){
    let type = types[i];
    let url = requestURL+type+".json";
    let json = loadJSON(url);
    records.push(json);
  }
  console.log(records);
}

function setup() {
  UISave = createButton('saved new JSON');
  UISave.mouseReleased(savedJSON);

  let count = 0;
  let chunk = 1000;

  let max = 0;
  for(let i=0; i<records.length; i++){
    max += records[i].records.length;
  }
  console.log("Maximum datas : "+max)

  let tmpDict = []
  for(let i=0; i<records.length; i++){
    let type = types[i];
    let datas = records[i].records;
    if(datas != undefined){
      for(let j=0; j<datas.length; j++){
        let data = datas[j];
        let date = (data.date != undefined) ? data.date : "undefined";
        date = parseDate(date);
        if(date.length > 4){
          date = date.substring(0, 4);
        }
        date = date.substring(0, 2);
        date += "00";
        date = Number(date);
        if(date > 500 && date < 2019){
          countPer(date, tmpDict);
          count2DPer(type, date, dictionary);
        }
        //process
        if(j%chunk == 0){
          count += chunk
          console.log("process..."+round((count/max)*100)+"%");
        };
      }
    }else{
      count2DPer(type, "undefined", dictionary);
    }
  }
  tmpDict = sorted1DDictionary(tmpDict);
  maxValue = tmpDict[0][1];
  minValue = tmpDict[tmpDict.length-1][1];
  maxDate = Number(tmpDict[0][0]);
  minDate = Number(tmpDict[tmpDict.length-1][0]);
  console.log(minValue, maxValue, dictionary);


  exportRecords = convertDictionaryIntoJSONArray(dictionary);
  console.log("Dictionary to JSON ready to export");
}


function savedJSON(){
  console.log("save data");
  let json = {};
  json.records = exportRecords;
  console.log(minValue, maxValue)
  json.maxValue = maxValue;
  json.minValue = minValue;
  json.minDate = minDate;
  json.maxDate = maxDate;
  console.log(json);
  saveJSON(json, 'sortedData.json');
}
