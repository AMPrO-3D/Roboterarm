#include <avr/io.h>
#include <avr/interrupt.h>
#include  "RegisterDefinition.h"
int STALL_VALUE = 0;
int dir = 1;

#include <TMC2130Stepper_REGDEFS.h>
#include <TMC2130Stepper.h>

#warning __FILE__

IntervalTimer AlliveTimer;
boolean PowerState = 1;
volatile uint32_t FlagRegister = 0;
boolean ShutdownPossible = true;
boolean SerialRequestedShutdown;

boolean RunningMotor = false;

String inputString = "";
bool stringComplete = false;

short Serialcommand = -1;

unsigned long ShutdownBlockTimeStamp;
unsigned long PowerButtonPressStarted;
unsigned long PowerModeChangedTimeStamp;
int arg = 0;

TMC2130Stepper driverA = TMC2130Stepper(EN_PIN, DIR_PIN1, STEP_PIN1, CS_PIN1);
TMC2130Stepper driverB = TMC2130Stepper(EN_PIN, DIR_PIN2, STEP_PIN2, CS_PIN2);
TMC2130Stepper driverC = TMC2130Stepper(EN_PIN, DIR_PIN3, STEP_PIN3, CS_PIN3);
TMC2130Stepper driverD = TMC2130Stepper(EN_PIN, DIR_PIN4, STEP_PIN4, CS_PIN4);
TMC2130Stepper driverE = TMC2130Stepper(EN_PIN, DIR_PIN5, STEP_PIN5, CS_PIN5);
TMC2130Stepper driverF = TMC2130Stepper(EN_PIN, DIR_PIN6, STEP_PIN6, CS_PIN6);
TMC2130Stepper driverG = TMC2130Stepper(EN_PIN, DIR_PIN7, STEP_PIN7, CS_PIN7);
#include <AccelStepper.h>
AccelStepper stepperA = AccelStepper(stepperA.DRIVER, STEP_PIN1, DIR_PIN1);
AccelStepper stepperB = AccelStepper(stepperB.DRIVER, STEP_PIN2, DIR_PIN2);
AccelStepper stepperC = AccelStepper(stepperC.DRIVER, STEP_PIN3, DIR_PIN3);
AccelStepper stepperD = AccelStepper(stepperD.DRIVER, STEP_PIN4, DIR_PIN4);
AccelStepper stepperE = AccelStepper(stepperE.DRIVER, STEP_PIN5, DIR_PIN5);
AccelStepper stepperF = AccelStepper(stepperF.DRIVER, STEP_PIN6, DIR_PIN6);
AccelStepper stepperG = AccelStepper(stepperG.DRIVER, STEP_PIN7, DIR_PIN7);

bool vsense;

uint16_t rms_current(uint8_t CS, float Rsense = 0.11) {
  return (float)(CS + 1) / 32.0 * (vsense ? 0.180 : 0.325) / (Rsense + 0.02) / 1.41421 * 1000;
}



IntervalTimer RefreshTimer;
unsigned long LastTimerCalled = 0;
constexpr uint32_t steps_per_mm = 80;



void setup() {
  // put your setup code here, to run once:
  Serial.begin(500000);
  AlliveTimer.begin(AlliveTimerCalled, 10000000);
  RefreshTimer.begin(RefreshTimerCalled, 10);
  pinMode(32, OUTPUT);
  digitalWrite(32, HIGH);
  attachInterrupt(digitalPinToInterrupt(31), PowerButtonISR, RISING);
  //          CSPIN, ENPIN, treiber, motor, MotorCurrent, MicroSteps, StallVal, Speed, Accel
  InitStepper(CS_PIN1, EN_PIN, driverA, stepperA, 500, 16, STALL_VALUE, 50, 50);
  InitStepper(CS_PIN2, EN_PIN, driverB, stepperB, 750, 16, STALL_VALUE, 50, 50);
  InitStepper(CS_PIN3, EN_PIN, driverC, stepperC, 750, 16, STALL_VALUE, 30, 10);
  InitStepper(CS_PIN4, EN_PIN, driverD, stepperD, 700, 16, STALL_VALUE, 10, 50);
  InitStepper(CS_PIN5, EN_PIN, driverE, stepperE, 700, 16, STALL_VALUE, 50, 50);
  InitStepper(CS_PIN6, EN_PIN, driverF, stepperF, 750, 16, STALL_VALUE, 100, 50);
  InitStepper(CS_PIN7, EN_PIN, driverG, stepperG, 500, 16, STALL_VALUE, 100, 50);
  //InitAll();
}

