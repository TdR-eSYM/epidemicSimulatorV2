void buttonPressed(String name) {
  switch(name) {
  case "stop":
    sim.stop();
    break;
  case "pause":
    sim.pause();
    break;
  case "start":
    sim.start();
    break;
  }
}

void mouseClicked() {
  //Textbox number of infected & agents
  for (int i = 0; i < textBoxes.length; i++) {
    if (mouseY > textBoxes[i].y && mouseY < textBoxes[i].y + textBoxes[i].sizey && mouseX > textBoxes[i].x && mouseX < textBoxes[i].x + textBoxes[i].sizex) {
      textBoxes[i].focus = true;
    } else {
      textBoxes[i].focus = false;
    }
  }
}

void keyPressed() {
  int n;
  if (suceptibleNumTB.focus) {
    if (key == '') { // I know, this is like the most hackiest thing ever and idk if will work in other os than windows. Let's just leave it for now ;)
      //Ctrl-v
      suceptibleNumTB.text += GetTextFromClipboard();
      return;
    }
    switch(keyCode) {
    case 8:
      if (suceptibleNumTB.text.length() != 0) {
        suceptibleNumTB.text = suceptibleNumTB.text.substring(0, suceptibleNumTB.text.length()-1);
      }
      break;

    default:
      n = int(key);  
      n = n - 48;
      if (n >= 0 && n <= 9) {
        if (keyCode > 31) suceptibleNumTB.text += key;
        break;
      }
    }
  }
  if (infectedNumTB.focus) {
    if (key == '') { // I know, this is like the most hackiest thing ever and idk if will work in other os than windows. Let's just leave it for now ;)
      //Ctrl-v
      infectedNumTB.text += GetTextFromClipboard();
      return;
    }
    switch(keyCode) {
    case 8:
      if (infectedNumTB.text.length() != 0) {
        infectedNumTB.text = infectedNumTB.text.substring(0, infectedNumTB.text.length()-1);
      }
      break;

    default:
      n = int(key);  
      n = n - 48;
      if (n >= 0 && n <= 9) {
        if (keyCode > 31) infectedNumTB.text += key;
        break;
      }
    }
  }
}
