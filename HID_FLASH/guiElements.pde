Textarea outputArea, outputAreaPath;
Button FlashButton, FirmwareButton, BootloaderMode_Button ;
ScrollableList portsList;


public void guiSetup() {
  cp5 = new ControlP5(this);
 

  //serial output: 70-12=58 chars wide
  outputArea = cp5.addTextarea("serialOutput")
    .setPosition(20, 180)
    .setSize(620, 200)
    .setFont(createFont("Arial", 12, true))
    .scroll(1)
    .setLineHeight(14)
    .setColor(#FFFFFF)
    .setColorBackground(#444444)
    .setScrollBackground(#222222);

  outputAreaPath = cp5.addTextarea("URLpath")
    .setPosition(20, 60)
    .setSize(620, 60)
    .setFont(createFont("Arial", 12, true))
    .setLineHeight(14)
    .scroll(1)
    .setColor(#FFFFFF)
    .setColorBackground(#444444)
    .setScrollBackground(#222222);
PFont.list();

  //flash
  FlashButton = cp5.addButton("FlashButton")
    .setPosition(140, 140)
    .setSize(100, 20)
    .setLabel("Flash Firmware");


  //select firmware
  FirmwareButton = cp5.addButton("FirmwareButton")
    .setPosition(20, 140)
    .setSize(100, 20)
    .setLabel("Select Frimware");
    
      BootloaderMode_Button = cp5.addButton("BootloaderMode_Button")
    .setPosition(220, 20)
    .setSize(120, 20)
    .setLabel("Enter Bootloader Mode");


  //COM port selection
  portsList = cp5.addScrollableList("portsList")
    .setPosition(20, 20)
    .setSize(190, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .setItems(comList)
    .setLabel(" COM ports")
    .close();
}



void CP5AddOns() {
  //auto-update available COM ports on every redraw
  comList = Serial.list();
  cp5.get(ScrollableList.class, "portsList").setItems(comList);

  fill(#FFFFFF);
  stroke(#000000);
}