void loop() {

  static uint32_t last_time = 0;
  uint32_t ms = millis();

  //if (RunningMotor);
  //stepperA.moveTo(arg);


  if (Serialcommand == SC_Shutdown) {
    SerialRequestedShutdown = true;
    Serialcommand = -1;
  }

  if (Serialcommand == SC_Run) {

    RunningMotor = !RunningMotor;
    arg += 16000 * 3 * 5;
    Serialcommand = -1;
  }


  if (((PowerButtonWasPressed() || SerialRequestedShutdown) && (ShutdownPossible || ShutdownBlockTimeOutTriggered) && millis() - PowerModeChangedTimeStamp > 5000) && millis() > 10000) {
    //Serial.println("We can shutdown now!");
    while (digitalRead(31))Serial.println("Release the Button!");
    bitWrite(FlagRegister, PowerButtonPressed, 0);
    PowerModeChangedTimeStamp = millis();
    PowerState = !PowerState;
    SerialRequestedShutdown = false;
    digitalWrite(32, PowerState);
    delay(3000);
  }

  if ((ms - last_time) > 100) //run every 0.1s
  {
    last_time = ms;
    uint32_t drv_status = driverA.DRV_STATUS();
    //Serial.print("0 ");
    //Serial.print((drv_status & SG_RESULT_bm)>>SG_RESULT_bp , DEC);
    //Serial.print(" ");
    //Serial.println(rms_current((drv_status & CS_ACTUAL_bm)>>CS_ACTUAL_bp), DEC);
    uint16_t sgStallValue = driverA.sg_result();

    // Serial.print(driverA.stallguard(), DEC);
    //Serial.print(" ");
    //Serial.print(driverA.sgt(), DEC);
    //Serial.print(" ");
    //Serial.print(sgStallValue, DEC);
    //Serial.print(" ");
    //Serial.print((drv_status & SG_RESULT_bm) >> SG_RESULT_bp , DEC);

    //Serial.print(" ");
    //Serial.print(drv_status);
    //Serial.print(" ");
    //Serial.print(rms_current((drv_status & CS_ACTUAL_bm) >> CS_ACTUAL_bp), DEC);
    //Serial.print("  ");
    //Serial.println(STALL_VALUE);
  }
  uint32_t drv_status = driverA.DRV_STATUS();
  //Serial.print(drv_status, DEC);
  //Serial.print(" ");
  //Serial.println(driverA.sg_stall_value());

}

void PowerButtonISR() {
  if (PowerButtonPressStarted - millis() > 500 && millis() > 20000) {
    bitWrite(FlagRegister, PowerButtonPressed, 1);
    PowerButtonPressStarted = millis();
    //Serial.println("RISING detected");
  }
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();

    if (inChar == 10) {
      stringComplete = true;
      runInputStringDetection(inputString);
      inputString = "";
    } else if (inChar == 13) {

    } else {
      inputString += inChar;
    }
  }
}

void AlliveTimerCalled() {
  //Serial.println(".");
  //if (STALL_VALUE < -63)dir = 1;
  //if (STALL_VALUE > 63)dir = -1;
  //Serial.print(STALL_VALUE);
  //Serial.print("  ");
  //STALL_VALUE += dir;


  //digitalWrite(CS_PIN1, HIGH);
  //driverA.sg_stall_value(STALL_VALUE);
  //digitalWrite(CS_PIN1, LOW);

}


void runInputStringDetection(String IncameString) {
  //Serial.println(IncameString);

  if (IncameString == "H") {
    Serialcommand = SC_Handshake;
    Serial.println("MotionControllerV01OK");
  } else if (IncameString == "Shutdown") {
    Serialcommand = SC_Shutdown;
  } else if (IncameString == "Run") {
    Serialcommand = SC_Run;
    digitalWrite(EN_PIN, LOW);
  } else if (IncameString == "S") {
    stepperA.stop();
    digitalWrite(EN_PIN, HIGH);
  } else if (IncameString.charAt(0) == 'S') {
    //Serial.println("Set Stallguard");
    int newStallGuardValue = IncameString.substring(1).toInt();
    //Serial.println(newStallGuardValue);

    digitalWrite(CS_PIN1, HIGH);
    driverA.sg_stall_value(newStallGuardValue);
    digitalWrite(CS_PIN1, LOW);
  } else {
    char cmd = IncameString.charAt(0);
    String strArg = IncameString.substring(1);

    int arg = strArg.toInt();
    if (cmd == 'A') {
      stepperA.moveTo(arg);
      Serial.print("Fahre X auf ");
      Serial.println(arg * 100);
    } else if (cmd == 'B') {
      stepperB.moveTo(arg);
      Serial.print("Fahre Y auf ");
      Serial.println(arg);
    } else if (cmd == 'C') {
      stepperC.moveTo(arg);
      Serial.print("Fahre Z auf ");
      Serial.println(arg);
    } else if (cmd == 'D') {
      stepperD.moveTo(arg);
      Serial.print("Fahre D auf ");
      Serial.println(arg);
    } else if (cmd == 'E') {
      stepperE.moveTo(arg);
      Serial.print("Fahre E auf ");
      Serial.println(arg);
    } else if (cmd == 'F') {
      stepperF.moveTo(arg);
      Serial.print("Fahre F auf ");
      Serial.println(arg);
    } else if (cmd == 'G') {
      stepperG.moveTo(arg);
      Serial.print("Fahre G auf ");
      Serial.println(arg);
    }


  }
}

void RefreshTimerCalled() {
  //Serial.println(micros() - LastTimerCalled);
  LastTimerCalled = micros();
  stepperA.run();
  stepperB.run();
  stepperC.run();
  stepperD.run();
  stepperE.run();
  stepperF.run();
  stepperG.run();
}
