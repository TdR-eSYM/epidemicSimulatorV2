void mouseClicked() {
//Textbox number of infected & agents
  if (mouseY > agents.y && mouseY < agents.y + agents.sizey && mouseX > agents.x && mouseX < agents.x + agents.sizex){
    agents.focus = true;
  } else {
    agents.focus = false;
  }
  if (mouseY > infectats.y && mouseY < infectats.y + infectats.sizey && mouseX > infectats.x && mouseX < infectats.x + infectats.sizex){
    infectats.focus = true;
  } else {
    infectats.focus = false;
  }
}

void keyPressed() {
  int n;
  if (agents.focus) {
    if(key == ''){ // I know, this is like the most hackiest thing ever and idk if will work in other os than windows. Let's just leave it for now ;)
      //Ctrl-v
      agents.text += GetTextFromClipboard();
      return;
    }
    switch(keyCode) {
    case 8:
      if (agents.text.length() != 0) {
        agents.text = agents.text.substring(0, agents.text.length()-1);
      }
      break;

    default:
     n = int(key);  
     n = n - 48;
     if(n >= 0 && n <= 9){
      if (keyCode > 31) agents.text += key;
      break;
     }
    }
  }
  if (infectats.focus) {
    if(key == ''){ // I know, this is like the most hackiest thing ever and idk if will work in other os than windows. Let's just leave it for now ;)
      //Ctrl-v
      infectats.text += GetTextFromClipboard();
      return;
    }
    switch(keyCode) {
    case 8:
      if (infectats.text.length() != 0) {
        infectats.text = infectats.text.substring(0, infectats.text.length()-1);
      }
      break;

     default:
     n = int(key);  
     n = n - 48;
     if(n >= 0 && n <= 9){
      if (keyCode > 31) infectats.text += key;
      break;
     }
    }
  }
}
