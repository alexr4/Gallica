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

function parseSource(element){
  if(element == undefined) return element
  let regexAccent = /\W+/;
  let source = element.toLowerCase(); //set source word as a full lower case sentence
  source = source.replace(/[0-9-,()/_.?;]/g,''); //remove number from text
  source = source.normalize('NFD').replace(/[\u0300-\u036f]/g, ""); //replace accent with non accentuated character
  //source = source.replace(/bibliotheque nationale de france/g, 'bnf');
  //let sourceArray = source.split(regexAccent); //replace whitespace at begining and end
  //source = sourceArray.join(" ");//join source

  let result = source;

  return result;
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
