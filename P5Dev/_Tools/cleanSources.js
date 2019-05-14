/**
this file has som helpful function to clean source data from the gallica Datas
*/

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
