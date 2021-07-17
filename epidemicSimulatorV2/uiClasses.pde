class Graph {
  int x;
  int y;
  int sizex;
  int sizey;
  int [] gData;
  int index;
  color c;

  Graph (int x, int y, int sizex, int sizey, color c) {
    this.x = x;
    this.y = y;
    this.sizex = sizex;
    this.sizey = sizey;
    this.index = x;
    this.gData = new int[sizex + x];
    this.c = c;
  }
  void render() {
    if (sim.state != SimStates.STOPPED) {
      stroke (c);
      for (int i = 0; i < (sizex + x); i++) {
        if (gData[i] == 0) continue;
        line(i, gData[i], i, (sizey + y));
      }
      stroke(0);
    }
  }

  void update(int data, float agents) {
    if (index == sizex + x - 1) {
      clean();
    }
    if (sim.state == SimStates.RUNNING) {
      gData[index++] = y + sizey - int((data/agents)*sizey);
    }
  }

  private void clean() {
    for (int i = 0; i < sizex + x; i++) {
      gData[i] = 0;
    }
    index = x;
  }
}

class Button {
  String name;
  int r;
  int g;
  int b;
  int x;
  int y;
  int sizex;
  int sizey;
  Button (String name, int r, int g, int b, int x, int y, int sizex, int sizey) {
    this.name = name;
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
      buttonPressed(name);
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
  boolean blocked = false;
  color foreColor, backColor;
  TextBox(int x, int y, int sizex, int sizey, color foreColor, color backColor, boolean blocked) {
    this.x = x;
    this.y = y;
    this.sizey = sizey;
    this.sizex = sizex;
    this.foreColor = foreColor;
    this.backColor = backColor;
    this.blocked = blocked;
  }

  void render() {
    if (focus) {
      fill(100);
    } else {
      fill(backColor);
    }
    rect(x, y, sizex, sizey/4);

    fill(foreColor);
    textSize(sizey/5);
    text(text, x + 7, y + sizey/5);
  }
}
