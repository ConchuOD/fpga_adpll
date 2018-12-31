#include "TimerHelpers.h"
#define COMPARISONPIN A0
// output is on digital 5, digital 6 has V_DD

const byte timer0Input = 4;
const byte timer0OutputA = 6;
const byte timer0OutputB = 5;  

void setup() {
   pinMode(LED_BUILTIN, OUTPUT);
   pinMode(timer0OutputA, OUTPUT); 
   pinMode(timer0OutputB, OUTPUT); 
   TIMSK0 = 0;  // no interrupts
   Timer0::setMode(7, Timer0::PRESCALE_1, Timer0::CLEAR_A_ON_COMPARE | Timer0::CLEAR_B_ON_COMPARE);
   OCR0A = 12; // frequency = 1/(OCR0A*62.5ns)
   OCR0B = 6; // Duty cycle = OCR0B/OCR0A
}  // end setup

void loop(){
// Pot. control of duty cycle between 20% and 80% of the range.
//  int sensorValue = analogRead(COMPARISONPIN);
//  float sensorVoltage = sensorValue * 5.0 / 1023.0;
//  if(sensorVoltage < 1.0 || sensorVoltage > 3.5){
//    OCR0B = 26;
//    digitalWrite(LED_BUILTIN, HIGH);
//  }
//  else{
//    OCR0B = round(sensorVoltage/5.0*OCR0A);
//    digitalWrite(LED_BUILTIN, LOW);
//  }
}
