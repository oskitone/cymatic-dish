const int SPEAKER_PIN = 11;

const float frequency = 220;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  tone(SPEAKER_PIN, frequency);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  noTone(SPEAKER_PIN);
  delay(1000);
}
