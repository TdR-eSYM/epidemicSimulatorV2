import java.util.Random;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

Simulation sim = new Simulation(400, 10, 20, 1, 3, true);

Random gen;

// Textbox starter number of agents

TextBox suceptibleNumTB = new TextBox(760, 140, 125, 31, color(255), color(120), false);

// Textbox starter number of infected
TextBox infectedNumTB = new TextBox(930, 140, 125, 31, color(255), color(120), false);

// Textbox time where vacunation starts
TextBox agentsNumTB = new TextBox(1095, 140, 125, 31, color(255), color(120), true);

TextBox renderLenTB = new TextBox(760, 220, 125, 31, color(255), color(120), false);

TextBox agentSizeTB = new TextBox(760, 220, 60, 31, color(255), color(120), false);

TextBox agentWalkSTD_DEV = new TextBox(760, 220, 60, 31, color(255), color(120), false);

TextBox agentWalkMEAN = new TextBox(760, 220, 60, 31, color(255), color(120), false);

TextBox agentWalkSPEED = new TextBox(760, 220, 60, 31, color(255), color(120), false);

TextBox agentWalkANGLECHG = new TextBox(760, 220, 60, 31, color(255), color(120), false);

TextBox[] textBoxes = {suceptibleNumTB, infectedNumTB, agentsNumTB, renderLenTB, agentSizeTB, agentWalkSTD_DEV, agentWalkMEAN, agentWalkSPEED, agentWalkANGLECHG};

Button stop = new Button ("stop", 225, 0, 0, 760, 60, 120, 30, true);

Button pause = new Button ("pause", 220, 169, 10, 940, 60, 120, 30, true);

Button start = new Button ("start", 0, 225, 0, 1120, 60, 120, 30, false);

Button walkerBtn = new Button ("agentSettings", 0, 120, 200, 760, 300, 120, 30, false);
Button engineBtn = new Button ("engineSettings", 105, 203, 50, 940, 300, 120, 30, false);
Button toolsBtn = new Button ("simTools", 225, 155, 25, 1120, 300, 120, 30, false);

Button[] buttons = {stop, pause, start, walkerBtn, engineBtn, toolsBtn};

Graph infected = new Graph (740, 380, 520, 320, color(200, 0, 0, 160), true);
Graph susceptible = new Graph (740, 380, 520, 320, color(0, 200, 0, 160), true);
Graph recovered = new Graph (740, 380, 520, 320, color(0, 0, 255), false);
Graph dead = new Graph (740, 380, 520, 320, color(0, 0, 0), false);

CheckBox renderEngineCheck = new CheckBox(740, 280, 20, 20, color(230), color(0, 230, 0), false);
CheckBox graphsEngineCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);
CheckBox gaussianMovementCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);
CheckBox switchCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);

CheckBox[] checkboxes = {renderEngineCheck, graphsEngineCheck, gaussianMovementCheck, switchCheck};

Window engineWindow, agentsWindow, toolsWindow;

JSONObject config;

void setup() {
  size(1280, 720);

  gen = new Random();

  loadConfig();

  engineWindow = new Window("Engine Settings", width/2-250, 20, 300, 200, color(80), color(50));

  agentsWindow = new Window("Agent Settings", width/2-250, 260, 300, 300, color(80), color(50));
  
  toolsWindow = new Window("Simulation Tools", width/2-250, 260, 300, 300, color(80), color(50));
}

