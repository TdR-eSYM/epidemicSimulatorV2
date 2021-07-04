import java.util.Random;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

float MEAN, STD_DEV;

Random gen;

Walker[] walkers;

// Textbox starter number of agents

TextBox agents = new TextBox(860, 100, 125, 125, color(0), color(255));

// Textbox starter number of infected
TextBox infectats = new TextBox(1140, 100, 125, 125, color(0), color(255));

Button stop = new Button (255, 0, 0, 760, 60, 120, 30);

Button pause = new Button (255, 255, 0, 940, 60, 120, 30);

Button start = new Button (0, 255, 0, 1120, 60, 120, 30);

Graph infected = new Graph (740, 380, 520, 320, color(0, 0, 255, 255));

void setup() {
  size(1280, 720);

  gen = new Random();

  spawnWalkers(400, 10, 0.01);

  MEAN = 3;
  STD_DEV = 1;
}
void draw() {
  // Non-interactive UI
  background(255);
  fill (186, 230, 255);
  rect (720, 0, 560, 720);
  line (720, 45, 1280, 45);

  start.render();

  stop.render();

  pause.render();

  infected.update(300);

  infected.render();

  fill(0);
  textSize (20);
  text ("Epidemic simulator V2", 890, 30);

  text ("Nº d'agents:", 740, 125);

  text ("Nº d'infectats:", 1000, 125);

  text ("Nº de morts:", 740, 165);

  text ("Nº de recuperats:", 1000, 165);

  text ("Stop", 800, 82);

  text ("Pause", 974, 82);

  text ("Start", 1160, 82);

  textSize (15);
  text ("Gràfic susceptibles i infectats", 750, 370);

  // Written info in console
  agents.render();

  println(agents.text);

  infectats.render();

  println(infectats.text);

  //Simulation drawing

  for (int i = 0; i < walkers.length; i++) {
    walkers[i].step();
    walkers[i].outcome(0.01, 0.001);
    walkers[i].infect(1/frameRate);
    walkers[i].render();
  }
}
