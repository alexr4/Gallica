/**
The two following methods will convert 1D and 1D dictionnary into JSON
Each JSON object are based the same structure
object.key : key used for sorting
object.value : value or array associtae to the key
*/

function convert2DDictionaryIntoJSONArray(dict){
  let jsa = [];
  for(let key in dict) {
    let value = dict[key];

    let subjsa = [];
    for(let subkey in value) {
      let subvalue = value[subkey];
      let subjso = {};
      subjso.key = subkey;
      subjso.value = subvalue;
      subjsa.push(subjso);
    }

    let jso = {};
    jso.key = key;
    jso.value = subjsa;
    jsa.push(jso);
  }
  return jsa;
}

function convertDictionaryIntoJSONArray(dict){
  let jsa = [];
  for(let key in dict) {
    let value = dict[key];
    let jso = {};
    jso.key = key;
    jso.value = value;
    jsa.push(jso);
  }
  return jsa;
}

/**
The following methods will count the repeated value from a data set
The first will count only the repeated value on data (number of element per date for exemple)
the second will count repeated value on twow data (number of differents authors per date)
*/
function countPer(key, output){
  //add firt item to dictionnary
  if(output == undefined){
    addCount(key, output);
  }else{
    if(output[key] != undefined){
      output[key] += 1;
    }else{
    addCount(key, output);
    }
  }
}

function count2DPer(key, subkey, output){
  //add firt item to dictionnary
  if(output == undefined){
    add2DCount(key, subkey, output);
  }else{
    if(output[key] != undefined){
      countPer(subkey, output[key]);
    }else{
      add2DCount(key, subkey, output);
    }
  }
}

function addCount(key, output){
    output[key] = 1;
}

function add2DCount(key, subkey, output){
  let array = {};
  output[key] = array;
  countPer(subkey, output[key]);
}

/**
The following methods will return sorted array or dictionnary
*/
function sorted1DDictionary(dictionary){
  // Create items array
  var items = Object.keys(dictionary).map(function(key) {
    return [key, dictionary[key]];
  });

  // Sort the array based on the second element
  items.sort(function(first, second) {
    return second[1] - first[1];
  });

  return items
}

function sorted2DDictionary(dictionary){
  let newdictionary = {};
  for(key in dictionary){
    let subdictionary = dictionary[key];
    var items = sorted1DDictionary(subdictionary);
    newdictionary[key] = items;
  }
  return newdictionary;
}

/**
the following methods ar simple helper or getter for dictionary
*/
function sizeOf(dictionary){
  return Object.keys(dictionary).length
}
