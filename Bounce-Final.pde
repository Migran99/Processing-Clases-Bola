/* 
 Codigo original: Jose Pujol
 Modificado por: Miguel Granero Ramos
   ++Añadidos: Tabla puntuaciones, colisiones, jugador, pantallas, puntuacion, manejo de archivos, introduccion de texto, etc.
 IES Vicente Aleixandre 2017
 */
Pelota[] miPelota = new Pelota[20]; //Creamos el objeto miPelota

//Variables para el jugador
float play_posx = 0;
float play_posy = 0;
int player_radio = 12;
int vidas = 5;

//Variables para el juego
PFont font1;
int fps = 60;
int pantalla = 0;

//Contadores de tiempo y puntuacion
int puntos = 0;
int pause_time = 0;

//Creamos el objeto tabla para la tabla de puntuaciones asi como las variables que usaremos para su funcionamiento
Table score_table;
Boolean puntos_compr = false;
Boolean typing = false;
String input = "";
int typingin = 0;


void setup() {
  //Iniciamos parametros y creamos las bolas
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

  font1 = createFont("Califa-Italic-16", 16, true); //Creamos la fuente que utilizaremos

  //Comprobamos si existe el archivo scores.csv (tabla de puntuaciones). Si no, lo creamos
  if (!fileExists(sketchPath("scores.csv"))) {
    score_table = new Table();
    score_table.addColumn();
    score_table.addColumn();
    score_table.addRow();
    score_table.addRow();
    score_table.addRow();

    score_table.setString(0, 0, "Player1" );
    score_table.setString(1, 0, "Player2" );
    score_table.setString(2, 0, "Player3" );

    score_table.setInt(0, 1, 0);
    score_table.setInt(1, 1, 0);
    score_table.setInt(2, 1, 0);
    saveTable(score_table, "scores.csv");
    println("File Created");
  } else {
    println("File found");
    println("Loading File");
    score_table = loadTable("scores.csv");
  }
}

void draw() {//En funcion de la pantalla ejecutaremos un bloque u otro
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
  case 3:
    pausa();
    break;
  }
}

float distanceto(int x1, int y1, int x2, int y2) { //Para averiguar la distancia entre dos puntos
  return sqrt(sq(x1-x2) + sq(y1-y2));
}


//////////////////////Clase pelota
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
  // rebote
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
  //fusion
  void fusionar() {
    if (alive) {
      for (int i=0; i < miPelota.length; i++) {
        if (i != id) {
          if (distanceto((int)xpos, (int)ypos, (int)miPelota[i].xpos, (int)miPelota[i].ypos) < (diameter+miPelota[i].diameter)/3 && miPelota[i].alive) {
            diameter += miPelota[i].diameter/2;
            vx += miPelota[i].vx/2;
            vy += miPelota[i].vy/2;
            miPelota[i].alive = false;
          }
        }
      }
    }
  }
}
//////////////////////

void dibujar_player() { //Dibujamos al jugador
  fill(255 - vidas*20, 50, 50);
  strokeWeight(4);
  ellipse(play_posx, play_posy, 2*player_radio, 2*player_radio);
}

void mover_player() { //Movemos al jugador
  play_posx = mouseX;
  play_posy = mouseY;
}

void colision_player() { //Detectamos la colision de las bolas con el jugador
  for (int i = 0; i<miPelota.length; i++) {
    if (distanceto((int)play_posx, (int)play_posy, (int)miPelota[i].xpos, (int)miPelota[i].ypos) < (player_radio*2+miPelota[i].diameter)/2 && miPelota[i].alive) {
      println("Perdiste wey");
      miPelota[i].alive = false;
      vidas --;
      player_radio += 2;
    }
  }

  if (vidas <= 0) {
    pantalla = 2;
  }
}

void hud() { //Pintamos el HUD del juego
  textFont(font1, height/9);  //Seleccionamos la fuente del texto            
  fill(200);
  textAlign(LEFT); //La alineacion del texto con la posicion que demos
  text("Vidas:" + vidas, 0, height/9);
  textAlign(RIGHT); //La alineacion del texto con la posicion que demos
  text("Tiempo:" + puntos, width, height/9);
}

void jugar() { //Bloque para la pantalla del juego
  background(255-vidas*10, 100, 100);
  for (int i=0; i< miPelota.length; i++) {
    miPelota[i].move();
    miPelota[i].display();
    miPelota[i].rebotar();
    miPelota[i].fusionar();
  }

  dibujar_player();
  mover_player();
  colision_player();
  hud();

  textFont(font1, 16); 
  fill(200);
  textAlign(LEFT);
  text("Pulsa P para pausar", width-textWidth("Pulsa P para pausar:"), height-16);

  puntos = millis()/1000 - pause_time;
}

