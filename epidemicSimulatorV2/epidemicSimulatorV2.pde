import java.util.Random;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

Simulation sim = new Simulation(400, 10, 0.01);

float MEAN, STD_DEV;

Random gen;

// Textbox starter number of agents

TextBox agents = new TextBox(860, 100, 125, 125, color(0), color(255));

// Textbox starter number of infected
TextBox infectats = new TextBox(1140, 100, 125, 125, color(0), color(255));

Button stop = new Button ("stop", 255, 0, 0, 760, 60, 120, 30);

Button pause = new Button ("pause", 255, 255, 0, 940, 60, 120, 30);

Button start = new Button ("start", 0, 255, 0, 1120, 60, 120, 30);

Graph infected = new Graph (740, 380, 520, 320, color(0, 0, 255, 255));

void setup() {
  size(1280, 720);

  gen = new Random();

  MEAN = 3;
  STD_DEV = 1;
  
  sim.setup();
}
void draw() {
  // Non-interactive UI
  background(255);

  sim.tick();

  fill (186, 230, 255);
  rect (720, 0, 560, 720);
  line (720, 45, 1280, 45);

  //Simulation drawing

  start.render();

  stop.render();

  pause.render();

  infected.update(300);

  infected.render();
  
  frameRateShow();
  
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
}
