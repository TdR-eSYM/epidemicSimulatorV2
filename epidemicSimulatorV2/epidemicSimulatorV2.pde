import java.util.Random;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

Simulation sim = new Simulation(400, 10, 0.01);

float MEAN, STD_DEV;

Random gen;

// Textbox starter number of agents

TextBox agentNumTextBox = new TextBox(860, 100, 125, 125, color(0), color(255));

// Textbox starter number of infected
TextBox infectats = new TextBox(1140, 100, 125, 125, color(0), color(255));

// Textbox time where vacunation starts
TextBox vacunacio = new TextBox(1045, 223, 125, 125, color(0), color(255));

Button stop = new Button ("stop", 255, 0, 0, 760, 60, 120, 30);

Button pause = new Button ("pause", 255, 255, 0, 940, 60, 120, 30);

Button start = new Button ("start", 0, 255, 0, 1120, 60, 120, 30);

Graph infected = new Graph (740, 380, 520, 320, color(200, 0, 0, 160));
Graph susceptible = new Graph (740, 380, 520, 320, color(0, 200, 0, 160));

void setup() {
  size(1280, 720);

  gen = new Random();

  agentNumTextBox.text = "400";

  MEAN = 3;
  STD_DEV = 1;
}
void draw() {
  // Non-interactive UI
  background(255);

  sim.tick();

  fill (186, 230, 255);
  rect (720, 0, 560, 720);
  line (720, 45, 1280, 45);

  //Graphs background
  fill (255);
  rect (740, 380, 520, 320);

  //Simulation drawing

  start.render();

  stop.render();

  pause.render();

  infected.update(sim.infected, sim.agentNum);
  susceptible.update(sim.agentNum-sim.infected-sim.dead-sim.immune, sim.agentNum); // This is too long, calculate inside class

  susceptible.render();
  infected.render();
  
  frameRateShow();
  
  fill(0);
  textSize (20);
  text ("Epidemic simulator V2", 890, 30);

  text ("Nº d'agents:", 740, 125);

  text ("Nº d'infectats:", 1000, 125);

  text ("Nº de morts:", 740, 165);

  text ("Nº d'infectats:", 1000, 165);
  
  text ("Nº de recuperats:", 740, 205);
  
  text ("Començament de la vacunació:", 740, 245);
  
  text ("Nº de vacunats:", 740, 285);

  text ("Stop", 800, 82);

  text ("Pause", 974, 82);

  text ("Start", 1160, 82);

  textSize (15);
  text ("Gràfic susceptibles i infectats", 750, 370);

  // Written info in console
  agentNumTextBox.render();

  infectats.render();

  println(infectats.text);
  
  vacunacio.render();
  
  println(vacunacio.text);
  
}