void menu() { //Bloque para el menu inicial
  background(75);
  textFont(font1, height/5);  //Seleccionamos la fuente del texto            
  fill(200, 100, 100);
  textAlign(CENTER); //La alineacion del texto con la posicion que demos
  text("BOUNCE", width/2, height/4); //Dibujamos el string que queramos (PONG en este caso)
  fill(200);
  strokeWeight(2);
  rect(0, height/2, width, height/6);
  textFont(font1, height/6); 
  fill(200, 100, 100);
  text("PLAY", width/2, height/2 + height/6 - height/50);
  textFont(font1, 16); 
  fill(200);
  textAlign(LEFT);
  text("Miguel Granero", width-textWidth("Miguel Granero:"), height-16);
  dibujar_player();
  mover_player();
  pause_time = millis()/1000 - puntos;
}

void perder() { //Cuando perdamos se activara este bloque
  background(75);
  if (puntos_compr) { //Si hemos comprobado puntos pintamos la tabla
    textFont(font1, height/5);        
    fill(125);
    textAlign(LEFT);
    for (int i = 0; i<3; i++) {
      text(score_table.getString(i, 0), 5, height*(i+1)/4);
    }
    fill(200);
    for (int i = 0; i<3; i++) {
      text(score_table.getInt(i, 1), 50 + textWidth(score_table.getString(i, 0)), height*(i+1)/4);
    }
  } else { //Si no, comprobamos
    comprobar_puntos();
  }
  textFont(font1, 16); 
  text("Pulsa C para salir", width-textWidth("Pulsa c para salir:"), height-16);
  if (typing) {
    textAlign(LEFT);
    text("Escribiendo...: " + input, 5, height-16); //SI estamos escribiendo lo mostramos en pantalla
  }
}

void pausa() { //Bloque para la pausa en juego
  background(255-vidas*10, 100, 100);
  dibujar_player();
  hud();
  for (int i=0; i< miPelota.length; i++) {
    miPelota[i].display();
  }

  textFont(font1, 16); 
  fill(200);
  textAlign(LEFT);
  text("El raton debe estar sobre la bola para despausar", width-textWidth("El raton debe estar sobre la bola para despausar:"), height-16);

  pause_time = millis()/1000 - puntos;
}



boolean fileExists(String path) { //Bloque para averiguar si existe un archivo
  File file=new File(path);
  println(file.getName());
  boolean exists = file.exists();
  if (exists) {
    println("true");
    return true;
  } else {
    println("false");
    return false;
  }
} 

void comprobar_puntos() { //Bloque en el comprobamos los puntos del jugador. Vemos si ha superado alguna puntuacion mejor
  if (!typing) {
    if (puntos > score_table.getInt(2, 1)) {
      if (puntos > score_table.getInt(1, 1)) {
        if (puntos > score_table.getInt(0, 1)) {
          score_table.setInt(2, 1, score_table.getInt(1, 1));
          score_table.setString(2, 0, score_table.getString(1, 0));
          score_table.setInt(1, 1, score_table.getInt(0, 1));
          score_table.setString(1, 0, score_table.getString(0, 0));
          score_table.setInt(0, 1, puntos);
          typing = true;
          typingin = 0;
        } else {
          score_table.setInt(2, 1, score_table.getInt(1, 1));
          score_table.setString(2, 0, score_table.getString(1, 0));
          score_table.setInt(1, 1, puntos);
          typing = true;
          typingin = 1;
        }
      } else {
        score_table.setInt(2, 1, puntos);
        typing = true;
        typingin = 2;
      }
    } else {
      puntos_compr = true;
    }
  }
}

void keyPressed() {
  if (!typing) { //Para la pausa y la salida
    switch(key) {
    case 'p':
      if (pantalla == 1) pantalla = 3;
      else if (pantalla ==3 && distanceto(mouseX, mouseY, (int)play_posx, (int)play_posy) < player_radio) pantalla = 1;
      break;
    case 'c':
      exit();
      break;
    }
  } else { //Para escribir nuestro nombre en la tabla de puntuaciones
    if (key==BACKSPACE) { //Podemos borrar caracteres
      if (input.length()>0) {
        input=input.substring(0, input.length()-1);
      }
    }
    else if (key==RETURN || key==ENTER) { //Finalizamos el nombre con un ENTER
      println ("ENTER");
      score_table.setString(typingin, 0, input);
      typing = false;
      input = "";
      saveTable(score_table, "scores.csv");
      puntos_compr = true;
    } else {
      input+=key;
    }
    println (input);
  }
}

void mousePressed() { //Para el boton en el menu principal de juego
  switch(pantalla) {
  case 0:
    if (mouseY < height/2 + height/6 && mouseY > height/2 && pantalla == 0) {
      pantalla=1; //Si pulsamos el boton del menu entramos al juego
    }
  }
}
