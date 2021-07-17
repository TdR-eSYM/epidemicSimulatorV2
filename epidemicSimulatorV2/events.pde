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
  if (mouseY > suceptibleNumTB.y && mouseY < suceptibleNumTB.y + suceptibleNumTB.sizey && mouseX > suceptibleNumTB.x && mouseX < suceptibleNumTB.x + suceptibleNumTB.sizex) {
    suceptibleNumTB.focus = true;
  } else {
    suceptibleNumTB.focus = false;
  }
  if (mouseY > infectedNumTB.y && mouseY < infectedNumTB.y + infectedNumTB.sizey && mouseX > infectedNumTB.x && mouseX < infectedNumTB.x + infectedNumTB.sizex) {
    infectedNumTB.focus = true;
  } else {
    infectedNumTB.focus = false;
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
