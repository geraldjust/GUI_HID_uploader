boolean file_selected = false;

public void fileSelected(File selection) {
  if (selection == null) {
    println("no selection so far...");
    file_selected = false;
  } else {
    myFimwareFilePath         = selection.getAbsolutePath();
    myInputFileContents = loadStrings(myFimwareFilePath) ;// this moves here...
    file_selected = true;
  }
}

 
public void init_Program() {

  String OS = System.getProperty("os.name", "generic").toLowerCase(Locale.ENGLISH);
  if (OS.indexOf("win") >= 0) {
    thisIsWindows = true;
  }
}
