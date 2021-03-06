void InitStepper(int CSPIN, int ENPIN, TMC2130Stepper &treiber, AccelStepper &motor, int MotorCurrent, int MicroSteps, uint16_t StallVal, float Speed, float Accel) {
  pinMode(CSPIN, OUTPUT);
  digitalWrite(CSPIN, HIGH);
  treiber.begin();             // Initiate pins and registeries
  treiber.rms_current(MotorCurrent);    // Set stepper current to 600mA. The command is the same as command TMC2130.setCurrent(600, 0.11, 0.5);
  treiber.stealthChop(1);      // Enable extremely quiet stepping
  treiber.stealth_autoscale(1);
  treiber.microsteps(MicroSteps);
  treiber.coolstep_min_speed(0x0);
  treiber.sg_stall_value(StallVal);
  treiber.sg_filter(false);

  motor.setMaxSpeed(Speed * 3.338 * MicroSteps); // 100mm/s @ 80 steps/mm
  motor.setAcceleration(Accel * 3.338 * MicroSteps); // 2000mm/s^2
  motor.setEnablePin(ENPIN);
  motor.setPinsInverted(false, false, true);
  motor.enableOutputs();

  digitalWrite(CSPIN, LOW);

}

void InitAll() {
  pinMode(CS_PIN1, OUTPUT);
  digitalWrite(CS_PIN1, HIGH);
  driverA.begin();             // Initiate pins and registeries
  driverA.rms_current(200);    // Set stepper current to 600mA. The command is the same as command TMC2130.setCurrent(600, 0.11, 0.5);
  driverA.stealthChop(1);      // Enable extremely quiet stepping
  driverA.stealth_autoscale(1);
  driverA.microsteps(16);
  driverA.coolstep_min_speed(0x0);
  driverA.sg_stall_value(STALL_VALUE);
  driverA.sg_filter(false);

  stepperA.setMaxSpeed(300 * 3.338 * 16); // 100mm/s @ 80 steps/mm
  stepperA.setAcceleration(300 * 3.338 * 16); // 2000mm/s^2
  stepperA.setEnablePin(EN_PIN);
  stepperA.setPinsInverted(false, false, true);
  stepperA.enableOutputs();

  digitalWrite(CS_PIN1, LOW);

  pinMode(CS_PIN2, OUTPUT);
  digitalWrite(CS_PIN2, HIGH);
  driverB.begin();             // Initiate pins and registeries
  driverB.rms_current(200);    // Set stepper current to 600mA. The command is the same as command TMC2130.setCurrent(600, 0.11, 0.5);
  driverB.stealthChop(1);      // Enable extremely quiet stepping
  driverB.stealth_autoscale(1);
  driverB.microsteps(16);
  driverB.coolstep_min_speed(0x0);
  driverB.sg_stall_value(STALL_VALUE);
  driverB.sg_filter(false);

  stepperB.setMaxSpeed(300 * 3.338 * 16); // 100mm/s @ 80 steps/mm
  stepperB.setAcceleration(300 * 3.338 * 16); // 2000mm/s^2
  stepperB.setEnablePin(EN_PIN);
  stepperB.setPinsInverted(false, false, true);
  stepperB.enableOutputs();

  digitalWrite(CS_PIN2, LOW);

  pinMode(CS_PIN3, OUTPUT);
  digitalWrite(CS_PIN3, HIGH);
  driverC.begin();             // Initiate pins and registeries
  driverC.rms_current(200);    // Set stepper current to 600mA. The command is the same as command TMC2130.setCurrent(600, 0.11, 0.5);
  driverC.stealthChop(1);      // Enable extremely quiet stepping
  driverC.stealth_autoscale(1);
  driverC.microsteps(16);
  driverC.coolstep_min_speed(0x0);
  driverC.sg_stall_value(STALL_VALUE);
  driverC.sg_filter(false);

  stepperC.setMaxSpeed(300 * 3.338 * 16); // 100mm/s @ 80 steps/mm
  stepperC.setAcceleration(300 * 3.338 * 16); // 2000mm/s^2
  stepperC.setEnablePin(EN_PIN);
  stepperC.setPinsInverted(false, false, true);
  stepperC.enableOutputs();

  digitalWrite(CS_PIN3, LOW);


}
