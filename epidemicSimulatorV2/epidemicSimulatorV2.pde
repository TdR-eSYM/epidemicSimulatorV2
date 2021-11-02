import java.util.Random;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import javax.swing.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

Simulation sim = new Simulation(400, 10, 20, 1, 3, true);

Random gen;

// Textbox starter number of agents

TextBox suceptibleNumTB = new TextBox(760, 140, 125, 31, color(255), color(120), false, false);

// Textbox starter number of infected
TextBox infectedNumTB = new TextBox(930, 140, 125, 31, color(255), color(120), false, false);

// Textbox time where vacunation starts
TextBox agentsNumTB = new TextBox(1095, 140, 125, 31, color(255), color(120), true, false);

TextBox renderLenTB = new TextBox(760, 220, 125, 31, color(255), color(120), false, false);

TextBox agentSizeTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox agentWalkSTD_DEV = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox agentWalkMEAN = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox agentWalkSPEED = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox agentWalkANGLECHG = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox distanceTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox toughnessTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, true);

TextBox reactionTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox infChanceTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, true);

TextBox deathChanceTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, true);

TextBox recChanceTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, true);

TextBox testRelaiabilityTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, true);

TextBox testDelayTB = new TextBox(760, 220, 60, 31, color(255), color(120), false, false);

TextBox[] textBoxes = {
  suceptibleNumTB, 
  infectedNumTB, 
  agentsNumTB, 
  renderLenTB, 
  agentSizeTB, 
  agentWalkSTD_DEV, 
  agentWalkMEAN, 
  agentWalkSPEED, 
  agentWalkANGLECHG, 
  distanceTB, 
  toughnessTB, 
  reactionTB, 
  infChanceTB, 
  deathChanceTB, 
  recChanceTB,
  testRelaiabilityTB,
  testDelayTB
};

Button stop = new Button ("stop", 225, 0, 0, 760, 60, 120, 30, true);

Button pause = new Button ("pause", 220, 169, 10, 940, 60, 120, 30, true);

Button start = new Button ("start", 0, 225, 0, 1120, 60, 120, 30, false);

Button walkerBtn = new Button ("agentSettings", 0, 120, 200, 760, 300, 120, 30, false);
Button engineBtn = new Button ("engineSettings", 105, 203, 50, 940, 300, 120, 30, false);
Button toolsBtn = new Button ("simTools", 225, 155, 25, 1120, 300, 120, 30, false);

Button[] buttons = {stop, pause, start, walkerBtn, engineBtn, toolsBtn};

Graph infectedGraph = new Graph (740, 380, 520, 320, color(200, 0, 0, 160), true);
Graph susceptibleGraph = new Graph (740, 380, 520, 320, color(0, 200, 0, 160), true);
Graph recoveredGraph = new Graph (740, 380, 520, 320, color(0, 0, 255), false);
Graph deadGraph = new Graph (740, 380, 520, 320, color(0, 0, 0), false);

CheckBox renderEngineCheck = new CheckBox(740, 280, 20, 20, color(230), color(0, 230, 0), false);
CheckBox graphsEngineCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);
CheckBox gaussianMovementCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);
CheckBox switchCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);
CheckBox socialDistancingCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);
CheckBox testingCheck = new CheckBox(740, 290, 20, 20, color(230), color(0, 230, 0), false);

CheckBox[] checkboxes = {renderEngineCheck, graphsEngineCheck, gaussianMovementCheck, switchCheck, socialDistancingCheck, testingCheck};

Window engineWindow, agentsWindow, toolsWindow;

JSONObject config;

void setup() {
  size(1280, 720);

  gen = new Random();

  loadConfig();

  engineWindow = new Window("Engine Settings", width/2-250, 20, 300, 200, color(80), color(50));

  agentsWindow = new Window("Agent Settings", width/2-250, 260, 300, 400, color(80), color(50));

  toolsWindow = new Window("Simulation Tools", width/2-610, 20, 300, 300, color(80), color(50));
}

void draw() {
  // Non-interactive UI
  background(255);
  sim.tick();
  sim.renderUI();
}

void exit() {
  //put code to run on exit here
  super.exit();
  saveConfig();
}