void exit() {
  //put code to run on exit here
  super.exit();
  saveConfig();
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
  if (!graphsEngineCheck.pressed) {
    fill(255);
    rect (740, 380, 520, 320);
  } else {
    fill(80, 50, 50);
    rect (740, 380, 520, 320);

    fill(130, 90, 90);
    textSize(40);
    text("DISABLED", 899, 540);
  }

  //Simulation drawing

  start.render();

  stop.render();

  pause.render();

  walkerBtn.render();

  engineBtn.render();
  
  toolsBtn.render();

  if (!graphsEngineCheck.pressed) {
    infected.update(sim.infected, sim.agentNum);
    susceptible.update(sim.agentNum-sim.infected-sim.dead-sim.immune, sim.agentNum); // This is too long, calculate inside class
    recovered.update(sim.immune, sim.agentNum);
    dead.update(sim.dead, sim.agentNum);

    susceptible.render();
    infected.render();
    recovered.render();
    dead.render();
  }

  frameRateShow();

  fill(255);
  textSize (20);
  text ("Epidemic simulator V2", 890, 30);

  textSize(16);

  text ("Susceptible:", 770, 125);

  text ("Infected:", 956, 125);

  text ("Total agents:", 1106, 125);

  if (renderEngineCheck.pressed) {
    text ("Length:", 764, 212);
    renderLenTB.render();
    textSize(18);
    if (sim.state == SimStates.RUNNING) text("T: " + sim.frameNum + "/" + renderLenTB.text + " f", 1140, 29);
  } else {
    if (sim.state == SimStates.RUNNING) text("T: " + int((millis() - sim.startTime)/1000) + " s", 1200, 29);
  }

  textSize (18);

  text ("Stop", 800, 82);

  if (sim.state == SimStates.PAUSED) {
    text ("Unpause", 965, 82);
  } else {
    text ("Pause", 974, 82);
  }

  text ("Start", 1160, 82);

  text ("Agents", 790, 322);

  text ("Engine", 972, 322);
  
  text ("Tools", 1155, 322);

  textSize (15);
  text ("Gràfic susceptibles i infectats:", 750, 370);
  // Written info in console
  suceptibleNumTB.render();

  infectedNumTB.render();

  if (sim.state == SimStates.PAUSED) {
    fill(0, 50);
    noStroke();
    rect(width/4.5, height/3.2, 40, 200);
    rect(width/3.5, height/3.2, 40, 200);
    stroke(30); // Restore stroke
  }

  if (sim.state == SimStates.STOPPED) {
    sim.infected = int(infectedNumTB.text);
    sim.agentNum = int(suceptibleNumTB.text) + sim.infected;
    sim.renderLength = int(renderLenTB.text);
  } else {
    infectedNumTB.text = str(sim.infected);
    suceptibleNumTB.text = str(sim.agentNum - sim.infected - sim.immune - sim.dead);
  }

  agentsNumTB.text = str(sim.agentNum);
  agentsNumTB.render();

  engineWindow.render();
  agentsWindow.render();
  toolsWindow.render();
  
  if (engineWindow.open) {
    int x = engineWindow.x;
    int y = engineWindow.y;
    text("Render Engine: ", x+20, y+60);
    text("Disable Graphs: ", x+20, y+98);

    renderEngineCheck.x = x + 240;
    renderEngineCheck.y = y + 44;

    graphsEngineCheck.x = x + 240;
    graphsEngineCheck.y = y + 82;

    renderEngineCheck.render();
    graphsEngineCheck.render();
  }

  if (agentsWindow.open) {
    int x = agentsWindow.x;
    int y = agentsWindow.y;

    text("Agent size: ", x+20, y+62);

    text("Gaussian Movement: ", x+20, y+112);

    text("Fixed Movement: ", x+20, y+212);

    textSize(14);

    text("STD_DEV", x+21, y+140);
    text("MEAN", x+111, y+140);

    text("SPEED", x+28, y+240);
    text("ANGLE CHG", x+95, y+240);

    agentSizeTB.x = x + 210;
    agentSizeTB.y = y + 42;
    agentSizeTB.render();


    if (gaussianMovementCheck.pressed) {
      agentWalkSTD_DEV.blocked = false;
      agentWalkMEAN.blocked = false;

      agentWalkSPEED.blocked = true;
      agentWalkANGLECHG.blocked = true;
    } else {
      agentWalkSTD_DEV.blocked = true;
      agentWalkMEAN.blocked = true;

      agentWalkSPEED.blocked = false;
      agentWalkANGLECHG.blocked = false;
    }

    agentWalkSTD_DEV.x = x + 20;
    agentWalkSTD_DEV.y = y + 150;
    agentWalkSTD_DEV.render();

    agentWalkMEAN.x = x + 100;
    agentWalkMEAN.y = y + 150;
    agentWalkMEAN.render();

    agentWalkSPEED.x = x + 20;
    agentWalkSPEED.y = y + 250;
    agentWalkSPEED.render();

    agentWalkANGLECHG.x = x + 100;
    agentWalkANGLECHG.y = y + 250;
    agentWalkANGLECHG.render();

    switchCheck.x = x + 240;
    switchCheck.y = y + 195;
    switchCheck.render();

    gaussianMovementCheck.x = x + 240;
    gaussianMovementCheck.y = y + 96;
    gaussianMovementCheck.render();
    
    UpdateSimConfig();
  }
  if (toolsWindow.open) {
    int x = engineWindow.x;
    int y = engineWindow.y;
    text("Render Engine: ", x+20, y+60);
    text("Disable Graphs: ", x+20, y+98);

    renderEngineCheck.x = x + 240;
    renderEngineCheck.y = y + 44;

    graphsEngineCheck.x = x + 240;
    graphsEngineCheck.y = y + 82;

    renderEngineCheck.render();
    graphsEngineCheck.render();
  }
}
