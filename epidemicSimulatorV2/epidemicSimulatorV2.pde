import java.util.Random;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

Simulation sim = new Simulation(400, 10, 20);

float MEAN, STD_DEV;

Random gen;

// Textbox starter number of agents

TextBox suceptibleNumTB = new TextBox(760, 140, 125, 125, color(255), color(120), false);

// Textbox starter number of infected
TextBox infectedNumTB = new TextBox(930, 140, 125, 125, color(255), color(120), false);

// Textbox time where vacunation starts
TextBox agentsNumTB = new TextBox(1095, 140, 125, 125, color(255), color(120), true);

TextBox[] textBoxes = {suceptibleNumTB, infectedNumTB, agentsNumTB};

Button stop = new Button ("stop", 255, 0, 0, 760, 60, 120, 30);

Button pause = new Button ("pause", 250, 199, 10, 940, 60, 120, 30);

Button start = new Button ("start", 0, 255, 0, 1120, 60, 120, 30);

Graph infected = new Graph (740, 380, 520, 320, color(200, 0, 0, 160), true);
Graph susceptible = new Graph (740, 380, 520, 320, color(0, 200, 0, 160), true);
Graph recovered = new Graph (740, 380, 520, 320, color(0, 0, 255), false);
Graph dead = new Graph (740, 380, 520, 320, color(0, 0, 0), false);

void setup() {
  size(1280, 720);

  gen = new Random();

  suceptibleNumTB.text = "400";
  infectedNumTB.text = "20";
  
  MEAN = 3;
  STD_DEV = 1;
}
void draw() {
  // Non-interactive UI
  background(255);

  sim.tick();

  stroke(30);
  fill(62);
  rect(720, 0, 560, 720);
  fill(82);
  rect(730, 100, 540, 250);
  stroke(200);
  line (720, 45, 1280, 45);
  stroke(30);

  //Graphs background
  fill (255);
  rect (740, 380, 520, 320);

  //Simulation drawing

  start.render();

  stop.render();

  pause.render();

  infected.update(sim.infected, sim.agentNum);
  susceptible.update(sim.agentNum-sim.infected-sim.dead-sim.immune, sim.agentNum); // This is too long, calculate inside class
  recovered.update(sim.immune, sim.agentNum);
  dead.update(sim.dead, sim.agentNum);
  
  susceptible.render();
  infected.render();
  recovered.render();
  dead.render();
  
  frameRateShow();

  fill(255);
  textSize (20);
  text ("Epidemic simulator V2", 890, 30);

  textSize(16);

  text ("Susceptibles:", 760, 125);

  text ("Infectats:", 950, 125);

  text ("Agents totals:", 1100, 125);

  textSize (18);

  text ("Stop", 800, 82);

  text ("Pause", 974, 82);

  text ("Start", 1160, 82);

  textSize (15);
  text ("Gràfic susceptibles i infectats:", 750, 370);
  // Written info in console
  suceptibleNumTB.render();

  infectedNumTB.render();

  if(sim.state == SimStates.PAUSED){
    fill(0, 50);
    noStroke();
    rect(width/4.5, height/3.2, 40, 200);
    rect(width/3.5, height/3.2, 40, 200);
  }

  if (sim.state == SimStates.STOPPED) {
    sim.infected = int(infectedNumTB.text);
    sim.agentNum = int(suceptibleNumTB.text) + sim.infected;
  } else {
    infectedNumTB.text = str(sim.infected);
    suceptibleNumTB.text = str(sim.agentNum - sim.infected - sim.immune - sim.dead);
  }
  
  agentsNumTB.text = str(sim.agentNum);
  agentsNumTB.render();
}
