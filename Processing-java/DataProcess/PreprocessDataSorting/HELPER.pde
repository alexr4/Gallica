public static double median (List<Number> a) {
  if (a != null && a.size() > 0) {
    int middle = a.size()/2;

    if (a.size() % 2 == 1) {
      return a.get(middle).intValue();
    } else {
      return (a.get(middle-1).intValue() + a.get(middle).intValue()) / 2.0;
    }
  }else{
    return 0;
  }
}


String getStringTime(int millis) {
  Date date = new Date(millis);
  // formattter
  SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss.SSS");
  formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
  // Pass date object
  return formatter.format(date);
}


String returnAsSimpleDate(String value) {
  char[] charlist = value.toCharArray();
  String date = "";
  for (int i=0; i<charlist.length; i++) {
    char character = charlist[i];
    if (Character.isDigit(character)) {
      date += character;
    }
  }

  //return century as year
  if (date.length() < 4) {
    int toAdd = 4 -  date.length();
    for (int j=0; j<toAdd; j++) {
      date += 0;
    }
  }

  //return as first date if more than 4 char
  if (date.length() > 4) {
    date = date.substring(0, 4);
  }
  return date;
}



public static float diff(String str1, String str2) {
  String[] str1Array = str1.split("");
  String[] str2Array = str2.split("");

  float max = (str1.length() > str2.length()) ? str2.length() : str1.length();
  float count = 0;
  for (int i=0; i<max; i++) {
    if (str1Array[i].equals(str2Array[i])) {
      count ++;
    }
  }
  count /= (float)max;
  /*String value = str1;
   if (count > 0.8) {
   value = (str1.length() > str2.length()) ? str1.substring(0, floor(str2.length() * count)) : str2.substring(0, floor(str1.length() * count));
   println(value, count);
   }*/
  return count;
}
