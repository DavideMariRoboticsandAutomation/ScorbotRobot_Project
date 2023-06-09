/*

Funzioni SCORBOT:
    Con le frecce Giù e Su si modifica l'altezza della vista sul robot
    Con x,y,z minuscole o maiuscole si diminuiscono o aumentano le rispettive coordinate
    Con b maiuscolo o minuscolo si aumenta o diminuisce l'angolo βd desiderato
    Con w maiuscolo o minuscolo si aumenta o diminuisce l'angolo ωd desiderato
    Con i maiuscolo o minuscolo si imposta la configurazione all'indietro
    Con a maiuscolo o minuscolo si imposta la configurazione in avanti (Default
    Con c maiuscolo o minuscolo si chiude la pinza fino al blocco
    Con o maiuscolo o minuscolo si apre la pinza fino al blocco
    Con g maiuscolo o minuscolo si imposta rispettivamente la configurazione gomito alto o basso
    Con le frecce Destra e Sinistra si aumenta o diminuisce la velocità Kp con cui il robot compie i propri movimenti
*/

// parametro della funzione camera() che viene modificato con le frecce SU e GIU e determina l'altezza della vista rispetto al robot
float eyeY = 0;

//gomito alto o basso
int gomito = 1;

//configurazione all'indietro 
int indietro = 0;

// Coordinate del centro del link 0 del robot che viene spostato col mouse
float xBase;
float yBase;

//Costante legge di controllo
float Kp = 1;

// dimensioni base:
float d0_x = 80; // lungo x
float d0_y = 80; // lungo y
float d0_z = 30; // lungo z

// dimensioni link 1
float d1_x = 80; // lungo x
float d1_y = 30; // lungo y
float d1_z = 80; // lungo z

// dimensioni link 2
float d2_x = 160; // lungo x
float d2_y = 20; // lungo y
float d2_z = 20; // lungo z

// dimensioni link 3
float d3_x = 160; // lungo x
float d3_y = 20; // lungo y
float d3_z = 20; // lungo z

//dimensioni link 4
float d4_x = 20; //lungo x
float d4_y = 20; // lungo y
float d4_z = 55; // lungo z

// dimensioni pinza
float d5a_x = 30; // lungo x
float d5a_y = 50; // lungo y
float d5a_z = 30; // lungo z

//dimensioni tenaglie
float d5b_x = 10; // lungo x
float d5b_y = 10; // lungo y
float d5b_z = 25; // lungo z

float posPinza = 0;

//variabili l1, l2, l3, d1 e d5 fisse
float l1 = d0_x/2;
float l2 = d2_x;
float l3 = d3_x;
float d1 = d1_y + d2_y/2;
float d5 = d4_z + d5a_z + d5b_z;

// parametri giunto (theta1, theta2, theta3, theta4, theta5)
float[] theta = {0, 0, 0, 0, 0};

float xPolso = cos(theta[0])*(l1 + l2*cos(theta[1]) + l3*cos(theta[1]+theta[2]));
float yPolso = sin(theta[0])*(l1 + l2*cos(theta[1]) + l3*cos(theta[1]+theta[2]));
float zPolso = d1 - l2*sin(theta[1]) - l3*sin(theta[1] + theta[2]);

float xPinza = xPolso - cos(theta[0])*d5*sin(theta[1] + theta[2] + theta[3]);
float yPinza = yPolso - sin(theta[0])*d5*sin(theta[1] + theta[2] + theta[3]);
float zPinza = zPolso -d5*cos(theta[1] + theta[2] + theta[3]);


// parametri posizione desiderata {xd, yd, zd, betad, omegad}
float[] posizione = {xPinza, yPinza, zPinza, theta[1] + theta[2] + theta[3] + PI/2, theta[4]};
float theta3;

void setup()
{
  fullScreen();
  size(1000, 800, P3D);
  stroke(50);
  strokeWeight(2);
  xBase = width/2;
  yBase = height/2;
}

