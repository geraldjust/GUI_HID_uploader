# GUI_HID_uploader
This is a GUI (processing) based HID loader for STM32 chips |


This is based on processing p3.
https://processing.org/

Written in Java, with hidapi java wrapper. You need to install "ControlP5" by doing the following:
click : "Sketch"(on menu bar) ---> "import library" -----> "add library..."
Once you open dialog box, look for "ControlP5" adn install. 

open the PDE file and run! 



Tested on Mac 11.3 and windows10


To export a bin file from stm32duino, select your "upload method" to be 2.2 HID, then "Sketch" ---> "Export compiled Binary", 
This saved the .bin file in the arduino folder the sketch is on. 
