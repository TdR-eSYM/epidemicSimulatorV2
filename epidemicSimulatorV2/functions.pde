void loadConfig() {
  try {
    config = loadJSONObject(dataPath("settings.json"));
    renderEngineCheck.pressed = config.getBoolean("renderEngine");
    graphsEngineCheck.pressed = config.getBoolean("disableGraphs");
    suceptibleNumTB.text = config.getString("susceptibleNum");
    infectedNumTB.text = config.getString("infectedNum");
    renderLenTB.text = config.getString("renderLen");
  } 
  catch (NullPointerException e) {
    config = new JSONObject();
    suceptibleNumTB.text = "400";
    infectedNumTB.text = "20";
    renderLenTB.text = "10";
  }
}

void saveConfig() {
  config.setBoolean("renderEngine", renderEngineCheck.pressed);
  config.setBoolean("disableGraphs", graphsEngineCheck.pressed);
  config.setString("susceptibleNum", suceptibleNumTB.text);
  config.setString("infectedNum", infectedNumTB.text);
  config.setString("renderLen", renderLenTB.text);
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