void draw()
{
  background(0);
  directionalLight(128, 128, 128, -1, 0, 1);
  lights();
  // Permette di ruotare la vista:
  camera((width/2.0), height/2 - eyeY, (height/2.0) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);

  if (mousePressed)
  {
    xBase = mouseX;
    yBase = mouseY;
  }
  if (keyPressed)
  {
    // movimento camera
    if (keyCode == DOWN)
    {
      eyeY -= 5;
    }
    if (keyCode == UP)
    {
      eyeY += 5;
    }
    if (key == 'x')
    {
      posizione[0] -= Kp*0.5;
      muovi();
    }
    if (key == 'X')
    {
      posizione[0] += Kp*0.5;
      muovi();
    }
    if (key == 'y')
    {
      posizione[1] -= Kp*0.5;
      muovi();
    }
    if (key == 'Y')
    {
      posizione[1] += Kp*0.5;
      muovi();
    }
    if (key == 'z')
    {
      posizione[2] -= Kp*0.5;
      muovi();
    }
    if (key == 'Z')
    {
      posizione[2] += Kp*0.5;
      muovi();
    }
    if (key == 'b')
    {
      theta3 = theta[3] - Kp*0.01;
      muovi();
    }
    if (key == 'B')
    {
      theta3 = theta[3] + Kp*0.01;;
      muovi();
    }
    if (key == 'w')
    {
      posizione[4] -= Kp*0.05;
      muovi();
    }
    if (key == 'W')
    {
      posizione[4] += Kp*0.05;
      muovi();
    }
    if (key == 'i' || key == 'I')
    {
      indietro = 1;
      muovi();
    }
    if(key == 'a' || key == 'A')
    {
      indietro = 0;
      muovi();
    }
    if (key == 'c' || key == 'C')
    {
      if (posPinza < 0)
      {
        text("non posso chiudere la pinza più di così", 0, 32*16);
        posPinza = 0;
      }
      posPinza -= 0.1;
    }
    if (key == 'o' || key == 'O')
    {
      if (posPinza > d5a_y/2 - d5b_y)
      {
        text("non posso aprire la pinza più di così", 0, 32*16);
        posPinza = d5a_y/2 - d5b_y;
      }
      posPinza += 0.1;
    }
    if (key == 'g')
    {
      gomito = -1;
      muovi();
    }
    if (key == 'G')
    {
      gomito = 1;
      muovi();
    }
    if (keyCode == LEFT)
    {
      if(Kp < 0.08)
      {
        Kp = 0.08;
      }
      Kp -= 0.08;
    }
    if (keyCode == RIGHT)
    {
      if(Kp > 3)
      {
        Kp = 3;
      }
      Kp += 0.08;   
    }
  }

  pushMatrix();
  //disegno lo SCORBOT
  fill(0, 255, 0); //colore robot

  //link 0 (base)
  translate(xBase, yBase);
  rotateX(-PI/2);  //metto il SR con z che punta verso l'alto x verso destra e y entrante

  pushMatrix();              //disegno asse X terna di base
  translate(50, 0, 0);
  box(100, 5, 5);
  textSize(32);
  text("x0", 20, -10, 0);
  fill(255, 0, 0);
  popMatrix();

  pushMatrix();              //disegno asse Z terna di base
  translate(0, 0, -50);
  box(5, 5, 100);
  rotateX(PI/2);
  textSize(32);
  text("z0", 5, -40, 0);
  fill(255, 255, 0);
  popMatrix();

  pushMatrix();              // disegno asse Y terna di base
  translate(0,50,0);
  box(5, 100, 5);
  rotateX(PI);
  textSize(32);
  text("y0", 5, -40, 0);
  fill(0, 0, 255);
  popMatrix();

  box(d0_x, d0_y, d0_z);

  //link 1
  rotateX(PI/2);  //metto il SR come sulle dispense
  translate(0, -d0_z/2 -d1_y/2, 0);
  rotateY(theta[0]); //dal momento che ho spostato il SR ruoto attorno all'asse y
  box(d1_x, d1_y, d1_z);

  //giunto 1
  translate(d1_x/2, -d1_y/2 -d2_y/2, 0);
  sphere(15);
  rotateZ(theta[1]);  //ruota con angolo pari a theta 2

  //link 2
  translate(d2_x/2, 0, 0);
  box(d2_x, d2_y, d2_z);

  //giunto 2
  translate(d2_x/2, 0, 0);
  sphere(15);

  //link 3
  rotateZ(theta[2]);
  translate(d3_x/2, 0, 0);
  box(d3_x, d3_y, d3_z);

  //giunto 3
  translate(d3_x/2, 0, 0);
  sphere(15);

  //link 4
  rotateY(PI/2);
  rotateZ(PI/2);
  rotateY(theta[3]);
  translate(0, 0, d4_z/2);
  box(d4_x, d4_y, d4_z);

  //pinza
  rotateZ(theta[4]);
  translate(0, 0, d4_z/2 + d5a_z/2);
  box(d5a_x, d5a_y, d5a_z);

  //tenaglie
  translate(0, 0, d5a_z/2 + d5b_z/2);

  pushMatrix();   
  fill(0, 255, 0);           //disegno asse X terna pinza
  translate(-50, 0, 0);
  box(100, 5, 5);
  rotateX(PI/2);
  rotateY(PI);
  rotateZ(PI/2);
  textSize(32);
  text("x5", 5, -40, 0);
  fill(255, 0, 0);
  popMatrix();

  pushMatrix();              //disegno asse Z terna pinza
  translate(0, 0, 50);
  box(5, 5, 100);
  rotateY(-PI/2);
  textSize(32);
  text("z5", 40, -10, 0);
  fill(255, 255, 0);
  popMatrix();

  pushMatrix();              //disegno asse Y terna pinza
  translate(0,50,0);
  box(5, 100, 5);
  rotateY(-PI/2);
  textSize(32);
  text("y5", 5, 40, 0);
  fill(0, 0, 255);
  popMatrix();

  pushMatrix();
  translate(0, -d5b_y/2 - posPinza, 0);
  box(d5b_x, d5b_y, d5b_z);
  popMatrix();
  translate(0, d5b_y/2 + posPinza, 0);
  box(d5b_x, d5b_y, d5b_z);

  popMatrix();


  //Parte di testo a schermo
  fill(0, 255, 0);
  textSize(32);
  text("ϑ1 = ", 0, 32);
  text(theta[0]*(180/PI), 60, 32);
  textSize(32);
  text("ϑ2 = ", 0, 64);
  text(theta[1]*(180/PI), 60, 64);
  text("ϑ3 = ", 0, 96);
  text(theta[2]*(180/PI), 60, 96);
  text("ϑ4 = ", 0, 128);
  text(theta[3]*(180/PI) - 90, 60, 128);
  text("ϑ5 = ", 0, 160);
  text(theta[4]*(180/PI), 60, 160);
  text("xD = ", 0, 192);
  text(posizione[0], 60, 192);
  text("yD = ", 0, 32*7);
  text(posizione[1], 60, 32*7);
  text("zD = ", 0, 32*8);
  text(posizione[2] + 120, 60, 32*8);
  text("βd = ", 0, 32*9);
  text((theta[3]*180/PI), 60, 32*9);
  text("ωd = ", 0, 32*10);
  text(posizione[4], 60, 32*10); 
   text("Kp = ", 0, 32*11);
  text(Kp, 60, 32*11);

  fill(0,255,255);
  text("R(0,5)= ",0, 32*13);
  text(-(-cos(theta[0])*sin(theta[1]+theta[2]+theta[3])), 110, 32*12);
  text((-sin(theta[0])*sin(theta[1]+theta[2]+theta[3])), 110, 32*13);
  text(-(-cos(theta[1]+theta[2]+theta[3])), 110, 32*14);
  text(-(-cos(theta[0])*cos(theta[1]+theta[2]+theta[3])*sin(theta[4]) + sin(theta[0])*cos(theta[4])), 230, 32*12);
  text((-sin(theta[0])*cos(theta[1]+theta[2]+theta[3])*sin(theta[4]) - cos(theta[0])*cos(theta[4])), 230, 32*13);
  text((sin(theta[1]+theta[2]+theta[3])*sin(theta[4])), 230, 32*14);
  text((cos(theta[0])*cos(theta[1]+theta[2]+theta[3])*cos(theta[4]) + sin(theta[0])*sin(theta[4])), 350, 32*12);
  text((sin(theta[0])*cos(theta[1]+theta[2]+theta[3])*cos(theta[4]) + cos(theta[0])*sin(theta[4])), 350, 32*13);
  text((-sin(theta[1]+theta[2]+theta[3])*cos(theta[4])), 350, 32*14);
  fill(255, 0, 255);

  if(gomito == 1)
  {
    text("Gomito alto", 0, 32*15);
  }
  else
  {
    text("Gomito basso", 0, 32*15);
  }
  fill(255, 255, 0);
  if(indietro == 1)
  {
    text("Configurazione all'indietro", 0, 32*17);
  }
  else
  {
    text("Configurazione in avanti", 0, 32*17);
  }
}

