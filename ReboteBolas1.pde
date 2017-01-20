/* 
 Ejemplo de como crear un objeto basado en clases
 Conceptos: constructor con argumentos
 Clases tipo array
 */
Pelota[] miPelota = new Pelota[20];

float play_posx = 0;
float play_posy  0;

void setup() {
  size (800, 800);
  for (int i=0; i< miPelota.length/2; i++) {
    miPelota[i]= new Pelota(width*(i+1)/(miPelota.length/2 +1),height*1/3 ,i);
  }

  for (int i=0; i< miPelota.length/2; i++) {
    miPelota[i+(miPelota.length/2)]= new Pelota(width*(i+1)/(miPelota.length/2 +1),height*2/3 ,i + miPelota.length/2);
  }
  
  for (int i=0; i< miPelota.length; i++) {
    println(miPelota[i].xpos);
  }
}

void draw() {
  background(255);
  for (int i=0; i< miPelota.length; i++) {
    miPelota[i].move();
    //miPelota[i].crecer();
    miPelota[i].display();
    miPelota[i].rebotar();
    dibujar_player();
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

  // CONSTRUCTOR
  Pelota(float xposTemp, float yposTemp, int idTemp) {
    c=color (255);
    xpos=xposTemp;
    id = idTemp;
    ypos=yposTemp;
    vx=random(-5, 5);
    vy=random(-5, 5); 
    diameter= random (20, 30);
    r=random(0, 255);
    g=random(0, 255);
    b=random(0, 255);
  }
  // FUNCIONES
  // dibuja la pelota
  void display() {

    fill(c);
    stroke(r, g, b);
    strokeWeight(2);
    ellipse(xpos, ypos, diameter, diameter);
  }
  // mueve la pelota
  void move() {
    xpos=xpos+vx;
    ypos=ypos+vy;
    if (( xpos>width-diameter/2)||(xpos-diameter/2<0)) {
      vx=-vx;
    }  
    if ((ypos>height-diameter/2)||(ypos-diameter/2<0)) {
      vy=-vy;
    }
  }
  // crece
  void crecer() {
    diameter=diameter+0.01;
  }

  void rebotar() {
    for (int i=0; i < miPelota.length; i++) {
      if (i != id) {
        if (distanceto((int)xpos, (int)ypos, (int)miPelota[i].xpos, (int)miPelota[i].ypos) < (diameter+miPelota[i].diameter)/2) {
          vx*=-1;
          vy*=-1;
        }
      }
    }
  }
}
//////////////////////

void dibujar_player(){
  fill(255, 100, 50);
  strokeWeight(20);
  ellipse(play_posx,play_posy,50,50);
}

void mover_player(){
  play_posx = mouseX;
  play_posy = mouseY;
  
}

