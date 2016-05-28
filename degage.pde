//ARDUINO: ultrasonss
import ddf.minim.*;
import ddf.minim.effects.*;
import processing.serial.*;

Minim minim;
AudioPlayer voix;
Serial myPort;

PImage[] anim = new PImage[3];
int val;

void setup() {
  size(640, 420);
  minim = new Minim(this);
  voix = minim.loadFile("voix.wav", 2048);

  String portName = Serial.list()[4];
  for (int i = 0; i < Serial.list().length; i++) {
    println(i + "     " + Serial.list()[i]);
  }
  myPort = new Serial(this, portName, 9600);

  for (int i = 0; i < anim.length; i++) {
    anim[i] = loadImage(i + ".jpg");
  }
}

void draw() {
  affichage();
  arduino();
}

void arduino() {
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    //String data = myPort.readStringUntil('\n');
    println(val);
    //println(data);
  }
}

void affichage() {
  if (val < 90 && voix.isPlaying() == false) {
    voix.play(1);
  } else {
    image(anim[0], 0, 0);
  }
  if (voix.position() > 1 && voix.position() < voix.bufferSize()-1 && voix.isPlaying()) {
    if (voix.left.get(voix.position()-1) >= -0.01 && voix.left.get(voix.position()-1) < 0.2) {
      image(anim[1], 0, 0);
    } else if (voix.left.get(voix.position()-1) >= 0.2) {
      image(anim[2], 0, 0);
    } else {
      image(anim[0], 0, 0);
    }
  }
}

  void keyReleased() {
    voix.play(1);
  }

  void connexion() {
    while (myPort.available() > 0) {
      String data = myPort.readStringUntil('\n');
      if (data != null) {
        String valeurs[] = splitTokens(data, "$ \n \r \t ");
        if (valeurs.length < 8) {
          for (int i = 0; i < 7; i++) {
            valeurs = append(valeurs, "0");
          }
        }
        //println("Nombres données?  " + valeurs.length);
      }
    }
  }

  //10627