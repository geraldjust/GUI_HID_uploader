/***************************************************** 
*************************************************************/
import processing.serial.*;
import com.codeminders.hidapi.HIDDeviceInfo;
import com.codeminders.hidapi.HIDManager;
import com.codeminders.hidapi.HIDDevice;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import controlP5.*;
import java.io.*;
import java.lang.*;
import java.util.*;

  

ControlP5 cp5;

Serial port;
String[] comList;
int portNum;
String serialPortName;
boolean portSelected = false;
boolean COM_is_connected = false;

String [] myInputFileContents ;
String myFimwareFilePath;
final int BAUD_RATE = 115200;

//HID stuff
boolean paused = false;
HIDDevice device = null;

int VENDOR_ID = 0x1209;
int PRODUCT_ID = 0xBEBA;
int FIRMWARE_VER = 0x0300;
boolean  HID_device_initialized = false;
boolean thisIsWindows = false; //windows require a '0' report ID (deprecated now works on both platforms MAC/win the same)
boolean display_URL_PATH = false;

// flashing part
int SECTOR_SIZE = 1024;
int HID_TX_SIZE  =  64;
int HID_RX_SIZE  =   8;
byte[] CMD_RESET_PAGES = {'B','T','L','D','C','M','D', 0x00};
byte[] CMD_REBOOT_MCU = {'B','T','L','D','C','M','D', 0x01};





public void setup() {
  
  init_Program();
  size(660, 420);
  background(#888888);
  frameRate(30);
  comList = Serial.list();
  guiSetup();
HID_device_initialized = false;
}

public void draw() {
  background(230,230,230);
      if (myInputFileContents != null && (!display_URL_PATH)) {//wait
  outputAreaPath.append(" " + myFimwareFilePath);
  display_URL_PATH = true;
  }else if (myInputFileContents == null){
    outputAreaPath.clear();
  }
  
}
