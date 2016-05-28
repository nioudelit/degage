/* Utilisation du capteur Ultrason HC-SR04 */

// définition des broches utilisées
int trig = 12;
int echo = 11;
long lecture_echo;
long cm;

void setup()
{
  pinMode(trig, OUTPUT);
  digitalWrite(trig, LOW);
  pinMode(echo, INPUT);
  Serial.begin(9600);
}

void loop()
{
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  lecture_echo = pulseIn(echo, HIGH);
  //Serial.print(lecture_echo);
  //Serial.print("\n");
  cm = lecture_echo / 58;
  //Serial.print("Distancem : ");
  Serial.write(cm);
  delay(500);
}
