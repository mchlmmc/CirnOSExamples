ledPin = 47                    --> Initialize constant pin number (LED on Pi Zero)

pinMode(ledPin, OUTPUT)        --> Set pin 47 (LED) to output mode

while true do
   writePin(ledPin, ON)        --> LED on
   delay(500)                  --> Delay 500ms   
   writePin(ledPin, OFF)       --> LED off
   delay(500)   
end
