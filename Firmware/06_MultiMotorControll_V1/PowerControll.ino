boolean PowerButtonWasPressed() {
  //return false;
  return bitRead(FlagRegister, PowerButtonPressed);
}

void blockShutdown() {
  ShutdownBlockTimeStamp = millis();
  ShutdownPossible = false;
}

void releaseShutdown() {
  ShutdownPossible = true;
}

boolean ShutdownBlockTimeOutTriggered() {
  if (millis()-ShutdownBlockTimeStamp > 5000)return true;
  else return false;

}
