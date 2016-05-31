//ARDUINO: ultrasonss
import ddf.minim.*;
import ddf.minim.effects.*;
import processing.serial.*;

Minim minim;
int nbrExtraits = 16;
AudioPlayer[] voix = new AudioPlayer[nbrExtraits];
AudioPlayer fond;
Serial myPort;

PImage[] anim = new PImage[3];
int val; //<=60 && <1.20, 1.20, 2
int curseur;
int distanceMax = 200; //EN CENTIMETRES
int distanceMin = 7;
boolean defensive = true;

void setup() {
  //fullScreen(P2D);
  size(640, 420);
  background(0);
  //SON
  minim = new Minim(this);
  for (int i = 0; i < voix.length; i++) {
    voix[i] = minim.loadFile( i + ".wav", 2048);
  }
  //SERIAL
  for (int i = 0; i < Serial.list().length; i++) {
    println(i + "     " + Serial.list()[i]);
  }
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600);
  //IMAGE
  for (int i = 0; i < anim.length; i++) {
    anim[i] = loadImage(i + ".jpg");
  }
}

void draw() {
  affichage();
  arduino();
}

void arduino() {
  if (myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    println(val);
  }
}

void affichage() {
  println(defensive + " " + val + "   CURSEUR   " + curseur);
  if (val < distanceMax && val > distanceMin && voix[curseur].isPlaying() == false) {
    defensive = true;
    curseur = int(map(val, distanceMin, distanceMax, nbrExtraits-1, 0));
  } else {
    defensive = false;
  }
  if (voix[curseur].isPlaying() == false && defensive == true) {
    voix[curseur].play(1);
  } else {
    image(anim[0], 0, 0);
  }
  animationBouche();
}

void animationBouche() {
  int choix = 0;
  if (voix[curseur].isPlaying()) {
    for(int i = 0; i < voix[curseur].bufferSize()-1; i++){
       choix = int(map(voix[curseur].left.get(i), -0.99, 1, 0, 2));
    }
    image(anim[choix], 0, 0);
  } else {
    image(anim[0], 0, 0);
  }
}