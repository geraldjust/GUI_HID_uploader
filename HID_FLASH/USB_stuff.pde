
// This is to select a file
public void FirmwareButton(int n){
  
    selectInput("Select a file : ", "fileSelected");
}

//select port list if any
public void portsList(int n) {
  portSelected = true;
  portNum = n;
}

 

//this is button if comport selected pressing this button sets BL mode
public void BootloaderMode_Button(int n){
    if (portSelected) {
    if (!COM_is_connected) {
      port = new Serial(this, Serial.list()[portNum], 9600);
    }
    port.setDTR(false);
    port.setDTR(true);
    delay(1);
    port.setDTR(false);
    delay(1);
    port.setDTR(true);
    delay(1);
    port.setDTR(false);
    //send magic
    port.write("1EAF");
    //close comport
    port.stop();
  }
  
}


//Starts the thread for flashing. This has to be a thread in order to allow printing on the screen as the file is being flashed. 
void FlashButton (int n) {

  thread("Flashing_action");
}






public void Flashing_action() {

//check if device has already been inititalized. if so then null it. 
  if (device!=null) {
    device = null;
    return;
  } 
  
  //cehck if file is selected. if not then notify it
    if (!file_selected ) {
    println("no selection so far...");
    outputArea.append("no file selection so far...\n");
    return;
  }


  println("> Searching for device... 0x" + hex(VENDOR_ID, 4) +"  0x"+ hex(PRODUCT_ID, 4) );
  outputArea.append("> Searching for device... 0x" + hex(VENDOR_ID, 4) +"  0x"+ hex(PRODUCT_ID, 4) + "\n" );
  deviceFindFirst();


  if (device == null) {
    println("Could not find device");
    outputArea.append("Could not find device\n");
    return;
  }

//if we find a device lets keep going. 
  println("Found device!"); 
  outputArea.append("Found device!\n");
  //begin flashing stuff

  println("RESETTING PAGES");
  outputArea.append("RESETTING PAGES\n");
  //this is reset pages command    
  deviceWrite(CMD_RESET_PAGES);

  // Send Firmware File data
  println("> Flashing firmware...");
  outputArea.append("> Flashing firmware...\n");


// actual flashing procedure after restting pages
  byte opened_file[] = loadBytes(myFimwareFilePath); 
  int n_bytes = 0;
  byte[] hid_tx_buf = new byte[HID_TX_SIZE];
  byte[] hid_rx_buf = new byte[HID_RX_SIZE];

  //clear buffer
  for (int i=0; i< hid_tx_buf.length; i++) { 
    hid_tx_buf[i]= 0;
  }
  
  
  do {

    for (int i = 0; i < SECTOR_SIZE; i += HID_TX_SIZE ) {

      if ( opened_file.length - n_bytes > HID_TX_SIZE ){
        System.arraycopy(opened_file, n_bytes, hid_tx_buf, 0, HID_TX_SIZE );//copy full 64bytes
      } else if (opened_file.length - n_bytes > 0){//copy over last bytes of file becuase less than 64
        System.arraycopy(opened_file, n_bytes, hid_tx_buf, 0, opened_file.length - n_bytes );//reach EOF
      }

      deviceWrite(hid_tx_buf);
      //clear buffer
      for (int ia=0; ia< hid_tx_buf.length; ia++) { hid_tx_buf[ia]= 0; }
      
      if ((i % 1024) == 0) { 
        print(".");
        outputArea.append(".");
      }
      n_bytes += (HID_TX_SIZE );
      delay(2);
    }
    
    println("" + n_bytes + " Bytes" );
    outputArea.append("" + n_bytes + " Bytes\n" );

    
    


    //wait to see the RX buff[7] == 0x02
    do {
      hid_rx_buf = deviceRead();
      delay(2);
      
    } while (hid_rx_buf[7] != 0x02);
    
  } while (n_bytes < opened_file.length);






  println("\n> Done!");
  outputArea.append("\n> Done!\n");

  println("> Sending <reboot mcu> command...");
  outputArea.append("> Sending <reboot mcu> command...\n");
  if (deviceWrite(CMD_REBOOT_MCU)) {
    println("reset");
    outputArea.append("reset\n");
  } else {
    println("Error restting");
    outputArea.append("Error restting\n");
  }
  println("Done!");
  outputArea.append("Done!\n\n");
  
}











public void deviceInitialize() {
  if (!HID_device_initialized) {
    HID_device_initialized = true;
    com.codeminders.hidapi.ClassPathLibraryLoader
      .loadNativeHIDLibrary();
    println("HID Initialized");
    outputArea.append("HID Initialized\n");
  }
}





public HIDDeviceInfo[] deviceFindAllDescriptors() {
  List<HIDDeviceInfo> devlist = new ArrayList<HIDDeviceInfo>();
  try {
    HIDManager hidManager = HIDManager.getInstance();
    HIDDeviceInfo[] infos = hidManager.listDevices();
    for (HIDDeviceInfo info : infos) {
      if (info.getVendor_id() == VENDOR_ID
        && info.getProduct_id() == PRODUCT_ID) {
        devlist.add(info);
      }
    }
  } 
  catch (Exception e) {
  }
  return devlist.toArray(new HIDDeviceInfo[devlist.size()]);
}






public void deviceFindFirst() {
  deviceInitialize();
  HIDDeviceInfo[] infos = deviceFindAllDescriptors();
  if (infos.length > 0) {
    try {
      device = infos[0].open(); // open device
      //println(hex(infos[0].getUsage()));
    } 
    catch (Exception e) {
      device = null;
    }
  }
}








public byte[] deviceRead() {
  byte[] hid_tx_buf = new byte[HID_RX_SIZE];
  try {
    //device.disableBlocking();
    int read = device.read(hid_tx_buf);
    return hid_tx_buf;
  } 
  catch(IOException ioe) {
    //ioe.printStackTrace();
    println("deviceRead error");
  }
  return null;
}

  



public boolean deviceWrite(byte[] hid_tx_buf) {


  

  try {
    //if(thisIsWindows){
        byte[] data = new byte[hid_tx_buf.length+1];
        data[0] = 0;
        System.arraycopy(hid_tx_buf, 0, data, 1, hid_tx_buf.length);
        //device.disableBlocking();
      device.write(data);

    //}else{
      
        //byte[] data = new byte[hid_tx_buf.length+1];
        //data[0] = 0;
        //System.arraycopy(hid_tx_buf, 0, data, 1, hid_tx_buf.length);
        //device.disableBlocking();
      //device.write(data);
    //}
    
    return true;
  } 
  catch(Exception e) {
    e.printStackTrace();
    return false;
  }
}