void muovi()
{
  float A1 = posizione[0]*cos(theta[0]) + posizione[1]*sin(theta[0]) - d5*cos(posizione[3]) - l1;
  float A2 = d1 - posizione[2] - d5*sin(posizione[3]);
  float argcos = (A1*A1 + A2*A2 - l2*l2 -l3*l3)/(2*l2*l3);
  if (argcos < -1 || argcos > 1)
  {
    textSize(25);
    fill(256, 0, 0);
    text("posizione fuori dello spazio di lavoro", 80, 400);
  } 
  else
  {
    if(indietro == 0)
    {
      if(gomito == 1)
      {
        //Calcolo Theta_1
        theta[0] = (atan2(posizione[1], posizione[0]));

        //Calcolo Theta_3
        theta[2] = (acos(argcos));

        //Calcolo Theta_2
        theta[1] = (atan2((l2+l3*cos(theta[2]))*A2 - l3*sin(theta[2])*A1, (l2+l3*cos(theta[2]))*A1 + l3*sin(theta[2])*A2));

        //Calcolo Theta_4
        theta[3] = theta3;

        //Calcolo Theta_5
        theta[4] = posizione[4];
      }
      if(gomito == -1)
      {
        //Calcolo Theta_1
        theta[0] = (atan2(posizione[1], posizione[0]));

        //Calcolo Theta_3
        theta[2] = -(acos(argcos));

        //Calcolo Theta_2
        theta[1] = (atan2((l2+l3*cos(theta[2]))*A2 - l3*sin(theta[2])*A1, (l2+l3*cos(theta[2]))*A1 + l3*sin(theta[2])*A2));

        //Calcolo Theta_4
        theta[3] = theta3;

        //Calcolo Theta_5
        theta[4] = posizione[4];
      }
    }
    if(indietro == 1)
    {
      if(gomito == -1)
      {
        //Calcolo Theta_1
        theta[0] = PI + (atan2(posizione[1], posizione[0]));

        //Calcolo Theta_3
        theta[2] = (acos(argcos));

        //Calcolo Theta_2
        theta[1] = (atan2((l2+l3*cos(theta[2]))*A2 - l3*sin(theta[2])*A1, (l2+l3*cos(theta[2]))*A1 + l3*sin(theta[2])*A2));

       //Calcolo Theta_4
        theta[3] = -theta3;

       //Calcolo Theta_5
       theta[4] = posizione[4] + PI;
      }
      if(gomito == 1)
      {
        //Calcolo Theta_1
        theta[0] = PI + (atan2(posizione[1], posizione[0]));

        //Calcolo Theta_3
        theta[2] = -(acos(argcos));

        //Calcolo Theta_2
        theta[1] = (atan2((l2+l3*cos(theta[2]))*A2 - l3*sin(theta[2])*A1, (l2+l3*cos(theta[2]))*A1 + l3*sin(theta[2])*A2));

        //calcolo Theta_4
        theta[3] = -theta[3];

        //Calcolo Theta_5
        theta[4] = posizione[4] + PI;
      }
    }
  }  
}

