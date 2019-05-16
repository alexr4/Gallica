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

  let dateMin = 1600;
  let dateMax = 1700;
  let count = 0;
  let chunk = 10000;
  for(let i=0; i<records.length; i++){
    let value = (records[i].contributor != undefined) ? records[i].contributor : "undefined";
    let date = (records[i].date != undefined) ? records[i].date : "undefined";
    date = parseDate(date);
    if(date.length > 4){
      date = date.substring(0, 4);
    }
    date = date.substring(0, 2);
    date += "00";
    date = Number(date);

    if(date >= dateMin && date <= dateMax){
      //The following lines help to clean contributors
      //value = (value === "undefined") ? value : "authors"; //test how many author are known
      value = cleanLastIterationAt(value, '(', 3); //remove all elements after the last ( which can be birthdate, job, place...
      value = cleanLastIterationAt(value, '.', 3); //remove all elements after the last . which can be birthdate, job, place...
      value = cleanLastIterationAt(value, '\ʿ', 3); //remove ʿ at the begining of an arabic names
      value = cleanFirstIterationAt(value, '\ʿ', 3);//remove ʿ at the end of an arabic names
      value = cleanFirstIterationAt(value, ' ', 3);//remove ' ' at begining of the name
      value = value.replace(',', ""); //remove remaining , betwen surename and name
      if(value.indexOf("Madame") > -1 || value.indexOf("Monsier") > -1 || value.split(" ").length < 2){
        value = "undefined";
      }

      //find a match inside known names
      for(let j=0; j<famousMan.length; j++){
        let nameToTest = famousMan[j];
        let normalizeTest = nameToTest.toLowerCase();
        let normalizeName = value.toLowerCase();
        let ressemblanceRatio = similarity(normalizeTest, normalizeName);
        if(ressemblanceRatio > 0.5){
          //console.log(ressemblanceRatio, normalizeTest, normalizeName)
          count2DPer(date, nameToTest, dictionary);
          break;
        }
      }
    }
    if(i%chunk == 0){
      count += chunk
      console.log("process..."+((count/records.length)*100)+"%");
    }
  }

  //console.log(sorted1DDictionary(dictionary));

  for(key in dictionary){
    let subdict = dictionary[key]
    console.log(key);
    for(subkey in subdict){
      console.log("\t", subkey, subdict[subkey])
    }
  }

  console.log("array has been sorted");
  exportRecords = convertDictionaryIntoJSONArray(dictionary);
  console.log("Dictionary to JSON ready to export: ");
}


function savedJSON(){
  console.log("save data");
  let json = {};
  json.records = exportRecords;
  saveJSON(json, 'sortedData.json');
}
