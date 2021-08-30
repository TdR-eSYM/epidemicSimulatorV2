void loadConfig() {
  try {
    config = loadJSONObject(dataPath("settings.json"));
    renderEngineCheck.pressed = config.getBoolean("renderEngine");
    graphsEngineCheck.pressed = config.getBoolean("disableGraphs");
    gaussianMovementCheck.pressed = config.getBoolean("gaussMov");
    socialDistancingCheck.pressed = config.getBoolean("socialDist");
    testingCheck.pressed = config.getBoolean("infTesting");
    suceptibleNumTB.text = config.getString("susceptibleNum");
    infectedNumTB.text = config.getString("infectedNum");
    renderLenTB.text = config.getString("renderLen");
    agentSizeTB.text = config.getString("agentSize");
    agentWalkSTD_DEV.text = config.getString("STD_DEV");
    agentWalkMEAN.text = config.getString("MEAN");
    agentWalkSPEED.text = config.getString("fixedSpeed");
    agentWalkANGLECHG.text = config.getString("angleChange");
    distanceTB.text = config.getString("sDistance");
    toughnessTB.text = config.getString("sToughness");
    reactionTB.text = config.getString("sReaction");
    infChanceTB.text = config.getString("infChance");
    deathChanceTB.text = config.getString("deathChance");
    recChanceTB.text = config.getString("recChance");
    testRelaiabilityTB.text = config.getString("testRela");
    testDelayTB.text = config.getString("testDelay");
    
    // Special dummy checkbox logic
    if (!gaussianMovementCheck.pressed) {
      switchCheck.pressed = true;
    }
    UpdateSimConfig();
  } 
  catch (Exception e) {
    config = new JSONObject();
    gaussianMovementCheck.pressed = true;
    suceptibleNumTB.text = "400";
    infectedNumTB.text = "20";
    renderLenTB.text = "10";
    agentSizeTB.text = "10";
    agentWalkSTD_DEV.text = "1";
    agentWalkMEAN.text = "3";
    agentWalkSPEED.text = "1";
    agentWalkANGLECHG.text = "10";
    distanceTB.text = "2";
    toughnessTB.text = "50";
    reactionTB.text = "3";
    infChanceTB.text = "20";
    deathChanceTB.text = "30";
    recChanceTB.text = "50";
    testRelaiabilityTB.text = "70";
    testDelayTB.text = "5";
  }
}

void UpdateSimConfig() {
  sim.agentSize = int(agentSizeTB.text);
  sim.STD_DEV = int(agentWalkSTD_DEV.text);
  sim.MEAN = int(agentWalkMEAN.text);
  sim.fixedSpeed = int(agentWalkSPEED.text);
  sim.maxAngleChange = int(agentWalkANGLECHG.text);
  sim.infProb = int(infChanceTB.text);
  sim.deathProb = int(deathChanceTB.text);
  sim.recProb = int(recChanceTB.text);

  sim.sDistance = int(distanceTB.text);
  sim.sToughness = int(toughnessTB.text);
  sim.sReaction = int(reactionTB.text);
  sim.gMovement = gaussianMovementCheck.pressed;
  sim.testRelaiability = int(testRelaiabilityTB.text);
  sim.testDelay = int(testDelayTB.text);
}

void saveConfig() {
  config.setBoolean("renderEngine", renderEngineCheck.pressed);
  config.setBoolean("disableGraphs", graphsEngineCheck.pressed);
  config.setBoolean("gaussMov", gaussianMovementCheck.pressed);
  config.setBoolean("socialDist", socialDistancingCheck.pressed);
  config.setBoolean("infTesting", testingCheck.pressed);
  config.setString("susceptibleNum", suceptibleNumTB.text);
  config.setString("infectedNum", infectedNumTB.text);
  config.setString("renderLen", renderLenTB.text);
  config.setString("agentSize", agentSizeTB.text);
  config.setString("STD_DEV", agentWalkSTD_DEV.text);
  config.setString("MEAN", agentWalkMEAN.text);
  config.setString("fixedSpeed", agentWalkSPEED.text);
  config.setString("angleChange", agentWalkANGLECHG.text);
  config.setString("sDistance", distanceTB.text);
  config.setString("sToughness", toughnessTB.text);
  config.setString("sReaction", reactionTB.text);
  config.setString("infChance", infChanceTB.text);
  config.setString("deathChance", deathChanceTB.text);
  config.setString("recChance", recChanceTB.text);
  config.setString("testRela", testRelaiabilityTB.text);
  config.setString("testDelay", testDelayTB.text);
    
  saveJSONObject(config, dataPath("settings.json"));
}

void frameRateShow() {
  int fps = round(frameRate);
  if (fps <= 30 && fps > 15) {
    fill(235, 235, 0);
  } else if (fps <= 15) {
    fill(255, 0, 0);
  } else {
    fill(0, 225, 0);
  }

  textSize(18);
  text("FPS: " + fps, 740, 30);
}

void unfocusAllTexboxes(TextBox[] t) {
  for (int i = 0; i < t.length; i++) {
    t[i].focus = false;
  }
}

// https://forum.processing.org/two/discussion/27473/paste-and-copy-text
String GetTextFromClipboard () {
  String text = (String) GetFromClipboard(DataFlavor.stringFlavor);
  if (text==null) 
    return "";
  return text;
}

Object GetFromClipboard (DataFlavor flavor) {

  Clipboard clipboard = getJFrame(getSurface()).getToolkit().getSystemClipboard();

  Transferable contents = clipboard.getContents(null);
  Object object = null; // the potential result 

  if (contents != null && contents.isDataFlavorSupported(flavor)) {
    try
    {
      object = contents.getTransferData(flavor);
    }
    catch (UnsupportedFlavorException e1) // Unlikely but we must catch it
    {
      println("Clipboard.GetFromClipboard() >> Unsupported flavor: " + e1);
      e1.printStackTrace();
    }
    catch (java.io.IOException e2)
    {
      println("Clipboard.GetFromClipboard() >> Unavailable data: " + e2);
      e2.printStackTrace() ;
    }
  }
  return object;
}

static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}