//////////////////////////////FUNZIONI AUSILIARIE///////////////////////////////////

float[][] trasposta(float[][] A) // Calcola la trasposta di una matrice A
{
  int nR = A.length;
  int nC = A[0].length; 

  float[][] C = new float[nC][nR]; 

  for (int i=0; i < nC; i++) 
  {
    for (int j=0; j < nR; j++) 
    {  
      C[i][j] = A[j][i];
    }
  }
  return C;
};

//-----------
float[][] mProd(float[][] A,float[][] B) // Calcola prodotto di due matrici A e B
{
  int nA = A.length;
  int nAB = A[0].length;
  int nB = B[0].length;

  float[][] C = new float[nA][nB]; 

  for (int i=0; i < nA; i++) 
  {
    for (int j=0; j < nB; j++) 
    {  
      for (int k=0; k < nAB; k++) 
      {
        C[i][j] += A[i][k] * B[k][j];
      }
    }
  }
  return C;
}

//-----------
void scriviMatrice(String s, float[][] M, int x, int y) // Scrive una matrice a partire dal punto (x,y)
{
  textSize(20);
  fill(255);
  text(s,x,y);
  fill(255,0,0);
  text(M[0][0],x,y+30); text(M[1][0],x,y+60); text(M[2][0],x,y+90);              
  fill(0,255,0);
  text(M[0][1],x+90,y+30); text(M[1][1],x+90,y+60); text(M[2][1],x+90,y+90);                               
  fill(0,0,255);
  text(M[0][2],x+180,y+30); text(M[1][2],x+180,y+60); text(M[2][2],x+180,y+90);
}  


//------------
void cilindro()
{
  pushMatrix();
  noStroke();
  rotateX(PI/2);

  float angoli;
  float x[] = new float[lati+1];
  float z[] = new float[lati+1];

  float x2[] = new float[lati+1];
  float z2[] = new float[lati+1];

  //get the x and z position on a circle for all the sides
  for(int i=0; i < x.length; i++){
    angoli = 2*PI / (lati) * i;
    x[i] = sin(angoli) * bottom;
    z[i] = cos(angoli) * bottom;
  }

  for(int i=0; i < x.length; i++){
    angoli = TWO_PI / (lati) * i;
    x2[i] = sin(angoli) * top;
    z2[i] = cos(angoli) * top;
  }

  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN);

  vertex(0,   -h/2,    0);

  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
  }

  endShape();

  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 

  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
    vertex(x2[i], h/2, z2[i]);
  }

  endShape();

  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN); 

  vertex(0,   h/2,    0);

  for(int i=0; i < x.length; i++){
    vertex(x2[i], h/2, z2[i]);
  }

  endShape();
  stroke(255);
  strokeWeight( 1);
  popMatrix();
}
