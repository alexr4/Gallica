//original data
var requestURL = '../../Datas/gallica_monographies.json';
var datas;
var records;


//saved sorted data here
var UISave;
var exportRecords = [];
var dictionary = [];

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
    let value = records[i].contributor;

    let src = parseSource(value);
    if(src != undefined){
      src = src.replace(/participant/g, "");
    }
    //dictionary.push(src);
    //let subValue = records[i].date;
    //subValue = parseDate(subValue);
    //count2DPer(value, subValue, dictionary);
    //count2DPer(src, value, dictionary)
    countPer(src, dictionary)
    //count2DPer(value, src, dictionary)
  }

  console.log("JSON to dictionnary: ", dictionary);
  let size = sizeOf(dictionary);
  /*for(key in dictionary){
    console.log(key);

  }*/
  /*
  let arrayKey = Object.keys(dictionary);
  arrayKey = arrayKey.sort();
  console.log("array has been sorted");
  let sources = {}
  for(let i=1; i<arrayKey.length-1; i++){
    let value = arrayKey[i];
    for(let j=0; j<arrayKey.length;j++){
      if(j != i){
        let other =  arrayKey[j];
        let ratio =  similarity(value, other);
        if(ratio > 0.5){
          let valArray = [value, other];
          let key = sharedStart(valArray);
          let data = Number(dictionary[value]) + Number(dictionary[other]);
          //console.log(ratio, key, value, other)
          if(sources[key] != undefined){
            sources[key] += data;
          }else{
            sources[key] = data;
          }
          break;
        }
      }
    }
  }
//  console.log(sources);
  for(key in sources){
    console.log(key, sources[key]);
  }
  console.log("array has been sorted by name");
/*
  let dateDictionary = {};
  for(key in dictionary){
    let date = convertToDate(key);
    dateDictionary[date] = dictionary[key];
  }
  console.log(dateDictionary);

  let newdictionary = sorted2DDictionary(dictionary)
  console.log("Sort dictionnary: ", newdictionary);
*/
 exportRecords = convertDictionaryIntoJSONArray(dictionary);
  console.log("Dictionary to JSON ready to export: ");
}


function savedJSON(){
  console.log("save data");
  let json = {};
  json.records = exportRecords;
  saveJSON(json, 'sortedData.json');
}
