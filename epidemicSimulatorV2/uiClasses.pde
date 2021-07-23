class Graph {
  int x;
  int y;
  int sizex;
  int sizey;
  int [] gData;
  int index;
  color c;
  boolean fill;

  Graph (int x, int y, int sizex, int sizey, color c, boolean fill) {
    this.x = x;
    this.y = y;
    this.sizex = sizex;
    this.sizey = sizey;
    this.index = x;
    this.gData = new int[sizex + x];
    this.c = c;
    this.fill = fill;
  }
  void render() {
    if (sim.state != SimStates.STOPPED) {
      stroke (c);
      for (int i = 0; i < (sizex + x); i++) {
        if (gData[i] == 0) continue;
        if(fill){
          line(i, gData[i], i, (sizey + y));
        }else{
          point(i, gData[i]);
        }
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
  boolean pressed = false;
  boolean blocked;
  Button (String name, int r, int g, int b, int x, int y, int sizex, int sizey, boolean blocked) {
    this.name = name;
    this.r = r;
    this.g = g;
    this.b = b;
    this.x = x;
    this.y = y;
    this.sizex = sizex;
    this.sizey = sizey;
    this.blocked = blocked;
  }
  void render() {

    if (pressed) {
      fill ( r - 20, g - 20, b);
      buttonPressed(name);
      pressed = false;
    } else { 
      fill (r, g, b);
    }
    if(blocked) fill ( r - 40, g - 40, b);
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
