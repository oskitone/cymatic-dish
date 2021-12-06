const int SPEAKER_PIN = 11;
const int FREQUENCY_CONTROL_PIN = A0;

const int MIN = 32.97; // C6
const int MAX = 2109.89; // C0

const long THROTTLE = 10;

const bool DEBUG = true;

float frequency = 0;

float getVoltage(int pin) {
  return analogRead(pin) * (5.0 / 1023.0) / 5;
}

unsigned long oldMillis = 0;
float getFrequency(bool skipPoll = false) {
  unsigned long newMillis = millis();
  bool pollPasses = (unsigned long)(newMillis - oldMillis) >= THROTTLE;

  if (skipPoll || pollPasses) {
    oldMillis = newMillis;
    return round(MIN + (MAX - MIN) * getVoltage(FREQUENCY_CONTROL_PIN));
  }

  return frequency;
}

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
}

void loop() {
  frequency = getFrequency();

  if (DEBUG) {
    Serial.println(frequency);
  }

  if (frequency > 0) {
    tone(SPEAKER_PIN, frequency);
  }
}
