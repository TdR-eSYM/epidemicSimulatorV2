void keyPressed() {
  if (textBox.focus) {
    if(key == ''){ // I know, this is like the most hackiest thing ever and idk if will work in other os than windows. Let's just leave it for now ;)
      //Ctrl-v
      textBox.text += GetTextFromClipboard();
      return;
    }
    switch(keyCode) {
    case 8:
      if (textBox.text.length() != 0) {
        textBox.text = textBox.text.substring(0, textBox.text.length()-1);
      }
      break;


    default:
      if (keyCode > 31) textBox.text += key;
      break;
    }
  }
}
