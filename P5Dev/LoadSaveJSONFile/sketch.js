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
    let value = (records[i].contributor != undefined) ? records[i].contributor : "undefined";

    //The following lines help to clean publisher - this fonction has been test with all dataset
    //value = cleanAudioSource(value);
    //value = cleanMapSource(value);
    //value = cleanImageSource(value);
    //value = cleanManuscriptsSource(value);
    //value = cleanObjectSource(value);
    //value = cleanPartitionSource(value);
    //value = cleanVideoSource(value);

    //The following lines help to clean publisher
    // value = removePonctuation(value); //remove all ponctuation () [] ...
    // value = replaceAccent(value); //replace all accent by simple letter (some name has been written without their accents)
    // value = cleanLastIterationAt(value, ',', 1); //remove elements after the last , in order to remove sub-sub-department
    // value = cleanFirstIterationAt(value, ' ', 3); //remove ' ' at begining of the name

    //The following lines help to clean contributors
    //value = (value === "undefined") ? value : "authors"; //test how many author are known
    value = cleanLastIterationAt(value, '(', 3); //remove all elements after the last ( which can be birthdate, job, place...
    value = cleanLastIterationAt(value, '.', 3); //remove all elements after the last . which can be birthdate, job, place...
    value = cleanLastIterationAt(value, '\ʿ', 3); //remove ʿ at the begining of an arabic names
    value = cleanFirstIterationAt(value, '\ʿ', 3);//remove ʿ at the end of an arabic names
    value = cleanFirstIterationAt(value, ' ', 3);//remove ' ' at begining of the name
    value = value.replace(',', ""); //remove remaining , betwen surename and name

    //the following lines help to perform word computation
     let title = (records[i].title != undefined) ? records[i].title : "undefined";
     let wordToFine = "Femmes";
     let isWordInsideTitle = isWordInside(title, wordToFine);
     if(isWordInsideTitle == true){
       //console.log(value, title)
       //if a book has the word "woman" (plural or singular) we add its author the list
      countPer(value, dictionary)
    }
  }

  for(key in dictionary){
    let value = dictionary[key]
    console.log(key, value);
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
