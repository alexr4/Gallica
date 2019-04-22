public static double median (List<Number> a) {
  int middle = a.size()/2;

  if (a.size() % 2 == 1) {
    return a.get(middle).intValue();
  } else {
    return (a.get(middle-1).intValue() + a.get(middle).intValue()) / 2.0;
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
