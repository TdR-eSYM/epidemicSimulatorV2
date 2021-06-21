class Button {
  int r;
  int g;
  int b;
  int x;
  int y;
  int sizex;
  int sizey;
  Button (int r, int g, int b, int x, int y, int sizex, int sizey) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.x = x;
    this.y = y;
    this.sizex = sizex;
    this.sizey = sizey;
  }
  void render() {

    if (mousePressed && ((mouseY > y && mouseY < y + sizey) && (mouseX > x && mouseX < x + sizex))) {
      fill ( r - 20, g - 20, b);
    } else { 
      fill (r, g, b);
    }
    rect (x, y, sizex, sizey);
  }
}

class TextBox {
  int x, y, sizex, sizey;
  String text = "";
  boolean focus = false;
  boolean release = true;
  color foreColor, backColor;
  TextBox(int x, int y, int sizex, int sizey, color foreColor, color backColor) {
    this.x = x;
    this.y = y;
    this.sizey = sizey;
    this.sizex = sizex;
    this.foreColor = foreColor;
    this.backColor = backColor;
  }

  void render() {
    if (focus) {
      fill(240);
    } else {
      fill(backColor);
    }
    rect(x, y, sizex, sizey/4);

    fill(foreColor);
    textSize(sizey/5);
    text(text, x + 7, y + sizey/5);
  }
}
