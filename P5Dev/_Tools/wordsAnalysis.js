/**
the following method will help you to perform words wordsAnalysis
*/

function test(words){
  words = words.toLowerCase();
  var patt1 = /\s/g;
  var result = words.match(patt1);
  console.log(result)
}

function parseDate(date){
  if(checkUndefined(date)){
    return;
  }
  //step 1: set date as to toLowerCase
  date = date.toLowerCase();
  //step 2: check any lost character
  let firstletter = false;
  let start = 0;
  let index = 0;
  let numberRegex = /[0-9 -()+]+$/;
  let whiteSpaceRegex = /\s/g;
  let newdate = "";
  for(let i=0; i<date.length; i++){
    let char = date[i];
    //check if char is an number
    if(char.match(numberRegex) != null && char.match(whiteSpaceRegex) == null){
      //continue
      newdate += char;
      start = (index % 4 == 0) ? start = i : start = start;
      index ++;
      if(firstletter == false){ //define true for the first letter and save first index
        start = i;
        firstletter = true;
      }
    }else{
      if(firstletter == true){
        //count the number of letter in date
        if((i-start) < 4){
          newdate += 0;
        }
      }
    }
  }

  //step 3: if word has not enough char add it to the end
  let mod = newdate.length % 4.0;
  if(mod > 0){
    for(let i=0; i<mod; i++){
      newdate += 0;
    }
  }
  return newdate;
}

function convertToDate(date){
  if(checkUndefined(date)) return;
  return new Date(date);
}

function checkUndefined(words){
  return (words == undefined) ? true : false;
}


/**
This function will parse source data in order to simplify it
*/

function cleanText(element){
  if(element == undefined) return element
  let regexAccent = /\W+/;
  let source = element.toLowerCase(); //set source word as a full lower case sentence
  source = removeNumber(source); //remove number from text
  source = removePonctuation(source);
  source = replaceAccent(source);
  //source = source.replace(/bibliotheque nationale de france/g, 'bnf');
  //let sourceArray = source.split(regexAccent); //replace whitespace at begining and end
  //source = sourceArray.join(" ");//join source

  let result = source;

  return result;
}

function removePonctuation(element){
  return element = element.replace(/[-_.!?,;:'"()\[\]']/g,''); //remove number from text
}

function removeNumber(element){
  return element = element.replace(/[0-9]/g,''); //remove number from text
}

function replaceAccent(element){
  return element = element.normalize('NFD').replace(/[\u0300-\u036f]/g, ""); //replace accent with non accentuated character
}

function similarity(s1, s2) {
  var longer = s1;
  var shorter = s2;
  if (s1.length < s2.length) {
    longer = s2;
    shorter = s1;
  }
  var longerLength = longer.length;
  if (longerLength == 0) {
    return 1.0;
  }
  return (longerLength - editDistance(longer, shorter)) / parseFloat(longerLength);
}

function editDistance(s1, s2) {
  s1 = s1.toLowerCase();
  s2 = s2.toLowerCase();

  var costs = new Array();
  for (var i = 0; i <= s1.length; i++) {
    var lastValue = i;
    for (var j = 0; j <= s2.length; j++) {
      if (i == 0)
        costs[j] = j;
      else {
        if (j > 0) {
          var newValue = costs[j - 1];
          if (s1.charAt(i - 1) != s2.charAt(j - 1))
            newValue = Math.min(Math.min(newValue, lastValue),
              costs[j]) + 1;
          costs[j - 1] = lastValue;
          lastValue = newValue;
        }
      }
    }
    if (i > 0)
      costs[s2.length] = lastValue;
  }
  return costs[s2.length];
}

function sharedStart(array){
    var A= array.concat().sort(),
    a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;
    while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;
    return a1.substring(0, i);
}

function cleanAudioSource(value){
  value = checkNull(value);
  value = cleanAtlast(value, ',');
  return value = checkNull(value);
}

function cleanMapSource(value){
  value = checkNull(value);
  value = removeNumber(value);
  value = cleanAtlast(value, '(');
  value = cleanAtlast(value, '-');
  value = cleanAtlast(value, ',');
  return value = checkNull(value);
}

