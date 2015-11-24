#include <DHT.h>
#include <DateTime.h> //  External http://playground.arduino.cc/Code/DateTime
#include <DateTimeStrings.h> // External http://playground.arduino.cc/Code/DateTime
#include <SD.h>

#define PHOTO_PIN A0
File myFile;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
    Serial.println("initializing SD card")

  if(!SD.begin(10))
  {
    Serial.print("initialization Failed")
    return;
    }
  Serial.print("initialization Complete")
}

void loop() {
  // put your main code here, to run repeatedly:
  myFile = SD.open("lightSensor.txt", FILE_WRITE);

  if(myFile)
  {

    Serial.println(analogRead(PHOTO_PIN));    
    myFile.print(DateTime.now()); // External http://playground.arduino.cc/Code/DateTime
    myFile.print("|")
    myFile.print(analogRead(PHOTO_PIN));
    Serial.println(" C");
    myFile.close();
    delay(1000);
 
  }else
  
  {

    
    Serial.print("Error opening the file");
    
    
    }

}
