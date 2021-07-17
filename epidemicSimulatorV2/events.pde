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
  
  //Won't execute if sim is running
  if(sim.state != SimStates.STOPPED) return;
  for (int i = 0; i < textBoxes.length; i++) {
    if (textBoxes[i].blocked) continue;
    if (mouseY > textBoxes[i].y && mouseY < textBoxes[i].y + textBoxes[i].sizey && mouseX > textBoxes[i].x && mouseX < textBoxes[i].x + textBoxes[i].sizex) {
      textBoxes[i].focus = true;
    } else {
      textBoxes[i].focus = false;
    }
  }
}

void keyPressed() {
  int n;
  for (int i = 0; i < textBoxes.length; i++) {
    if (textBoxes[i].focus) {
      if (key == '') { // I know, this is like the most hackiest thing ever and idk if will work in other os than windows. Let's just leave it for now ;)
        //Ctrl-v
        textBoxes[i].text += GetTextFromClipboard();
        return;
      }
      switch(keyCode) {
      case 8:
        if (textBoxes[i].text.length() != 0) {
          textBoxes[i].text = textBoxes[i].text.substring(0, textBoxes[i].text.length()-1);
        }
        break;

      default:
        n = int(key);  
        n = n - 48;
        if (n >= 0 && n <= 9) {
          if (keyCode > 31) textBoxes[i].text += key;
          break;
        }
      }
    }
  }
}