function cleanImageSource(value){
  value = checkNull(value);
  value = removeNumber(value);
  value = cleanAtlast(value, '(');
  value = cleanAtlast(value, '-');
  value = cleanAtlast(value, '/');
  value = cleanAtlast(value, '[');
  value = cleanAtlast(value, '.');
  value = cleanAtlast(value, ';');
  value = cleanAtlast(value, ',');
  return value = checkNull(value);
}

function cleanManuscriptsSource(value){
  value = checkNull(value);
  value = removeNumber(value);
  for(let i=0; i<3; i++)  value = cleanAtlast(value, ',');
  for(let i=0; i<3; i++)  value = cleanAtlast(value, '.');
  for(let i=0; i<3; i++)  value = cleanAtlast(value, '(');
  value = cleanAtlast(value, ',');
  return checkNull(value);
}

function cleanMonographySource(value){
  value = checkNull(value);
  value = removeNumber(value);
  for(let i=0; i<3; i++)  value = cleanAtlast(value, ',');
  for(let i=0; i<3; i++)  value = cleanAtlast(value, '(');
  for(let i=0; i<3; i++)  value = cleanAtlast(value, '.');
  for(let i=0; i<3; i++)  value = cleanAtlast(value, '-');
  return checkNull(value);
}

function cleanObjectSource(value){
  value = checkNull(value);
  value = removeNumber(value);
  for(let i=0; i<3; i++)  value = cleanAtlast(value, ',');
  for(let i=0; i<3; i++)  value = cleanAtlast(value, '.');
  for(let i=0; i<3; i++)  value = cleanAtlast(value, '(');
  return checkNull(value);
}

function cleanPartitionSource(value){
    value = checkNull(value);
    value = removeNumber(value);
    for(let i=0; i<3; i++)  value = cleanAtlast(value, ',');
    for(let i=0; i<3; i++)  value = cleanAtlast(value, '.');
    for(let i=0; i<3; i++)  value = cleanAtlast(value, '(');
    return checkNull(value);
}

function cleanVideoSource(value){
    value = checkNull(value);
    value = removeNumber(value);
    for(let i=0; i<3; i++)  value = cleanAtlast(value, ',');
    return checkNull(value);
}


function cleanPeriodiqueSource(value){
    value = checkNull(value);
    value = removeNumber(value);
    for(let i=0; i<3; i++)  value = cleanAtlast(value, ',');
    for(let i=0; i<3; i++)  value = cleanAtlast(value, '.');
    for(let i=0; i<3; i++)  value = cleanAtlast(value, '(');
    return checkNull(value);
}


function cleanLastIterationAt(value, char, iterations){
  value = checkNull(value);
  value = removeNumber(value);
  for(let i=0; i<iterations; i++)  value = cleanAtlast(value, char);
  return checkNull(value);
}

function cleanFirstIterationAt(value, char, iterations){
  value = checkNull(value);
  value = removeNumber(value);
  for(let i=0; i<iterations; i++)  value = cleanAtFirst(value, char);
  return checkNull(value);
}

function cleanAtlast(value, char){
    lastIndex = value.lastIndexOf(char)
    return (lastIndex > -1 && value.split(char).length > 1) ? value.substring(0, lastIndex) : value;
}

function cleanAtFirst(value, char){
  index = value.indexOf(char)
  return (index > -1 && index < 1 && value.split(char).length > 1) ? value.substring(0, index) : value;
}

function checkNull(value){
  return  (value == "undefined" || value === " " || value.length <= 0 || value === "") ? "undefined" : value;
}

function removePlural(value){
  lastIndex = value.lastIndexOf('s')
  return (lastIndex > -1 && lastIndex == value.length-1) ? value.substring(0, lastIndex) : value;
}

function isWordInside(value, wordToCompare){
  let tmp = checkNull(value);
  tmp = tmp.toLowerCase();
  tmp = replaceAccent(tmp);

  let tmpToCompare = checkNull(wordToCompare);
  tmpToCompare = tmpToCompare.toLowerCase();
  tmpToCompare = removePlural(tmpToCompare);
  tmpToCompare = replaceAccent(tmpToCompare);

  return (tmp.indexOf(tmpToCompare) != -1) ? true : false;

}
