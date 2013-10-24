// TODO: Impelmetn

// This is currenlty a copy of the SimpleControls demo firmware:


#include <SPI.h>
#include <ble.h>
#include <Servo.h> 
 
//#define DIGITAL_OUT_PIN    4
//#define DIGITAL_IN_PIN     5
//#define PWM_PIN            6
//#define SERVO_PIN          7
//#define ANALOG_IN_PIN      A5
#define DIGITAL_OUT_0        0
#define DIGITAL_OUT_1        1
#define DIGITAL_OUT_2        2
#define DIGITAL_OUT_3        3
#define DIGITAL_OUT_4        4
#define DIGITAL_OUT_5        5
#define DIGITAL_OUT_6        6
#define DIGITAL_OUT_7        7



Servo myservo;

void setup()
{
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();

  ble_begin();
  
//  pinMode(DIGITAL_OUT_PIN, OUTPUT);
//  pinMode(DIGITAL_IN_PIN, INPUT);
  pinMode(DIGITAL_OUT_0, OUTPUT);
  pinMode(DIGITAL_OUT_1, OUTPUT);
  pinMode(DIGITAL_OUT_2, OUTPUT);
  pinMode(DIGITAL_OUT_3, OUTPUT);
  pinMode(DIGITAL_OUT_4, OUTPUT);
  pinMode(DIGITAL_OUT_5, OUTPUT);
  pinMode(DIGITAL_OUT_6, OUTPUT);
  pinMode(DIGITAL_OUT_7, OUTPUT);
  
  //servo.attach(SERVO_PIN);
}

void loop()
{
  static boolean analog_enabled = false;
  static byte old_state = LOW;
  
  // If data is ready
  while(ble_available())
  {
    // read out command and data
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();
    
    
    // digital write (always 0x01)     |  0x01 (HIGH) 0x00 (LOW) | PIN NUMBER
    // Command is to control digital out pin
    if (data0 == 0x01){
      if (data1 == 0x01){
          digitalWrite(data2, HIGH);
      } else{
          digitalWrite(data2, LOW);
      }
    }
//    else if (data0 == 0xA0) // Command is to enable analog in reading
//    {
//      if (data1 == 0x01)
//        analog_enabled = true;
//      else
//        analog_enabled = false;
//    }
//    else if (data0 == 0x02) // Command is to control PWM pin
//    {
//      analogWrite(PWM_PIN, data1);
//    }
//    else if (data0 == 0x03)  // Command is to control Servo pin
//    {
//      myservo.write(data1);
//    }
//  }
//  
//  if (analog_enabled)  // if analog reading enabled
//  {
//    // Read and send out
//    uint16_t value = analogRead(ANALOG_IN_PIN); 
//    ble_write(0x0B);
//    ble_write(value >> 8);
//    ble_write(value);
//  }
//  
//  // If digital in changes, report the state
//  if (digitalRead(DIGITAL_IN_PIN) != old_state)
//  {
//    old_state = digitalRead(DIGITAL_IN_PIN);
//    
//    if (digitalRead(DIGITAL_IN_PIN) == HIGH)
//    {
//      ble_write(0x0A);
//      ble_write(0x01);
//      ble_write(0x00);    
//    }
//    else
//    {
//      ble_write(0x0A);
//      ble_write(0x00);
//      ble_write(0x00);
//    }
  }
  
  if (!ble_connected())
  {
    analog_enabled = false;
    digitalWrite(DIGITAL_OUT_0, LOW);
    digitalWrite(DIGITAL_OUT_1, LOW);
    digitalWrite(DIGITAL_OUT_2, LOW);
    digitalWrite(DIGITAL_OUT_3, LOW);
    digitalWrite(DIGITAL_OUT_4, LOW);
    digitalWrite(DIGITAL_OUT_5, LOW);
    digitalWrite(DIGITAL_OUT_6, LOW);
    digitalWrite(DIGITAL_OUT_7, LOW);
  }
  
  // Allow BLE Shield to send/receive data
  ble_do_events();  
}



