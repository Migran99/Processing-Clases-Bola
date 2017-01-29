/* 
 Ejemplo de como crear un objeto basado en clases
 Conceptos: constructor con argumentos
 Clases tipo array
 */
Pelota[] miPelota = new Pelota[20];

float play_posx = 0;
float play_posy = 0;
int player_radio = 12;
int vidas = 5;

PFont font1;
int fps = 60;

int pantalla = 0;


void setup() {
  size (500, 500);
  frameRate(fps);
  for (int i=0; i< miPelota.length/2; i++) {
    miPelota[i]= new Pelota(width*(i+1)/(miPelota.length/2 +1), height*1/3, i);
  }

  for (int i=0; i< miPelota.length/2; i++) {
    miPelota[i+(miPelota.length/2)]= new Pelota(width*(i+1)/(miPelota.length/2 +1), height*2/3, i + miPelota.length/2);
  }

  for (int i=0; i< miPelota.length; i++) {
    println(miPelota[i].xpos);
  }

  font1 = createFont("Califa-Italic-16", 16, true);
}

void draw() {
  background(255-vidas*10, 100, 100);

  switch (pantalla) {
  case 0: 
    menu();
    break;
  case 1: 
    jugar();
    break;

  case 2:
    perder();
    break;
  }
}

float distanceto(int x1, int y1, int x2, int y2) {
  return sqrt(sq(x1-x2) + sq(y1-y2));
}


//////////////////////
class Pelota {
  // DATOS 
  float xpos;  // posicion x de la pelota
  float ypos;  // posicion y de la pelotq
  float vx;  // velocidad x pelota
  float vy;  // velocidad y pelota
  float diameter; // diametro de la pelota
  color c; // color de relleno de la pelota
  // colores del contorno de la pelota
  float r;
  float g;
  float b;
  int id;
  boolean alive = true;

  // CONSTRUCTOR
  Pelota(float xposTemp, float yposTemp, int idTemp) {
    c=color (255);
    xpos=xposTemp;
    id = idTemp;
    ypos=yposTemp;
    vx=random(-4, 4);
    vy=random(-4, 4); 
    diameter= random (20, 30);
    r=random(0, 255);
    g=random(0, 255);
    b=random(0, 255);
  }
  // FUNCIONES
  // dibuja la pelota
  void display() {
    if (alive) {
      fill(c);
      stroke(r, g, b);
      strokeWeight(2);
      ellipse(xpos, ypos, diameter, diameter);
    }
  }
  // mueve la pelota
  void move() {
    if (alive) {
      xpos=xpos+vx;
      ypos=ypos+vy;
      if (( xpos>width-diameter/2)||(xpos-diameter/2<0)) {
        vx=-vx;
      }  
      if ((ypos>height-diameter/2)||(ypos-diameter/2<0)) {
        vy=-vy;
      }
    }
  }
  // crece
  void crecer() {
    diameter=diameter+0.01;
  }

  void rebotar() {
    if (alive) {
      for (int i=0; i < miPelota.length; i++) {
        if (i != id) {
          if (distanceto((int)xpos, (int)ypos, (int)miPelota[i].xpos, (int)miPelota[i].ypos) < (diameter+miPelota[i].diameter)/2 && miPelota[i].alive) {
            vx*=-1.005;
            vy*=-1.005;
          }
        }
      }
    }
  }
}
//////////////////////

void dibujar_player() {
  fill(255 - vidas*20, 50, 50);
  strokeWeight(4);
  ellipse(play_posx, play_posy, 2*player_radio, 2*player_radio);
}

void mover_player() {
  play_posx = mouseX;
  play_posy = mouseY;
}

void colision_player() {
  for (int i = 0; i<miPelota.length; i++) {
    if (distanceto((int)play_posx, (int)play_posy, (int)miPelota[i].xpos, (int)miPelota[i].ypos) < (player_radio*2+miPelota[i].diameter)/2 && miPelota[i].alive) {
      println("Perdiste wey");
      miPelota[i].alive = false;
      vidas --;
      player_radio += 2;
    }
  }

  if (vidas == 0) {
    pantalla = 2;
  }
}

void hud() {
  textFont(font1, height/9);  //Seleccionamos la fuente del texto            
  fill(255);
  textAlign(LEFT); //La alineacion del texto con la posicion que demos
  text("Vidas:" + vidas, 0, height/9);

  textAlign(RIGHT); //La alineacion del texto con la posicion que demos
  text("Tiempo:" + millis()/1000, width, height/9);
}

void jugar() {
  for (int i=0; i< miPelota.length; i++) {
    miPelota[i].move();
    //miPelota[i].crecer();
    miPelota[i].display();
    miPelota[i].rebotar();
  }

  dibujar_player();
  mover_player();
  colision_player();
  hud();
}

void menu() {
  background(75);
  textFont(font1, height/5);  //Seleccionamos la fuente del texto            
  fill(125);
  textAlign(CENTER); //La alineacion del texto con la posicion que demos
  text("BOUNCE", width/2, height/4); //Dibujamos el string que queramos (PONG en este caso)
  fill(200);
  rect(0, height/2, width, height/6);
  textFont(font1, height/6); 
  fill(125);
  text("PLAY", width/2, height/2 + height/6 - height/50);
  textFont(font1, 16); 
  fill(500);
  textAlign(LEFT);
  text("Miguel Granero", width-textWidth("Miguel Granero:"), height-16);
}

void perder() {
  background(75);
  textFont(font1, height/5);        
  fill(125);
  textAlign(CENTER);
  for (int i = 1; i<=3; i++) {
    text(i, width/10, height*i/4);
  }
}





void mousePressed() {
  switch(pantalla) {
  case 0:
    if (mouseY < height/2 + height/6 && mouseY > height/2 && pantalla == 0) {
      pantalla=1; //Si pulsamos el boton del menu entramos al juego
    }
  }
}
