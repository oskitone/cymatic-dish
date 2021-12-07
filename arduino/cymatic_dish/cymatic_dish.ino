#define CIRCULAR_BUFFER_DEBUG
#include <CircularBuffer.h>
#define BUFFER_MAX 5

const int SPEAKER_PIN = 11;
const int FREQUENCY_CONTROL_PIN = A0;

const int MIN = 32.97; // C6
const int MAX = 2109.89; // C0

const long THROTTLE = 10;

const bool DEBUG = true;

float frequency = 0;

CircularBuffer<float, BUFFER_MAX> _buffer;
float getVoltage(float pin) {
  float newVoltage = analogRead(pin) * (5.0 / 1023.0) / 5;

  _buffer.push(newVoltage);

  float total = 0;

  for (float i = 0; i < _buffer.size(); i++) {
    total += _buffer[i];
  }

  float average = total / _buffer.size();

  return average;
}

unsigned long oldMillis = 0;
float getFrequency(bool skipPoll = false) {
  unsigned long newMillis = millis();
  bool pollPasses = (unsigned long)(newMillis - oldMillis) >= THROTTLE;

  if (skipPoll || pollPasses) {
    oldMillis = newMillis;
    return MIN + (MAX - MIN) * getVoltage(FREQUENCY_CONTROL_PIN);
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
