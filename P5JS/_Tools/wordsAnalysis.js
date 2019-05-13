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
