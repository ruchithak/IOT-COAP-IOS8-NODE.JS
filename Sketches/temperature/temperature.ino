#include <DHT.h>
#include <DateTime.h> // External http://playground.arduino.cc/Code/DateTime
#include <DateTimeStrings.h> // External http://playground.arduino.cc/Code/DateTime
#include <SD.h>

#define DHTIN 2
#define DHTOUT 3

#define DHTTYPE DHT22

DHT dht(DHTIN, DHTOUT, DHTTYPE);
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
    
  dht.begin();

}

void loop() {
  // put your main code here, to run repeatedly:

  myFile = SD.open("temperatureSensor.txt", FILE_WRITE);

 
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  delay(2000);

  if(isnan(h) || isnan(t))
  {
    Serial.println("Couldn't read temp!");
  }
  else
  {

  if(myFile)
  {
    Serial.print("Humidity: ");
    Serial.print(h);
    Serial.print("\tTemp: ");
    Serial.print(t);
    myFile.print(DateTime.now());// External http://playground.arduino.cc/Code/DateTime
    myFile.print("|")
    myFile.print(t)
    Serial.println(" C");
    myFile.close();
 
  }else
  
  {

    
    Serial.print("Error opening the file");
    
    
    }

 
  }
  delay(3000);
}
