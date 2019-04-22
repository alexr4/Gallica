/*--------------------------------------
 This static class is an helper to find and load all files from a specified path
 ----------------------------------------*/
static class FilesLoader {
  //return a arrayList of all the specifiv datatype files from a specific directory
  static ArrayList<String> getAllPathToTypeFilesFrom(PApplet context, String type) {
    return getAllPathToTypeFilesFrom(context, "", type);
  }

  static ArrayList<String> getAllPathToTypeFilesFrom(PApplet context, String path, String type) {
    ArrayList<String> pathList = new ArrayList<String>();
    try {
      //check folder
      String absolutePath = path; 
      java.io.File folder = getFolderAt(context, absolutePath);
      ArrayList<File> files = new ArrayList<File>();
      getTypeFilesAt(folder, files, type);
      for (File f : files) {
        //println(f.getName());
       
        pathList.add(f.getCanonicalPath());
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }

    return pathList;
  }
  
  //get a list of fileName
  static ArrayList<String> getAllFilesNameFrom(PApplet context, String path, String type) {
    ArrayList<String> nameList = new ArrayList<String>();
    try {
      //check folder
      String absolutePath = path; 
      java.io.File folder = getFolderAt(context, absolutePath);
      ArrayList<File> files = new ArrayList<File>();
      getTypeFilesAt(folder, files, type);
      for (File f : files) {
        String s = f.getName();
        s = s.substring(0, s.length()- type.length() - 1);
        nameList.add(s);
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }

    return nameList;
  }

  //return a arrayList of all the specifiv datatype files from a specific directory
  static ArrayList<File> getAllTypeFilesFrom(PApplet context, String type) {
    return getAllTypeFilesFrom(context, "", type);
  }

  static ArrayList<File> getAllTypeFilesFrom(PApplet context, String path, String type) {
    ArrayList<File> files = new ArrayList<File>();
    try {
      //check folder
      String absolutePath = path; 
      java.io.File folder = getFolderAt(context, absolutePath);
      getTypeFilesAt(folder, files, type);
    }
    catch(Exception e) {
      e.printStackTrace();
    }

    return files;
  }

  //return a arraylist of all the files from specific directory
  static ArrayList<File> getAllFilesFromDataPath(PApplet context) {
    return getAllFilesFrom(context, "");
  }

  static ArrayList<File> getAllFilesFrom(PApplet context, String path) {
    ArrayList<File> files = new ArrayList<File>();
    try {
      //check folder
      String absolutePath = path; 
      java.io.File folder = getFolderAt(context, absolutePath);
      getFilesAt(folder, files);
    }
    catch(Exception e) {
      e.printStackTrace();
    }

    return files;
  }

  static ArrayList<String> getAllDirectoryFrom(PApplet context, String path) {
    ArrayList<String> directoryList = new ArrayList<String>();
    String absolutePath = path; 
    java.io.File folder = getFolderAt(context, absolutePath);
    getDirectoryAt(folder, directoryList);
    return directoryList;
  }

  //Recursivly find typed files and add it to a provided list 
  static void getTypeFilesAt(java.io.File folder, ArrayList<File> filesList, String type) {
    try {
     // type = type.toLowerCase();
      File[] files = folder.listFiles();
      for (File file : files) {
        if (file.isDirectory()) {
          // println("directory:" + file.getCanonicalPath());
          getTypeFilesAt(file, filesList, type);
        } else {
          String fileName = file.getName();
          String fileType = fileName.substring(fileName.length() - type.length());
          if (fileType.equals(type)) {
            filesList.add(file);
          } else {
          }
        }
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  } 

  //Recursivly find files and add it to a provided list 
  static void getFilesAt(java.io.File folder, ArrayList<File> filesList) {
    try {
      File[] files = folder.listFiles();
      for (File file : files) {
        if (file.isDirectory()) {
          //System.out.println("directory:" + file.getCanonicalPath());
          getFilesAt(file, filesList);
        } else {
          //System.out.println("     file:" + file.getCanonicalPath());
          filesList.add(file);
        }
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  } 
  
  static void getDirectoryAt(java.io.File folder, ArrayList<String> filesList) {
    try {
      File[] files = folder.listFiles();
      for (File file : files) {
        if (file.isDirectory()) {
          //System.out.println("directory:" + file.getCanonicalPath());
          filesList.add(file.getCanonicalPath());
        } else {
          //System.out.println("     file:" + file.getCanonicalPath());
          //filesList.add(file);
        }
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  } 

  // Display all the content of a specified directory
  static void displayDirectoryContents(PApplet context) {
    File folder = getFolderAt(context, "");
    displayDirectoryContents(folder);
  }

  static void displayDirectoryContents(PApplet context, String path) {
    File folder = getFolderAt(context, path);
    displayDirectoryContents(folder);
  }

  static void displayDirectoryContents(File dir) {
    //found on http://www.avajava.com/tutorials/lessons/how-do-i-recursively-display-all-files-and-directories-in-a-directory.html
    try {
      File[] files = dir.listFiles();
      if (files != null) {
        for (File file : files) {
          if (file.isDirectory()) {
            println("directory:" + file.getCanonicalPath());
            displayDirectoryContents(file);
          } else {
            println("     file:" + file.getCanonicalPath());
          }
        }
      } else {
        println("Directory has no folders or files");
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  static void displayDirectory(PApplet context) {
    File folder = getFolderAt(context, "");
    displayDirectory(folder);
  }

  static void displayDirectory(PApplet context, String path) {
    File folder = getFolderAt(context, path);
    displayDirectory(folder);
  }

  static void displayDirectory(File dir) {
    //found on http://www.avajava.com/tutorials/lessons/how-do-i-recursively-display-all-files-and-directories-in-a-directory.html
    try {
      File[] files = dir.listFiles();
      if (files != null) {
        for (File file : files) {
          if (file.isDirectory()) {
            println("directory:" + file.getCanonicalPath());
            displayDirectoryContents(file);
          } else {
            //println("     file:" + file.getCanonicalPath());
          }
        }
      } else {
        println("Directory has no folders or files");
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  //get the folder at path 
  static java.io.File getFolderAt(PApplet context, String path) {
    return new java.io.File(context.dataPath(path));
  }
}
